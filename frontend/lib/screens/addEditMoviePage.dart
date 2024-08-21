import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/authService.dart';
import 'package:frontend/screens/movieList.dart';
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
  bool isEditMode = false;
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();

    if (widget.movieData != null) {
      isEditMode = true;
      titleController.text = widget.movieData!['title'] ?? '';
      genreController.text = widget.movieData!['genre'] ?? '';

      if (widget.movieData!['watchDate'] != null) {
        watchDate = DateTime.parse(widget.movieData!['watchDate']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Movie' : 'Add Movie', style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 90, 201, 47),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: titleController,
                label: 'Title',
                icon: Icons.movie,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: genreController,
                label: 'Genre',
                icon: Icons.category,
              ),
              SizedBox(height: 20),
              _buildDateField(),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveOrUpdateMovie,
                child: Text(
                  isEditMode ? 'Update Movie' : 'Save Movie',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 90, 201, 47),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color.fromARGB(255, 90, 201, 47)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color.fromARGB(255, 90, 201, 47), width: 2),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
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
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Watch Date',
          prefixIcon: Icon(Icons.calendar_today, color: Color.fromARGB(255, 90, 201, 47)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color.fromARGB(255, 90, 201, 47), width: 2),
          ),
        ),
        child: Text(
          watchDate != null
              ? DateFormat('dd/MM/yyyy').format(watchDate!)
              : 'Select Date',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _saveOrUpdateMovie() async {
    final String title = titleController.text;
    final String genre = genreController.text;

    if (title.isEmpty || genre.isEmpty) {
      _showSnackBar('Please fill in all fields', Colors.red);
      return;
    }

    final token = await _authService.getToken();
    final apiUrl = dotenv.env['API_URL'] ?? '';

    final movieData = {
      'title': title,
      'genre': genre,
      'watchDate': watchDate != null ? DateFormat('yyyy-MM-dd').format(watchDate!) : null,
    };

    http.Response response;

    if (isEditMode) {
      response = await http.put(
        Uri.parse('$apiUrl/api/movies/${widget.movieId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(movieData),
      );
    } else {
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
      _showSnackBar(
        isEditMode ? 'Movie updated successfully' : 'Movie added successfully',
        Colors.green,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Movielist()),
      );
    } else {
      _showSnackBar('Failed to save movie. Please try again.', Colors.red);
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}