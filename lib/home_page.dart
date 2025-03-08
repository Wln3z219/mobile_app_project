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
        title: const Text("Welcome to Quiz"),
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
                padding: const EdgeInsets.only(top : 60),
                child: Center(
                  child: FutureBuilder<Uint8List?>(
                    future: _imageDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ModeSelectPage()),
                        );
                      },
                      child: const Text('Select Mode'),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HistoryPage()),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history),
                          SizedBox(width: 8),
                          Text('History'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Aboutuspage()),
                        );
                      },
                      child: const Text('About us'),
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
