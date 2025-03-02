// c:\Users\UsEr\Desktop\Mobile_Pro\mobile_app_project\lib\api\mongoapi.dart
import 'dart:developer';
import 'dart:typed_data';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';

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
      // Find the first document in the collection
      final imageDocument = await userCollection.findOne();

      if (imageDocument != null) {
        // Get the image data from the 'picture' field
        final base64String = imageDocument['picture'];

        if (base64String != null && base64String is String) {
          // Decode the base64 string to Uint8List
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

  static Future<List<Map<String, dynamic>>> getQuestions() async {
    try {
      var collection = db.collection("Question");
      List<Map<String, dynamic>> questions = await collection.find().toList();
      return questions;
    } catch (e) {
      print('Error fetching questions: $e');
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
