import 'dart:math';
import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  final List<String> selectedItems; // List of selected items passed from HomePage
  const QuestionPage({super.key, required this.selectedItems});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'correctAnswer': 'Paris',
      'wrongAnswers': ['London', 'Berlin', 'Madrid', 'Rome', 'Lisbon', 'Athens', 'Vienna', 'Stockholm', 'Copenhagen'],
    },
    {
      'question': 'Which animal is known as the king of the jungle?',
      'correctAnswer': 'Lion',
      'wrongAnswers': ['Tiger', 'Elephant', 'Giraffe', 'Bear', 'Zebra', 'Leopard', 'Monkey', 'Cheetah', 'Rhino'],
    },
    // Add more questions here...
  ];

  late String _question;
  late String _correctAnswer;
  late List<String> _answers;
  late int _correctAnswerIndex;
  List<String> _itemsEarned = []; // List of items earned by answering questions correctly

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  // Function to generate a new random question
  void _generateNewQuestion() {
    final random = Random();
    final questionData = _questions[random.nextInt(_questions.length)];
    _question = questionData['question']!;
    _correctAnswer = questionData['correctAnswer']!;
    List<String> wrongAnswers = List<String>.from(questionData['wrongAnswers']);
    wrongAnswers.shuffle();

    // Select 9 random wrong answers
    _answers = [ _correctAnswer ] + wrongAnswers.take(9).toList();
    _answers.shuffle();

    // Find index of correct answer
    _correctAnswerIndex = _answers.indexOf(_correctAnswer);

    setState(() {});
  }

  // Function to handle when an answer button is pressed
  void _handleAnswer(int index) {
    String message = (index == _correctAnswerIndex) ? 'Correct!' : 'Wrong! The correct answer is $_correctAnswer.';
    if (index == _correctAnswerIndex) {
      // Add item to earned items if the answer is correct
      _itemsEarned.add('Hint: Skip a Question'); // You can randomly add earned items
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _generateNewQuestion(); // Load new question after answer
            },
            child: const Text('Next Question'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Question Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _question,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < _answers.length; i++)
              ElevatedButton(
                onPressed: () => _handleAnswer(i),
                child: Text(_answers[i]),
              ),
            const SizedBox(height: 20),
            Text('Items Earned: ${_itemsEarned.join(', ')}'),
            const SizedBox(height: 20),
            Text('Items Selected Before Quiz: ${widget.selectedItems.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
