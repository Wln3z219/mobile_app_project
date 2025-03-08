import 'package:flutter/material.dart';
import 'package:mobile_app_project/home_page.dart'; // Import your HomePage
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some initial loading or processing if needed
    _navigateToHome();
  }

  _navigateToHome() async{
    await Future.delayed(const Duration(seconds: 3), () {}); // Simulate a 3-second delay
    if(mounted){
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()), // Replace with your main page
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white], // Match your app's theme
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your app logo or any other image
              Image.asset(
                'assets/logo.png', // Replace with your image asset path
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                'Your App Name', // Replace with your app name
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Customize the text color
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black), // Customize the indicator color
              ),
            ],
          ),
        ),
      ),
    );
  }
}
