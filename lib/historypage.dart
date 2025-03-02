import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString('history');
      if (historyString != null) {
        List<dynamic> decodedHistory = jsonDecode(historyString);
        _history = decodedHistory.map((item) => item as Map<String, dynamic>).toList();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading history: $e');
        setState(() {
        _isLoading = false;
      });
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
        title: const Text('History'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? const Center(child: Text('No history yet!'))
              : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final historyEntry = _history[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Name: ${historyEntry['name']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text('Mode: ${historyEntry['mode']}'),
                             Text('Score: ${historyEntry['score']}'),
                          ],
                        ),
                        trailing: Text(historyEntry['timestamp']),
                      ),
                    );
                  },
                ),
    );
  }
}

// Function to save history
Future<void> saveHistory(String name,String mode, int score) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String timestamp = DateTime.now().toString().substring(0, 19); // Get current timestamp
    // Structure of a history entry
    Map<String, dynamic> newHistoryEntry = {
      'name':name,
      'mode': mode,
      'score': score,
      'timestamp': timestamp
    };

    String? historyString = prefs.getString('history');
    List<Map<String, dynamic>> history;

    if (historyString != null) {
      // If history already exists, add the new entry to it
      List<dynamic> decodedHistory = jsonDecode(historyString);
      history = decodedHistory.map((item) => item as Map<String, dynamic>).toList();
      history.add(newHistoryEntry);
    } else {
      // If history doesn't exist yet, create a new list with the new entry
      history = [newHistoryEntry];
    }

    // Save the updated history
    await prefs.setString('history', jsonEncode(history));
    print('History saved successfully.');
  } catch (e) {
    print('Error saving history: $e');
  }
}
