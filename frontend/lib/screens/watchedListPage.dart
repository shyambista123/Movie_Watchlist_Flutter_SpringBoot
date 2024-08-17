import 'package:flutter/material.dart';

class WatchedListPage extends StatelessWidget {
  final List<Map<String, dynamic>> moviesWatched;

  const WatchedListPage({super.key, required this.moviesWatched});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: moviesWatched.length,
      itemBuilder: (context, index) {
        final movie = moviesWatched[index];
        return ListTile(
          title: Text(movie['title'] ?? 'No Title'),
          subtitle: Text('Genre: ${movie['genre'] ?? 'No Genre'}'),
        );
      },
    );
  }
}
