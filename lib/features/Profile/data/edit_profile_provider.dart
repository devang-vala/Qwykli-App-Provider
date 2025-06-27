import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileProvider extends ChangeNotifier {
  File? _profileImage;
  bool _isSaving = false;
  String? _nameError;

  File? get profileImage => _profileImage;
  bool get isSaving => _isSaving;
  String? get nameError => _nameError;

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

  void setNameError(String? error) {
    _nameError = error;
    notifyListeners();
  }

  void setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }
}
