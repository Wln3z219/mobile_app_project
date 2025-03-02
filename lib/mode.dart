import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_app_project/api/mongoapi.dart';
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

      setState(() {
        _modes = modesData;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching modes: $e");
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error message to the user.
    }
  }

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
        title: const Text("Select Mode"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_modes.isEmpty
              ? const Center(child: Text("No modes found!"))
              : ListView.builder(
                  itemCount: _modes.length,
                  itemBuilder: (context, index) {
                    final mode = _modes[index];
                    return ModeCard(mode: mode);
                  },
                )),
    );
  }
}

class ModeCard extends StatelessWidget {
  final Map<String, dynamic> mode;

  const ModeCard({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String base64Image = mode['images'] ?? "";
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
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                mode['mode'] ?? "No Mode Name",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8.0),
            if (imageBytes != null)
              Center(
                child: Image.memory(
                  imageBytes,
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
          ],
        ),
      ),
    );
  }
}
