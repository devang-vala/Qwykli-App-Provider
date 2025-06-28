import 'package:flutter/material.dart';
import 'dart:io';

class ServiceArea {
  final String name;
  final String city;
  final List<double> coordinates; // [lng, lat]
  ServiceArea(
      {required this.name, required this.city, required this.coordinates});
}

class ProviderRegistrationProvider extends ChangeNotifier {
  // Stepper state
  int currentStep = 0;

  // Registration data
  String phone = '';
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool hasSalon = false;
  String salonName = '';
  String salonAddress = '';
  String salonCompleteAddress = '';
  List<double>? salonLocation; // [lng, lat]
  bool provideServicesAtHome =
      true; // Default to true since most providers offer at home
  List<String> categories = [];
  Map<String, List<String>> selectedSubcategories = {};
  List<ServiceArea> serviceAreas = [];
  File? photo;
  File? aadharCard;
  File? panCard;

  // Step navigation
  void nextStep() {
    if (currentStep < 3) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  // Data setters
  void setPhone(String value) {
    phone = value;
    notifyListeners();
  }

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  void setHasSalon(bool value) {
    hasSalon = value;
    notifyListeners();
  }

  void setSalonName(String value) {
    salonName = value;
    notifyListeners();
  }

  void setSalonAddress(String value) {
    salonAddress = value;
    notifyListeners();
  }

  void setSalonCompleteAddress(String value) {
    salonCompleteAddress = value;
    notifyListeners();
  }

  void setSalonLocation(List<double>? value) {
    salonLocation = value;
    notifyListeners();
  }

  void setProvideServicesAtHome(bool value) {
    provideServicesAtHome = value;
    notifyListeners();
  }

  void setCategories(List<String> value) {
    categories = value;
    notifyListeners();
  }

  void setSelectedSubcategories(Map<String, List<String>> value) {
    selectedSubcategories = value;
    notifyListeners();
  }

  void setServiceAreas(List<ServiceArea> value) {
    serviceAreas = value;
    notifyListeners();
  }

  void setPhoto(File? value) {
    photo = value;
    notifyListeners();
  }

  void setAadharCard(File? value) {
    aadharCard = value;
    notifyListeners();
  }

  void setPanCard(File? value) {
    panCard = value;
    notifyListeners();
  }

  // Reset all data
  void reset() {
    currentStep = 0;
    phone = '';
    name = '';
    email = '';
    password = '';
    confirmPassword = '';
    hasSalon = false;
    salonName = '';
    salonAddress = '';
    salonLocation = null;
    salonCompleteAddress = '';
    provideServicesAtHome = true;
    categories = [];
    selectedSubcategories = {};
    serviceAreas = [];
    photo = null;
    aadharCard = null;
    panCard = null;
    notifyListeners();
  }
}
