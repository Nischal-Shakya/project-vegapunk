import 'dart:developer';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../url.dart';

class AllData {
  final thisBox = Hive.box("allData");

  Future<void> storeAllDataInBox(String token) async {
    try {
      var response = await http.get(Uri.parse(getDataUrl),
          headers: {"Authorization": "Token $token"});
      log("Storing Data");
      thisBox.put("data", response.body);
      thisBox.put("firstLogin", "false");
    } catch (e) {
      log(e.toString());
      return;
    }
  }

  void putData(String dataKey, String data) {
    thisBox.put(dataKey, data);
  }

  String getData(String dataKey) {
    return thisBox.get(dataKey);
  }

  void deleteDataFromBox() {
    log("Deleting Data");
    thisBox.deleteAll(
        ["data", "token", "mpin", "ninNumber", "mobileNumber", "firstLogin"]);
  }

  List get allDocumentTypes {
    return (json.decode(thisBox.get("data"))['documents'] as Map).keys.toList();
  }

  Map<String, dynamic> getDocumentData(String docType) {
    try {
      Map<String, dynamic> allNidData =
          json.decode(thisBox.get("data"))["documents"][docType];
      allNidData.remove("face_image");
      allNidData.removeWhere(
          (key, value) => value == null || key == "docType" || key == "NIN");
      allNidData.update("dob", (value) => value.toString().substring(0, 10));
      if (docType == "CTZ") {
        allNidData.update(
            "CTZ_issued_date", (value) => value.toString().substring(0, 10));
      } else if (docType == "DVL") {
        allNidData.update("DVL_blood_group", (value) => value.toString());
        allNidData.update(
            "DVL_data_of_issue", (value) => value.toString().substring(0, 10));
        allNidData.update(
            "DVL_date_of_expiry", (value) => value.toString().substring(0, 10));
      }
      return allNidData;
    } catch (e) {
      return {"NID_NIN": "error"};
    }
  }

  String documentFrontImage(String docType) {
    return json
        .decode(thisBox.get("data"))["documents"][docType]['face_image']
        .toString()
        .split(',')[1];
  }

  String get nIN {
    return json.decode(thisBox.get("data"))["NIN"];
  }

  String get fullName {
    return "${json.decode(thisBox.get("data"))["documents"]["NID"]["first_name"]} ${json.decode(thisBox.get("data"))["documents"]["NID"]["last_name"]}";
  }

  String get token {
    return thisBox.get("token");
  }

  String get mpin {
    return thisBox.get("mpin");
  }
}
