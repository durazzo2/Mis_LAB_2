import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../services/api_services.dart';

class RandomJokeScreen extends StatefulWidget {
  @override
  _RandomJokeScreenState createState() => _RandomJokeScreenState();
}

class _RandomJokeScreenState extends State<RandomJokeScreen> {
  final ApiServices _apiServices = ApiServices();
  Joke? joke;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRandomJoke();
  }

  Future<void> _loadRandomJoke() async {
    setState(() => isLoading = true);
    try {
      final randomJoke = await _apiServices.getRandomJoke();
      setState(() {
        joke = randomJoke;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load random joke')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke of the Day'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                joke?.setup ?? '',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                joke?.punchline ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadRandomJoke,
                child: Text('Get Another Joke'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}