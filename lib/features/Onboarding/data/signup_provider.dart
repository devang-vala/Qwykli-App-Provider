// ================= PROVIDER ====================
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortly_provider/core/constants/app_data.dart';

class SignupProvider extends ChangeNotifier {
  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  // User selections
  Map<String, Set<String>> selectedSubServices = {};
  Set<String> expandedServices = {};
  Set<String> selectedLocations = {};
  Set<String> selectedCategories = {};
  Set<String> selectedServices = {};

  String searchQuery = '';
  String? selectedCategory;

  List<String> allLocations = [
    'Connaught Place',
    'Karol Bagh',
    'Dwarka',
    'Rohini',
    'Noida Sector 18',
    'Gurgaon Cyber City',
    'Saket',
    'Lajpat Nagar',
    'Vasant Kunj',
    'Mayur Vihar'
  ];

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void toggleSubService(String service, String subService) {
    selectedSubServices[service] ??= <String>{};
    if (selectedSubServices[service]!.contains(subService)) {
      selectedSubServices[service]!.remove(subService);
    } else {
      selectedSubServices[service]!.add(subService);
    }
    notifyListeners();
  }

  void toggleExpansion(String service) {
    if (expandedServices.contains(service)) {
      expandedServices.remove(service);
    } else {
      expandedServices.add(service);
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void toggleLocation(String location) {
    if (selectedLocations.contains(location)) {
      selectedLocations.remove(location);
    } else {
      selectedLocations.add(location);
    }
    notifyListeners();
  }

  List<String> get filteredLocations =>
      allLocations.where((loc) => loc.toLowerCase().contains(searchQuery.toLowerCase())).toList();

  void selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
      selectedServices.removeWhere((service) =>
          AppData.categoryToServices[category]?.contains(service) ?? false);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners();
  }

  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
    notifyListeners();
  }

  void reset() {
    profileImage = null;
    selectedSubServices.clear();
    expandedServices.clear();
    selectedLocations.clear();
    selectedCategories.clear();
    selectedServices.clear();
    searchQuery = '';
    selectedCategory = null;
    notifyListeners();
  }
}