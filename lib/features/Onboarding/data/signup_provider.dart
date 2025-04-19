//================= PROVIDER ====================
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shortly_provider/core/app_imports.dart';

class SignupProvider extends ChangeNotifier {
  File? profileImage;
  final picker = ImagePicker();

  Map<String, Set<String>> selectedSubServices = {};
  Set<String> expandedServices = {};



    Set<String> selectedLocations = {}; // updated to support multiple
  String searchQuery = '';

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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void toggleSubService(String service, String sub) {
    if (!selectedSubServices.containsKey(service)) {
      selectedSubServices[service] = {};
    }
    if (selectedSubServices[service]!.contains(sub)) {
      selectedSubServices[service]!.remove(sub);
    } else {
      selectedSubServices[service]!.add(sub);
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

  List<String> get filteredLocations {
    return allLocations
        .where((loc) => loc.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}
