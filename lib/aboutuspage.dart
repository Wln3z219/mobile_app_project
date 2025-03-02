import 'package:flutter/material.dart';

class Aboutuspage extends StatelessWidget {
  const Aboutuspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(child: Text("About us")),
      ),
      body: const Column(
        // Add your about us content here
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("This is the About Us Page")),
        ],
      ),
    );
  }
}
