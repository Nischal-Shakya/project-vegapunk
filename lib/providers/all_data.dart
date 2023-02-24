import 'dart:developer';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../url.dart';

class AllData {
  final thisBox = Hive.box("allData");

  String get token {
    return thisBox.get("token");
  }

  Future<bool> storeAllDataInBox() async {
    var response = await http
        .get(Uri.parse(getDataUrl), headers: {"Authorization": "Token $token"});

    log(response.statusCode.toString());
    if (response.statusCode != 200) {
      return false;
    } else {
      log("Storing Data");
      thisBox.put("data", response.body);
      thisBox.put("firstLogin", "false");
      return true;
    }
  }

  void putData(String dataKey, String data) {
    thisBox.put(dataKey, data);
  }

  String getData(String dataKey) {
    return thisBox.get(dataKey) ?? "";
  }

  void deleteDataFromBox() {
    log("Deleting Data");
    thisBox.clear();
  }

  List allDocumentTypes() {
    Map docMap = (json.decode(thisBox.get("data"))['documents'] as Map);
    docMap.removeWhere((key, value) => value == null);
    return docMap.keys.toList();
  }

  Map<String, dynamic> getDocumentData(String docType) {
    try {
      Map<String, dynamic> allData =
          json.decode(thisBox.get("data"))["documents"][docType];
      allData.remove("face_image");
      allData.remove("card_front");
      allData.remove("card_back");

      log(allData.toString());
      allData.removeWhere(
          (key, value) => value == null || key == "docType" || key == "NIN");
      allData.update(
          "date_of_birth", (value) => value.toString().substring(0, 10));
      if (docType == "CTZ") {
        allData.update(
            "CTZ_date_of_issue", (value) => value.toString().substring(0, 10));
      } else if (docType == "DVL") {
        allData.update("DVL_blood_group", (value) => value.toString());
        allData.update(
            "DVL_date_of_issue", (value) => value.toString().substring(0, 10));
        allData.update(
            "DVL_date_of_expiry", (value) => value.toString().substring(0, 10));
      } else if (docType == "NID") {
        allData.update(
            "NID_date_of_issue", (value) => value.toString().substring(0, 10));
      }
      return allData;
    } catch (e) {
      log(e.toString());
      return {"No Document": "Error"};
    }
  }

  String documentFrontImage(String docType) {
    return json.decode(thisBox.get("data"))["documents"][docType]['card_front'];
  }

  String documentBackImage(String docType) {
    return json.decode(thisBox.get("data"))["documents"][docType]['card_back'];
  }

  String get nIN {
    return json.decode(thisBox.get("data"))["NIN"];
  }

  String get fullName {
    return "${json.decode(thisBox.get("data"))["documents"]["NID"]["first_name"]} ${json.decode(thisBox.get("data"))["documents"]["NID"]["last_name"]}";
  }

  String get mpin {
    return thisBox.get("mpin");
  }

  String get faceImage {
    return json.decode(thisBox.get("data"))["documents"]["NID"]['face_image'];
  }

  String get dob {
    return json.decode(thisBox.get("data"))["documents"]["NID"]
        ['date_of_birth'];
  }
}
