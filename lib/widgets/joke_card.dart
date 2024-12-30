import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/firebase_service.dart';

class JokeCard extends StatefulWidget {
  final Joke joke;
  final Function(Joke)? onFavoriteChanged;

  JokeCard({
    required this.joke,
    this.onFavoriteChanged,
  });

  @override
  _JokeCardState createState() => _JokeCardState();
}

class _JokeCardState extends State<JokeCard> {
  bool _showPunchline = false;

  void _toggleFavorite() async {
    setState(() {
      widget.joke.isFavorite = !widget.joke.isFavorite;
    });

    try {
      if (widget.joke.isFavorite) {
        await FirebaseService.saveFavoriteJoke(widget.joke);
      } else {
        await FirebaseService.removeFavoriteJoke(widget.joke);
      }
      widget.onFavoriteChanged?.call(widget.joke);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.joke.setup,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 8),
            if (_showPunchline) ...[
              Text(
                widget.joke.punchline,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showPunchline = !_showPunchline;
                    });
                  },
                  child: Text(_showPunchline ? 'Hide Punchline' : 'Show Punchline'),
                ),
                IconButton(
                  icon: Icon(
                    widget.joke.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: widget.joke.isFavorite ? Colors.red : null,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}