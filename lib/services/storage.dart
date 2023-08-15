import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

const String tokens = "tokens/";
const String titleDeedIndex = "indices/TitleDeedCards.json";
const String eventIndex = "indices/Events.json";

class StorageService {
  final storageRef = FirebaseStorage.instance.ref();
  Reference? titleDeedRef;
  Reference? eventRef;
  Reference? tokensRef;

  StorageService() {
    final titleDeedRef = storageRef.child(titleDeedIndex);
    final eventRef = storageRef.child(eventIndex);
    final tokensRef = storageRef.child(tokens);
  }

  Future<Uint8List?> getTokenImage(String name) async {
    try {
      const thirtyKilobytes = 30 * 1024;
      Reference? imageRef = tokensRef?.child("$name.jpg");
      final Uint8List? data = await imageRef?.getData(thirtyKilobytes);
      return data;
    } on FirebaseException catch (e) {
      // Handle any errors.
    }
    return null;
  }


}