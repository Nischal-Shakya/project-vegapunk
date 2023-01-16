import 'package:flutter/material.dart';
import '../models/national_id_model.dart';

class NationalId with ChangeNotifier {
  NationalIdModel nID = NationalIdModel('0123456789', 'Nischal Shakya');

  NationalIdModel get nIdData {
    return nID;
  }
}
