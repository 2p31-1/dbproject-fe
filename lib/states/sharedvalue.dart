import 'package:flutter/foundation.dart';

class SharedValue extends ChangeNotifier{
  int _userId=-1;
  int get userId=> _userId;
  void setUserId(int userId){
    _userId=userId;
    notifyListeners();
  }
}