import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void incremet() {
    _value++;
    notifyListeners();
  }

  void decrement() {
    _value--;
    notifyListeners();
  }
}