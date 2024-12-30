import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/firebase_service.dart';
import '../widgets/joke_card.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Joke> favoriteJokes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);
    try {
      final jokes = await FirebaseService.getFavoriteJokes();
      setState(() {
        favoriteJokes = jokes;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load favorite jokes')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Jokes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteJokes.isEmpty
          ? Center(
        child: Text(
          'No favorite jokes yet!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: favoriteJokes.length,
        itemBuilder: (context, index) {
          return JokeCard(
            joke: favoriteJokes[index],
            onFavoriteChanged: (joke) {
              FirebaseService.removeFavoriteJoke(joke);
              _loadFavorites();
            },
          );
        },
      ),
    );
  }
}