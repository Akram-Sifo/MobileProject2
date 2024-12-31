import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Subject.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.deepPurple[110],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          labelStyle: TextStyle(color: Colors.deepPurple),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.deepPurple[800]),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Subjects Page',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255))),
          backgroundColor: const Color.fromARGB(255, 146, 20, 185),
          centerTitle: true,
          elevation: 0,
        ),
        body: const SubjectsSection(),
      ),
    );
  }
}

class SubjectsSection extends StatefulWidget {
  const SubjectsSection({super.key});

  @override
  State<SubjectsSection> createState() => _SubjectsSectionState();
}

class _SubjectsSectionState extends State<SubjectsSection> {
  List subjects = [];

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  void loadSubjects() async {
    const url = 'http://sifoproject2.atwebpages.com/getsubjects.php';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('API Response: ${response.body}'); // Debugging print
      final data = json.decode(response.body);
      if (data is List) {
        setState(() {
          subjects = data.map((obj) {
            return Subject(
              name: obj['name'] ?? 'Unknown',
              description: obj['description'] ?? 'No description',
              credits: int.tryParse(obj['credits'].toString()) ?? 0,
            );
          }).toList();
        });
      } else {
        print('Unexpected data format: ${data.runtimeType}');
      }
    } else {
      print('Error fetching subjects: ${response.statusCode}');
    }
  }

  void searchSubjects(String name) async {
    final url =
        'http://sifoproject2.atwebpages.com/searchsubjects.php?name=$name';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Response: ${response.body}'); // Debugging
      final data = json.decode(response.body);
      setState(() {
        subjects = (data as List).map((obj) {
          return Subject(
            name: obj['name'] ?? 'Unknown',
            description: obj['description'] ?? 'No description',
            credits: int.tryParse(obj['credits'].toString()) ?? 0,
          );
        }).toList();
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: (name) {
              searchSubjects(name);
            },
            decoration: const InputDecoration(
              labelText: 'Search Subjects',
              prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: subjects.isEmpty
                ? const Center(
                    child: Text(
                      'No subjects found.',
                      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                    ),
                  )
                : ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          tileColor: Colors.deepPurple[50],
                          title: Text(
                            subjects[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          ),
                          subtitle: Text(
                            'Description: ${subjects[index].description}\nCredits: ${subjects[index].credits}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.deepPurple),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
