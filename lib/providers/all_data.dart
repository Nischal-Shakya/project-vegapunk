import 'dart:developer';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../url.dart';

class AllData {
  final thisBox = Hive.box("allData");

  Future<void> storeAllDataInBox(String token) async {
    var response = await http
        .get(Uri.parse(getDataUrl), headers: {"Authorization": "Token $token"});
    log("Storing Data");
    thisBox.put("data", response.body);
  }

  void putData(String dataKey, String data) {
    thisBox.put(dataKey, data);
  }

  void getData(String dataKey) {
    thisBox.get(dataKey);
  }

  void deleteDataFromBox() {
    log("Deleting Data");
    thisBox.deleteAll(["data", "token", "mpin", "ninNumber", "mobileNumber"]);
  }

  List get allDocumentTypes {
    return (json.decode(thisBox.get("data"))['documents'] as Map).keys.toList();
  }

  Map<String, dynamic> getCtzData() {
    try {
      Map<String, dynamic> allNidData =
          json.decode(thisBox.get("data"))["documents"]["CTZ"];
      allNidData.remove("face_image");
      allNidData.removeWhere((key, value) => value == "" || key == "docType");
      allNidData.update("dob", (value) => value.toString().substring(0, 10));
      allNidData.update(
          "CTZ_issued_date", (value) => value.toString().substring(0, 10));
      return allNidData;
    } catch (e) {
      return {"NID_NIN": "error"};
    }
  }

  Map<String, dynamic> getDvlData() {
    try {
      Map<String, dynamic> allNidData =
          json.decode(thisBox.get("data"))["documents"]["DVL"];
      allNidData.remove("face_image");
      allNidData.removeWhere((key, value) => value == "" || key == "docType");
      allNidData.update("dob", (value) => value.toString().substring(0, 10));
      allNidData.update(
          "DVL_data_of_issue", (value) => value.toString().substring(0, 10));
      allNidData.update(
          "DVL_date_of_expiry", (value) => value.toString().substring(0, 10));
      return allNidData;
    } catch (e) {
      return {"NID_NIN": "error"};
    }
  }

  Map<String, dynamic> getNidData() {
    try {
      Map<String, dynamic> allNidData =
          json.decode(thisBox.get("data"))["documents"]["NID"];
      allNidData.remove("face_image");
      allNidData.removeWhere((key, value) => value == "" || key == "docType");
      allNidData.update("dob", (value) => value.toString().substring(0, 10));
      return allNidData;
    } catch (e) {
      return {"NID_NIN": "error"};
    }
  }

  String get ctzFaceImage {
    return json.decode(thisBox.get("data"))["documents"]["NID"]['face_image'];
  }

  String get dvlFaceImage {
    return json.decode(thisBox.get("data"))["documents"]["NID"]['face_image'];
  }

  String get nidFaceImage {
    return json.decode(thisBox.get("data"))["documents"]["NID"]['face_image'];
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
