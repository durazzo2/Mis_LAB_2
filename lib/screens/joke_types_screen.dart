import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'jokes_by_type_screen.dart';
import 'random_joke_screen.dart';  // Import the Random Joke screen

class JokeTypesScreen extends StatefulWidget {
  @override
  _JokeTypesScreenState createState() => _JokeTypesScreenState();
}

class _JokeTypesScreenState extends State<JokeTypesScreen> {
  List<String> jokeTypes = [];

  @override
  void initState() {
    super.initState();
    fetchJokeTypes();
  }

  Future<void> fetchJokeTypes() async {
    final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/types'));
    if (response.statusCode == 200) {
      List<String> types = List<String>.from(json.decode(response.body));
      setState(() {
        jokeTypes = types;
      });
    } else {
      throw Exception('Failed to load joke types');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.casino),  // Icon for Random Joke button
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomJokeScreen()),  // Navigate to Random Joke screen
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: jokeTypes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(jokeTypes[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JokesByTypeScreen(type: jokeTypes[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
