import 'package:flutter/material.dart';
import '../screens/jokes_list_screen.dart';

class JokeTypeCard extends StatelessWidget {
  final String type;

  JokeTypeCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JokesListScreen(type: type),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mood, size: 48),
              SizedBox(height: 8),
              Text(
                type.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
