import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Movielist extends StatefulWidget {
  const Movielist({super.key});

  @override
  State<Movielist> createState() => _MovielistState();
}

class _MovielistState extends State<Movielist> {
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie WatchList"),
        backgroundColor: Colors.greenAccent[400],
        centerTitle: true,
      ),
      body: movies.isEmpty
          ? const Center(
              child: Text("No movies"),
            )
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      movies[index]['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Genre: ${movies[index]['genre']}'),
                        Text(
                            'Watched: ${movies[index]['watched'] ? 'Yes' : 'No'}'),
                        if (movies[index]['watchDate'] != null)
                          Text(
                              'Watch Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(movies[index]['watchDate']))}'),
                        if (movies[index]['createdAt'] != null)
                          Text(
                              'Created At: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(movies[index]['createdAt']))}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        confirmDeleteDialog(movies[index]['id']);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> fetchMovies() async {
    // final response = await http.get(Uri.parse('http://192.168.1.64:8080/api/movies'));
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/movies'));

    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    } else {
      // Handle errors
      print('Failed to load movies');
    }
  }

  Future<void> deleteMovie(int id) async {
    final apiUrl = 'http://localhost:8080/api/movies/$id';
    // final apiUrl = 'http://192.168.1.64:8080/api/movies/$id';

    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 204) {
      // If deletion is successful, reload the movie list
      await fetchMovies();
    } else {
      // TODO: Handle errors
      print('Failed to delete movie');
    }
  }

  Future<void> confirmDeleteDialog(int id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this movie?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteMovie(id);
              },
            ),
          ],
        );
      },
    );
  }
}