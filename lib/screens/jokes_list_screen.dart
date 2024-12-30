import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/api_services.dart';
import '../widgets/joke_card.dart';

class JokesListScreen extends StatefulWidget {
  final String type;

  JokesListScreen({required this.type});

  @override
  _JokesListScreenState createState() => _JokesListScreenState();
}

class _JokesListScreenState extends State<JokesListScreen> {
  final ApiServices _apiServices = ApiServices();
  List<Joke> jokes = [];

  @override
  void initState() {
    super.initState();
    _loadJokes();
  }

  Future<void> _loadJokes() async {
    try {
      final loadedJokes = await _apiServices.getJokesByType(widget.type);
      setState(() {
        jokes = loadedJokes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load jokes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} Jokes'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          return JokeCard(joke: jokes[index]);
        },
      ),
    );
  }
}