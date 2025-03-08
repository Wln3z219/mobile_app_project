import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_app_project/api/mongoapi.dart';
import 'package:mobile_app_project/scorepage.dart'; // Import ScorePage

class QuestionPage extends StatefulWidget {
  final Map<String, dynamic> mode;

  const QuestionPage({Key? key, required this.mode}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Map<String, dynamic>? _question;
  bool _isLoading = true;
  String? _selectedAnswer;
  int _currentQuestionIndex = 0;
  int _score = 0;
  List<Map<String, dynamic>> _questions = [];
  bool _answerChecked = false;
  String _collectionName = "";
  List<Map<String, dynamic>> _allQuestions = [];

  @override
  void initState() {
    super.initState();
    _assignCollectionName();
    _fetchQuestions();
  }

  void _assignCollectionName() {
    _collectionName = widget.mode['mode'];
    print("Collection name: $_collectionName");
  }

  Future<void> _fetchQuestions() async {
    try {
      print("Fetching data from $_collectionName");
      _allQuestions = await MongoDatabase.getQuestions(_collectionName);

      List<Map<String, dynamic>> filteredQuestion = _allQuestions
          .where((q) =>
              q['mode'] == widget.mode['mode'] && q['question'] != null)
          .toList();

      if (filteredQuestion.isNotEmpty) {
        _questions = filteredQuestion;
        _loadRandomQuestion();
      } else {
        print(
            "No questions found for mode: ${widget.mode['mode']} in collection $_collectionName");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching questions: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _loadRandomQuestion() {
    if (_questions.isEmpty) {
      _goToScorePage();
      return;
    }
    if (_currentQuestionIndex >= _allQuestions.length) {
      _goToScorePage();
      return;
    }

    setState(() {
      _question = _questions[_currentQuestionIndex];
      _isLoading = false;
      _answerChecked = false;
    });
  }

  void _handleAnswerSelected(String choice) {
    setState(() {
      _selectedAnswer = choice;
      _answerChecked = true;
    });

    _checkAnswer();
  }

  void _checkAnswer() {
    bool isCorrect = _selectedAnswer == _question?['answer'];
    _showAnswerResultDialog(isCorrect);
  }

  void _showAnswerResultDialog(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorrect ? "Correct!" : "Wrong!"),
          content: Text(isCorrect
              ? "You got it right!"
              : "The correct answer is ${_question?['answer']}."),
          actions: <Widget>[
            TextButton(
              child: const Text("Next Question"),
              onPressed: () {
                Navigator.of(context).pop();
                _nextQuestion();
              },
            ),
          ],
        );
      },
    );
  }

  void _nextQuestion() {
    setState(() {
      if (_selectedAnswer == _question?['answer']) {
        _score++;
      }
      _selectedAnswer = null;
      _currentQuestionIndex++;
    });
    _loadRandomQuestion();
  }

  void _goToScorePage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ScorePage(score: _score, mode: widget.mode['mode'])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind app bar
      appBar: AppBar(
        title: Text("Questions - ${widget.mode['mode']}"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightBlueAccent,
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : (_question == null
                ? const Center(child: Text("No questions found!"))
                : QuestionCard(
                    question: _question!,
                    onAnswerSelected: _handleAnswerSelected,
                    selectedAnswer: _selectedAnswer,
                    answerChecked: _answerChecked,
                  )),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswerSelected;
  final String? selectedAnswer;
  final bool answerChecked;

  const QuestionCard({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    this.selectedAnswer,
    required this.answerChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String base64Image = question['image'] ?? "";
    Uint8List? imageBytes;
    try {
      if (base64Image.isNotEmpty) {
        imageBytes = base64.decode(base64Image);
      }
    } catch (e) {
      print('Error decoding image: $e');
      imageBytes = null;
    }

    List<dynamic> choices =
        question['choices'] != null && question['choices'] is List
            ? question['choices'] as List<dynamic>
            : [];

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (if available)
            if (imageBytes != null)
              Center(
                child: Image.memory(
                  imageBytes,
                  width: 200,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16.0),

            // Question Text
            Center(
              child: Text(
                question['question'] ?? "No Question Text",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),

            // Answer Choices (now in a Grid)
            Expanded(
              child: Center(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // Prevent scrolling
                  padding: const EdgeInsets.all(8.0),
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3,
                  children: choices
                      .map((choice) => GestureDetector(
                            onTap: answerChecked
                                ? null
                                : () {
                                    onAnswerSelected(choice);
                                  },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: selectedAnswer == choice
                                    ? Colors.blue.withOpacity(0.5)
                                    : null,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                  child: Text(
                                choice,
                                textAlign: TextAlign.center,
                              )),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}