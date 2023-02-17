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

  Future<void> storeAllDataInBox() async {
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
    return thisBox.get(dataKey) ?? "";
  }

  void deleteDataFromBox() {
    log("Deleting Data");
    thisBox.clear();
  }

  List allDocumentTypes() {
    return (json.decode(thisBox.get("data"))['documents'] as Map).keys.toList();
  }

  Map<String, dynamic> getDocumentData(String docType) {
    try {
      Map<String, dynamic> allData =
          json.decode(thisBox.get("data"))["documents"][docType];
      allData.remove("face_image");
      log(allData.toString());
      allData.removeWhere(
          (key, value) => value == null || key == "docType" || key == "NIN");
      allData.update("dob", (value) => value.toString().substring(0, 10));
      if (docType == "CTZ") {
        allData.update(
            "CTZ_date_of_issue", (value) => value.toString().substring(0, 10));
      } else if (docType == "DVL") {
        allData.update("DVL_blood_group", (value) => value.toString());
        allData.update(
            "DVL_data_of_issue", (value) => value.toString().substring(0, 10));
        allData.update(
            "DVL_date_of_expiry", (value) => value.toString().substring(0, 10));
      } else if (docType == "NID") {
        allData.update(
            "NID_date_of_issue", (value) => value.toString().substring(0, 10));
      }
      return allData;
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

  String get mpin {
    return thisBox.get("mpin");
  }
}
