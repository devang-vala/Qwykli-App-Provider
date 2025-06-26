import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../core/services/auth_service.dart';
import '../../../route/custom_navigator.dart';
import '../../../route/app_pages.dart';

class DocumentPage extends StatefulWidget {
  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  Future<void> _pickPhoto(ProviderRegistrationProvider provider) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      provider.setPhoto(File(picked.path));
    }
  }

  Future<void> _pickAadhar(ProviderRegistrationProvider provider) async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
    if (result != null && result.files.single.path != null) {
      provider.setAadharCard(File(result.files.single.path!));
    }
  }

  Future<void> _pickPan(ProviderRegistrationProvider provider) async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);
    if (result != null && result.files.single.path != null) {
      provider.setPanCard(File(result.files.single.path!));
    }
  }

  void _onBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _onSubmit(
      BuildContext context, ProviderRegistrationProvider provider) async {
    if (provider.photo == null ||
        provider.aadharCard == null ||
        provider.panCard == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload all required documents.')),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );
    final result = await AuthService.submitProviderRegistration(provider);
    Navigator.of(context).pop(); // Remove loading
    if (result['success'] == true) {
      CustomNavigator.pushReplace(context, AppPages.registrationSuccess);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderRegistrationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _onBack(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload Documents:'),
            SizedBox(height: 16),
            Text('Profile Photo'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickPhoto(provider),
                  child: Text(
                      provider.photo == null ? 'Pick Photo' : 'Change Photo'),
                ),
                if (provider.photo != null)
                  Row(
                    children: [
                      SizedBox(width: 12),
                      Image.file(provider.photo!,
                          width: 60, height: 60, fit: BoxFit.cover),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => provider.setPhoto(null),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text('Aadhar Card (image or PDF)'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickAadhar(provider),
                  child: Text(provider.aadharCard == null
                      ? 'Pick Aadhar'
                      : 'Change Aadhar'),
                ),
                if (provider.aadharCard != null)
                  Row(
                    children: [
                      SizedBox(width: 12),
                      provider.aadharCard!.path.endsWith('.pdf')
                          ? Icon(Icons.picture_as_pdf,
                              size: 40, color: Colors.red)
                          : Image.file(provider.aadharCard!,
                              width: 60, height: 60, fit: BoxFit.cover),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => provider.setAadharCard(null),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 16),
            Text('PAN Card (image or PDF)'),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickPan(provider),
                  child: Text(
                      provider.panCard == null ? 'Pick PAN' : 'Change PAN'),
                ),
                if (provider.panCard != null)
                  Row(
                    children: [
                      SizedBox(width: 12),
                      provider.panCard!.path.endsWith('.pdf')
                          ? Icon(Icons.picture_as_pdf,
                              size: 40, color: Colors.red)
                          : Image.file(provider.panCard!,
                              width: 60, height: 60, fit: BoxFit.cover),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => provider.setPanCard(null),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _onBack(context),
                  child: Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () => _onSubmit(context, provider),
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
