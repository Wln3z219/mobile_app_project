import 'package:flutter/material.dart';
import 'package:mobile_app_project/home_page.dart';
import 'package:mobile_app_project/historypage.dart'; // Import historypage

class ScorePage extends StatelessWidget {
  final int score;

  const ScorePage({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Score"),
        automaticallyImplyLeading: false, //remove back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Final Score:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "$score / 5",
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton( // Add home button
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false, // Remove all routes
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0), // Increase padding
              ),
              child: const Text(
                "Go to Home",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
