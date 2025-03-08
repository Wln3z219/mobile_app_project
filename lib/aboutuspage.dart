import 'package:flutter/material.dart';
import 'package:mobile_app_project/api/mongoapi.dart';
import 'dart:convert';
import 'dart:typed_data';

class Aboutuspage extends StatefulWidget {
  const Aboutuspage({super.key});

  @override
  State<Aboutuspage> createState() => _AboutuspageState();
}

class _AboutuspageState extends State<Aboutuspage> {
  List<Map<String, dynamic>> _aboutUsData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAboutUsData();
  }

  Future<void> _fetchAboutUsData() async {
    try {
      List<Map<String, dynamic>> data =
          await MongoDatabase.getAboutUsData("About Us");
      setState(() {
        _aboutUsData = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching About Us data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Center(child: Text("About us")),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : (_aboutUsData.isEmpty
                ? const Center(child: Text("No About Us data found!"))
                : ListView.builder(
                    itemCount: _aboutUsData.length,
                    itemBuilder: (context, index) {
                      final person = _aboutUsData[index];
                      return AboutUsCard(person: person);
                    },
                  )),
      ),
    );
  }
}

class AboutUsCard extends StatelessWidget {
  final Map<String, dynamic> person;

  const AboutUsCard({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String base64Image = person['image'] ?? "";
    Uint8List? imageBytes;
    try {
      if (base64Image.isNotEmpty) {
        imageBytes = base64.decode(base64Image);
      }
    } catch (e) {
      print('Error decoding image: $e');
      imageBytes = null;
    }

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            if (imageBytes != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: MemoryImage(imageBytes),
              ),
            const SizedBox(height: 10),
            Text(
              person['name'] ?? "No Name",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              person['position'] ?? "No Position",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}