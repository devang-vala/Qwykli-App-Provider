import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortly_provider/core/services/profile_service.dart';

class EditProfileProvider extends ChangeNotifier {
  File? _profileImage;
  bool _isSaving = false;
  String? _nameError;
  String? _emailError;
  bool _removeProfileImage = false;
  final TextEditingController emailController = TextEditingController();
  String? _userId;

  File? get profileImage => _profileImage;
  bool get isSaving => _isSaving;
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  bool get removeProfileImage => _removeProfileImage;
  String? get userId => _userId;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      _removeProfileImage = false;
      notifyListeners();
    }
  }

  void removePhoto() {
    _profileImage = null;
    _removeProfileImage = true;
    notifyListeners();
  }

  void clearNameError(String _) {
    if (_nameError != null) {
      _nameError = null;
      notifyListeners();
    }
  }

  void clearEmailError(String _) {
    if (_emailError != null) {
      _emailError = null;
      notifyListeners();
    }
  }

  void setNameError(String? error) {
    _nameError = error;
    notifyListeners();
  }

  void setEmailError(String? error) {
    _emailError = error;
    notifyListeners();
  }

  void setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  void setUserId(String? id) {
    _userId = id;
    notifyListeners();
  }

  Future<void> saveProfile(String name, String email) async {
    setSaving(true);
    try {
      await ProfileService.updateProfile(
        {'name': name, 'email': email},
        photo: _profileImage,
        removePhoto: _removeProfileImage,
        userId: _userId,
      );
      setSaving(false);
    } catch (e) {
      setSaving(false);
      rethrow;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
