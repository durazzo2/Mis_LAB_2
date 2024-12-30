import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../widgets/joke_type_card.dart';
import 'random_joke_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiServices _apiServices = ApiServices();
  List<String> jokeTypes = [];

  @override
  void initState() {
    super.initState();
    _loadJokeTypes();
  }

  Future<void> _loadJokeTypes() async {
    try {
      final types = await _apiServices.getJokeTypes();
      setState(() {
        jokeTypes = types;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load joke types')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.casino),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomJokeScreen()),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: jokeTypes.length,
        itemBuilder: (context, index) {
          return JokeTypeCard(type: jokeTypes[index]);
        },
      ),
    );
  }
}
