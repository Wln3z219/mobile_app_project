import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_app_project/api/mongoapi.dart';
import 'package:mobile_app_project/questionpage.dart';

class DetailPage extends StatefulWidget {
  final String modeName;

  const DetailPage({Key? key, required this.modeName}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? _modeDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchModeDetail();
  }

  Future<void> _fetchModeDetail() async {
    try {
      List<Map<String, dynamic>> modesData = await MongoDatabase.getModes();
      //filter to get only the selected mode
      List<Map<String, dynamic>> filteredMode =
          modesData.where((mode) => mode['mode'] == widget.modeName).toList();

      if (filteredMode.isNotEmpty) {
        setState(() {
          _modeDetail = filteredMode[0];
          _isLoading = false;
        });
      } else {
        setState(() {
          _modeDetail = null;
          _isLoading = false;
        });
      }

      print("Detail data: $_modeDetail");
    } catch (e) {
      print("Error fetching mode detail: $e");
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
        title: Text(widget.modeName , style: TextStyle(fontWeight: FontWeight.bold ),), // Use the passed modeName
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 75),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.white],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : (_modeDetail == null
                ? const Center(child: Text("Mode detail not found!"))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ModeDetailCard(modeDetail: _modeDetail!),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuestionPage(mode: _modeDetail!),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                            ),
                          ),
                          child: const Text(
                            "Start Game",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )),
      ),
    );
  }
}

class ModeDetailCard extends StatelessWidget {
  final Map<String, dynamic> modeDetail;

  const ModeDetailCard({Key? key, required this.modeDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String base64Image = modeDetail['image'] ?? "";
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
      elevation: 5,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageBytes != null
                    ? Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : const Center(child: Text("No Image")),
              ),
            ),
            const SizedBox(height: 20),

            // Mode Name
            Text(
              modeDetail['mode'] ?? "No Mode",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Detail
            Text(
              modeDetail['detail'] ?? "No detail available",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
