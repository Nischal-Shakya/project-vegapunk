import 'package:flutter/material.dart';

class HomeScreenIndexProvider with ChangeNotifier {
  List<int> selectedIndexList = [0];

  int get selectedIndex {
    return selectedIndexList.last;
  }

  void changeIndex(int index) {
    if (index == 0) {
      selectedIndexList.removeRange(1, selectedIndexList.length);
    } else if (index != 1) {
      if (selectedIndex != index) {
        selectedIndexList.add(index);
      }
    }
    notifyListeners();
  }

  void indexBack() {
    if (selectedIndex != 0) {
      selectedIndexList.removeLast();
    }

    notifyListeners();
  }
}
