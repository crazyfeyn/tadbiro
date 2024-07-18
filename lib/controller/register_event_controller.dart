import 'package:flutter/material.dart';

class RegisterEventController extends ChangeNotifier {
  int numberOfSeats = 0;
  String selectedPaymentMethod = '';
  String searchQuery = '';
  bool isSearched = false;

  void addSeat() {
    numberOfSeats++;
    notifyListeners();
  }

  void removeSeat() {
    if (numberOfSeats > 0) {
      numberOfSeats--;
      notifyListeners();
    }
  }

  void selectPaymentMethod(String method) {
    if (selectedPaymentMethod == method) {
      selectedPaymentMethod = '';
    } else {
      selectedPaymentMethod = method;
    }
    notifyListeners();
  }

  void setToClear() {
    numberOfSeats = 0;
    selectedPaymentMethod = '';
    notifyListeners();
  }

  void setFilter(String query) {
    searchQuery = query;
    isSearched = !isSearched;
    notifyListeners();
  }
}
