import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/auth_service.dart';
import 'package:frontend/screens/movielist.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddEditMoviePage extends StatefulWidget {
  final String? movieId;
  final Map<String, dynamic>? movieData;

  const AddEditMoviePage({this.movieId, this.movieData, Key? key}) : super(key: key);

  @override
  _AddEditMoviePageState createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  DateTime? watchDate;
  bool watched = false;
  bool isEditMode = false;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();

    // Check if we are in edit mode
    if (widget.movieData != null) {
      isEditMode = true;
      titleController.text = widget.movieData!['title'] ?? '';
      genreController.text = widget.movieData!['genre'] ?? '';
      watched = widget.movieData!['watched'] ?? false;

      if (widget.movieData!['watchDate'] != null) {
        watchDate = DateTime.parse(widget.movieData!['watchDate']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Movie' : 'Add Movie'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: genreController,
              decoration: InputDecoration(labelText: 'Genre'),
            ),
            CheckboxListTile(
              title: Text('Watched'),
              value: watched,
              onChanged: (bool? value) {
                setState(() {
                  watched = value ?? false;
                });
              },
            ),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Watch Date',
                hintText: watchDate != null
                    ? DateFormat('dd/MM/yyyy').format(watchDate!)
                    : 'Select Date',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: watchDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    watchDate = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveOrUpdateMovie,
              child: Text(isEditMode ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveOrUpdateMovie() async {
    final String title = titleController.text;
    final String genre = genreController.text;

    if (title.isEmpty || genre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final token = await _authService.getToken();
    final apiUrl = dotenv.env['API_URL'] ?? '';

    final movieData = {
      'title': title,
      'genre': genre,
      'watched': watched,
      'watchDate': watchDate != null ? DateFormat('yyyy-MM-dd').format(watchDate!) : null,
    };

    http.Response response;

    if (isEditMode) {
      // Update existing movie
      response = await http.put(
        Uri.parse('$apiUrl/api/movies/${widget.movieId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(movieData),
      );
    } else {
      // Create new movie
      response = await http.post(
        Uri.parse('$apiUrl/api/movies'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(movieData),
      );
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditMode ? 'Movie updated successfully' : 'Movie added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Movielist()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save movie. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
