import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_app_project/aboutuspage.dart';
import 'package:mobile_app_project/mode.dart';
import 'package:mobile_app_project/historypage.dart'; // Import HistoryPage
import 'api/mongoapi.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return MaterialApp(
      title: 'Flutter English Question',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: const AppBarTheme(color: Colors.white)),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.graduationCap,
                color: Colors.black,
              ), // Add icon
              SizedBox(width: 10), // Space between icon and text
              Text("Welcome to Quiz"),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      100,
                      (index) => Image.asset(
                        "assets/background.png",
                        width: 200,
                        height: 200, 
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
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
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ModeSelectPage(),
                              ),
                            );
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.gamepad,
                            color: Colors.white,
                          ),
                          label: Text('Select Mode'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryPage(),
                              ),
                            );
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.rectangleList,
                            color: Colors.white,
                          ),
                          label: Text('History'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Aboutuspage(),
                              ),
                            );
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.userGroup,
                            color: Colors.white,
                          ),
                          label: Text('About us'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
