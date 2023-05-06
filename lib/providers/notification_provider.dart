import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  int _newMessageCount = 0;

  int get newMessageCount => _newMessageCount;

  void incrementNewMessageCount() {
    _newMessageCount++;
    notifyListeners();
  }

  void resetNewMessageCount() {
    _newMessageCount = 0;
    notifyListeners();
  }
}
