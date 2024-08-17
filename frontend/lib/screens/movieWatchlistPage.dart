import 'package:flutter/material.dart';

class MovieWatchlistPage extends StatelessWidget {
  final List<Map<String, dynamic>> moviesWatchlist;

  const MovieWatchlistPage({super.key, required this.moviesWatchlist});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0), 
      itemCount: moviesWatchlist.length,
      itemBuilder: (context, index) {
        final movie = moviesWatchlist[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0), 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), 
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: movie['image'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      movie['image'],
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.movie, size: 60, color: Colors.grey[600]),
            title: Text(
              movie['title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Genre: ${movie['genre'] ?? 'No Genre'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
        );
      },
    );
  }
}
