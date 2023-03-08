import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

final userDataBox = Hive.box("userData");

class DocumentsDataProvider with ChangeNotifier {
  Map<dynamic, dynamic>? documents = userDataBox.get('documents'); //null
  String? lastUpdatedAt = userDataBox.get('lastUpdatedAt');

  Future<void> setLastUpdatedAt(String lastUpdatedAt) async {
    await userDataBox.put('lastUpdatedAt', lastUpdatedAt);
    this.lastUpdatedAt = lastUpdatedAt;
    notifyListeners();
  }

  Future<void> setDocumentsData(Map documents) async {
    await userDataBox.put('documents', documents);
    this.documents = documents;

    notifyListeners();
  }

  List getAvailableDocumentTypes() {
    return documents!.keys.toList();
  }

  Map? getDocumentData(String docType) {
    if (documents == null) {
      return null;
    }
    return documents![docType];
  }

  Map? getFilteredDocumentData(String docType) {
    if (documents == null) {
      return null;
    }
    try {
      Map allData = Map.from(documents!);
      Map tileFields = {};

      for (MapEntry items in allData[docType].entries) {
        if ([
          "face_image",
          "card_front",
          "card_back",
          "docType",
          "NIN",
          "createdAt",
          "updatedAt"
        ].any((String field) => field == items.key)) {
          continue;
        }
        tileFields[items.key] = items.value;
      }
      tileFields.removeWhere((key, value) => value == null);

      return tileFields;
    } catch (e) {
      return {"No Document": "Error"};
    }
  }

  Map? newgetFilteredDocumentData(Map document) {
    // try {
    // Map allData = Map.from(documents);
    Map tileFields = {};

    for (MapEntry items in document.entries) {
      if ([
        "face_image",
        "card_front",
        "card_back",
        "docType",
        "NIN",
        "createdAt",
        "updatedAt"
      ].any((String field) => field == items.key)) {
        continue;
      }
      tileFields[items.key] = items.value;
    }
    tileFields.removeWhere((key, value) => value == null);
    return tileFields;
    // } catch (e) {
    //   // return {"No Document": "Error"};
    // }
  }

  // Uint8List? documentFrontImage(String docType) {
  //   if (documents == null) {
  //     return null;
  //   }
  //   return const Base64Decoder().convert(documents![docType]['card_front']);
  // }

  Uint8List getDocumentCardFrontImage(Map document) {
    return const Base64Decoder().convert(document['card_front']);
  }

  Uint8List getDocumentCardBackImage(Map document) {
    // Uint8List cardFront = const Base64Decoder().convert(document['card_front']);
    return const Base64Decoder().convert(document['card_back']);
  }

  // Uint8List? documentBackImage(String docType) {
  //   if (documents == null) {
  //     return null;
  //   }
  //   return const Base64Decoder().convert(documents![docType]['card_back']);
  // }

  String? getFullName() {
    if (documents == null) {
      return null;
    }
    String? firstName = documents!["NID"]["first_name"] ?? "";
    String? middleName = documents!["NID"]["middle_name"] ?? "";
    String? lastName = documents!["NID"]["last_name"] ?? "";

    String fullName = firstName!;
    if (middleName!.isNotEmpty) {
      fullName += " $middleName";
    }
    fullName += " $lastName";

    return fullName;
  }

  Uint8List? getFaceImage() {
    if (documents == null) {
      return null;
    }
    return const Base64Decoder().convert(documents!["NID"]['face_image']);
  }

  String? getDateOfbirth() {
    if (documents == null) {
      return null;
    }
    return documents!["NID"]['date_of_birth'];
  }
}
