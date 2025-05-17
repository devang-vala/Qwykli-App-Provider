// ================= HOME SCREEN PROVIDER ====================
import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool _isActive = false;
  String _selectedLocation;
  final List<String> _savedLocations = [
    "Noida Sector 128",
    "DLF Phase 3, Gurgaon"
  ];

  HomeScreenProvider({required String initialLocation})
      : _selectedLocation = initialLocation;

  bool get isActive => _isActive;
  String get selectedLocation => _selectedLocation;
  List<String> get savedLocations => List.unmodifiable(_savedLocations);

  void toggleActiveStatus(bool value) {
    _isActive = value;
    notifyListeners();
  }

  void setSelectedLocation(String location) {
    _selectedLocation = location;
    if (!_savedLocations.contains(location)) {
      _savedLocations.add(location);
    }
    notifyListeners();
  }

  void useCurrentLocation(String currentAddress) {
    _selectedLocation = currentAddress;
    notifyListeners();
  }

  void addNewLocation(String location) {
    if (location.isNotEmpty && !_savedLocations.contains(location)) {
      _savedLocations.add(location);
      _selectedLocation = location;
      notifyListeners();
    }
  }
}
