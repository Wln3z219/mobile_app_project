import 'package:flutter/material.dart';
import 'package:mobile_app_project/home_page.dart';
import 'package:mobile_app_project/historypage.dart'; // Import the history page

class ScorePage extends StatefulWidget {
  final int score;
  final String mode; // Add mode parameter

  const ScorePage({Key? key, required this.score, required this.mode})
      : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _saveHistoryAndNavigateHome() async {
    if (_nameController.text.trim().isEmpty) {
      // Show an error if the name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your name."),
        ),
      );
      return;
    }
    setState(() {
      _isSaving = true;
    });
    try {
      await saveHistory(
          _nameController.text.trim(), widget.mode, widget.score); // Save the history
      // Navigate back to the home page after saving
      if (mounted) {
        _navigateToHome();
      }
    } catch (e) {
      print("Error while saving to history: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving history : $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Score"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Your Final Score:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "${widget.score} / 5",
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Your Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _isSaving
                  ? const CircularProgressIndicator()
                  : Column( // Changed Row to Column
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _saveHistoryAndNavigateHome,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                          ),
                          child: const Text(
                            "Save and Go to Home",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                         const SizedBox(height: 20), // added a SizedBox for spacing
                        ElevatedButton(
                          onPressed: _navigateToHome,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                          ),
                          child: const Text(
                            "Go to Home",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
