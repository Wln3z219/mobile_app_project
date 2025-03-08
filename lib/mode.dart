import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_app_project/api/mongoapi.dart';
import 'package:mobile_app_project/detailpage.dart';
import 'dart:convert';

class ModeSelectPage extends StatefulWidget {
  const ModeSelectPage({Key? key}) : super(key: key);

  @override
  State<ModeSelectPage> createState() => _ModeSelectPageState();
}

class _ModeSelectPageState extends State<ModeSelectPage> {
  List<Map<String, dynamic>> _modes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchModes();
  }

  Future<void> _fetchModes() async {
    try {
      List<Map<String, dynamic>> modesData = await MongoDatabase.getModes();
      print("data modes : $modesData");
      setState(() {
        _modes = modesData;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching modes: $e");
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
        title: const Text("Select Mode"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 75),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : (_modes.isEmpty
                    ? const Center(child: Text("No modes found!"))
                    : GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columns
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: _modes.length,
                      itemBuilder: (context, index) {
                        final mode = _modes[index];
                        return ModeCard(mode: mode);
                      },
                    )),
      ),
    );
  }
}

class ModeCard extends StatelessWidget {
  final Map<String, dynamic> mode;

  const ModeCard({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String base64Image = mode['image'] ?? "";
    Uint8List? imageBytes;
    try {
      if (base64Image.isNotEmpty) {
        imageBytes = base64.decode(base64Image);
      }
    } catch (e) {
      print('Error decoding image: $e');
      imageBytes = null;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DetailPage(
                  modeName: mode['mode'],
                ), // Navigate to DetailPage and pass modeName
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageBytes != null)
                Expanded(
                  child: Center(
                    child: Image.memory(imageBytes, fit: BoxFit.contain),
                  ),
                ),
              const SizedBox(height: 8.0), // Space between image and text
              Text(
                mode['mode'] ?? "No Mode Name",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
