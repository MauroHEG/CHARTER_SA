import 'package:flutter/foundation.dart';

class UserInfoProvider extends ChangeNotifier {
  String? _role;

  String? get role => _role;

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }
}
