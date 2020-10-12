import 'package:flutter/foundation.dart';

class UserId extends ChangeNotifier{
  UserId();
  String _token;
  String get token => _token;

  void addToken(String token){
    _token = token;
    notifyListeners();
  }
}