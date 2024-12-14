import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JokesByTypeScreen extends StatefulWidget {
  final String type;

  JokesByTypeScreen({required this.type});

  @override
  _JokesByTypeScreenState createState() => _JokesByTypeScreenState();
}

class _JokesByTypeScreenState extends State<JokesByTypeScreen> {
  List<dynamic> jokes = [];

  @override
  void initState() {
    super.initState();
    fetchJokesByType();
  }

  Future<void> fetchJokesByType() async {
    final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/jokes/${widget.type}/ten'));
    if (response.statusCode == 200) {
      List<dynamic> jokeList = json.decode(response.body);
      setState(() {
        jokes = jokeList;
      });
    } else {
      throw Exception('Failed to load jokes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jokes of Type: ${widget.type}')),
      body: ListView.builder(
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(jokes[index]['setup']),
              subtitle: Text(jokes[index]['punchline']),
            ),
          );
        },
      ),
    );
  }
}
