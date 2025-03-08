import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_app_project/aboutuspage.dart';
import 'package:mobile_app_project/mode.dart';
import 'package:mobile_app_project/historypage.dart';
import 'api/mongoapi.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Uint8List?>? _imageDataFuture;

  @override
  void initState() {
    super.initState();
    _imageDataFuture = MongoDatabase.getImageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Welcome to Quiz",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            //add line
            Container(
              height: 1,
              color: Colors.grey[400],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: FutureBuilder<Uint8List?>(
                    future: _imageDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return Image.memory(
                          snapshot.data!,
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const Text('No image data found.');
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Select mode button
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ModeSelectPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Select Mode'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // History button
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HistoryPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center the row content
                          children: [
                            Icon(Icons.history),
                            SizedBox(width: 8), // Add a space between icon and text
                            Text('History'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // About us button
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Aboutuspage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('About us'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
