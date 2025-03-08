import 'dart:developer';
import 'dart:typed_data';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';
import 'dart:math';

import 'constant.dart';

class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(COLLECTION_NAME);
  }

  static Future<Uint8List?> getImageData() async {
    try {
      final imageDocument = await userCollection.findOne();

      if (imageDocument != null) {
        final base64String = imageDocument['picture'];

        if (base64String != null && base64String is String) {
          return base64.decode(base64String);
        } else {
          print('imageData is null or not a String');
          return null;
        }
      } else {
        print('No image document found.');
        return null;
      }
    } catch (e) {
      print('Error fetching or decoding image: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getAboutUsData(String collectionName) async {
    try {
      var collection = db.collection(collectionName);
      List<Map<String, dynamic>> aboutUsData = await collection.find().toList();
      return aboutUsData;
    } catch (e) {
      print('Error fetching About Us data: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getQuestions(String collectionName) async {
    try {
      var collection = db.collection(collectionName);
      final count = await collection.count();
      print("count is $count");
      if (count == 0) {
        return [];
      }
    // Fetch all the questions
      List<Map<String, dynamic>> allQuestions = await collection.find().toList();

    // Shuffle the list of questions to ensure randomness
      allQuestions.shuffle();

    // Take only the first 5 questions (or fewer if there are not enough)
    int numberOfQuestionsToReturn = min(5, allQuestions.length);
    List<Map<String, dynamic>> randomQuestions = allQuestions.sublist(0, numberOfQuestionsToReturn);
      print("question is $randomQuestions");
      return randomQuestions;
    } catch (e) {
      print('Error fetching random question: $e');
      return [];
    }
  }
  static Future<List<Map<String, dynamic>>> getQuestionsByMode(String collectionName, String modeName) async {
    try {
      var collection = db.collection(collectionName);
      final count = await collection.count();
      print("count is $count");
      if (count == 0) {
        return [];
      }

      // Fetch all questions related to the mode
      List<Map<String, dynamic>> allQuestions = await collection.find(where.eq('mode', modeName)).toList();
      print("mode is $modeName");
      // Shuffle the list of questions to ensure randomness
      allQuestions.shuffle();

      // Take only the first 5 questions (or fewer if there are not enough)
      int numberOfQuestionsToReturn = min(5, allQuestions.length);
      List<Map<String, dynamic>> randomQuestions = allQuestions.sublist(0, numberOfQuestionsToReturn);
      print("question is $randomQuestions");
      return randomQuestions;
    } catch (e) {
      print('Error fetching random question: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getModes() async {
    try {
      var collection = db.collection("Mode");
      List<Map<String, dynamic>> modes = await collection.find().toList();
      return modes;
    } catch (e) {
      print('Error fetching modes: $e');
      return [];
    }
  }
}
