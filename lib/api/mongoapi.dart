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
}
