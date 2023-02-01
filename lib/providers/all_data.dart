import 'dart:developer';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../url.dart';

class AllData {
  final thisBox = Hive.box("allData");

  Future<void> storeDataInBox(String token) async {
    var response = await http.get(
        Uri.parse('$url/api/v1/digital-identity/documents/'),
        headers: {"Authorization": "Token $token"});
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
    thisBox.delete("data");
  }

  Map<String, dynamic> getDataFromBox() {
    try {
      return json.decode(thisBox.get("data"));
    } catch (e) {
      return {"NIN": "error"};
    }
  }

  Map<String, dynamic> getNidData() {
    try {
      Map<String, dynamic> allNidData =
          json.decode(thisBox.get("data"))["documents"][0]["document_details"];
      allNidData.remove("NID_face_image");
      allNidData.removeWhere((key, value) => value == "" || key == "docType");
      allNidData.update(
          "NID_dob", (value) => value.toString().substring(0, 10));
      return allNidData;
    } catch (e) {
      return {"NID_NIN": "error"};
    }
  }

  String get faceImage {
    return json
        .decode(thisBox.get("data"))["documents"][0]["document_details"]
            ['NID_face_image']
        .split(',')[1];
  }

  String get nIN {
    return json.decode(thisBox.get("data"))["NIN"];
  }

  String get fullName {
    return "${json.decode(thisBox.get("data"))["documents"][0]["document_details"]["NID_first_name"]} ${json.decode(thisBox.get("data"))["documents"][0]["document_details"]["NID_last_name"]}";
  }

  String get token {
    return thisBox.get("token");
  }

  String get mpin {
    return thisBox.get("mpin");
  }
}
