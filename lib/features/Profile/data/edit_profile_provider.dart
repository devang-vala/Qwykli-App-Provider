import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileProvider extends ChangeNotifier {
  File? _profileImage;
  bool _isSaving = false;

  String? _nameError;
  String? _phoneError;
  String? _addressError;

  File? get profileImage => _profileImage;
  bool get isSaving => _isSaving;

  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get addressError => _addressError;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearNameError(String _) {
    if (_nameError != null) {
      _nameError = null;
      notifyListeners();
    }
  }

  void clearPhoneError(String _) {
    if (_phoneError != null) {
      _phoneError = null;
      notifyListeners();
    }
  }

  void clearAddressError(String _) {
    if (_addressError != null) {
      _addressError = null;
      notifyListeners();
    }
  }

  Future<void> saveProfile(String name, String phone, String address, BuildContext context) async {
    bool hasError = false;

    if (name.isEmpty) {
      _nameError = "Name is required";
      hasError = true;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
      _phoneError = "Enter valid 10-digit phone number";
      hasError = true;
    }
    if (address.isEmpty) {
      _addressError = "Address is required";
      hasError = true;
    }

    if (hasError) {
      notifyListeners();
      return;
    }

    _isSaving = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulate saving

    _isSaving = false;
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully!")),
    );
  }
}
