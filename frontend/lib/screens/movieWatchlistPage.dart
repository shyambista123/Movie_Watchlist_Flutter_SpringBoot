import 'package:flutter/material.dart';

class MovieWatchlistPage extends StatelessWidget {
  final List<Map<String, dynamic>> moviesWatchlist;

  const MovieWatchlistPage({super.key, required this.moviesWatchlist});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: moviesWatchlist.length,
      itemBuilder: (context, index) {
        final movie = moviesWatchlist[index];
        return ListTile(
          title: Text(movie['title'] ?? 'No Title'),
          subtitle: Text('Genre: ${movie['genre'] ?? 'No Genre'}'),
        );
      },
    );
  }
}
