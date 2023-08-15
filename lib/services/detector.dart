import 'package:flutter/foundation.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

Future<void> detectPlayer(Function then) async {
  if (kDebugMode) {
    print("Ready!");
  }
  var availability = await FlutterNfcKit.nfcAvailability;
  if (availability != NFCAvailability.available) {
    then("E404");
    return;
  }
  try {
    NFCTag tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 10),
        iosMultipleTagMessage: "Multiple tags found!", iosAlertMessage: "Scan your tag");
    then(tag.id);
  } catch (e) {
    if (e.toString().contains("404")) {
      then("E404");
    } else if (e.toString().contains("408")) {
      then("E408");
    } else {
      then("ERROR_$e");
    }
  }
}