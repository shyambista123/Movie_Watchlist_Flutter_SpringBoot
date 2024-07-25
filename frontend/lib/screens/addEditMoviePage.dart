import 'package:flutter/material.dart';

class AddEditMoviePage extends StatefulWidget {
  const AddEditMoviePage({super.key});

  @override
  State<AddEditMoviePage> createState() => _AddEditMoviePageState();
}

class _AddEditMoviePageState extends State<AddEditMoviePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  DateTime watchDate = DateTime.now(); // Initialize with current date/time

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Movie", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: titleController,
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Genre",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: genreController,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Watch Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(
                  "${watchDate.year}-${watchDate.month}-${watchDate.day}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: (){
              print(titleController.text);
              print(genreController.text);
              print(watchDate);
              print("add movie clicked");
            }, 
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                            "Add Movie",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: watchDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != watchDate) {
      // Date selected, update state
      setState(() {
        watchDate = pickedDate;
      });
    }
  }
}
