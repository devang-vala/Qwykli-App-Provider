//we don't need to show edit profile to provider 
//their name and email should be fixed from registration 
//.....-jt

// ================= CLEANED EDIT PROFILE SCREEN ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/constants/app_colors.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Profile/data/edit_profile_provider.dart';
import 'package:shortly_provider/core/services/profile_service.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = true;
  String? error;
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await ProfileService.getProfile();
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      photoUrl = data['photo'];
      // Set userId in provider after loading profile
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider =
            Provider.of<EditProfileProvider>(context, listen: false);
        provider.setUserId(data['_id']?.toString());
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _saveProfile(
      EditProfileProvider provider, BuildContext context) async {
    if (nameController.text.trim().isEmpty) {
      provider.setNameError('Name is required');
      return;
    }
    if (emailController.text.isNotEmpty &&
        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim())) {
      provider.setEmailError('Please enter a valid email');
      return;
    }
    try {
      await provider.saveProfile(
          nameController.text.trim(), emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
      return Scaffold(body: Center(child: Text('Error: ' + error!)));
    }
    return ChangeNotifierProvider(
      create: (_) =>
          EditProfileProvider()..emailController.text = emailController.text,
      child: Consumer<EditProfileProvider>(
        builder: (context, provider, _) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text("Edit Profile"),
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: provider.pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: provider.profileImage != null
                              ? FileImage(provider.profileImage!)
                              : (photoUrl != null && photoUrl!.isNotEmpty
                                  ? NetworkImage(photoUrl!)
                                  : null) as ImageProvider?,
                          child: provider.profileImage == null &&
                                  (photoUrl == null || photoUrl!.isEmpty)
                              ? const Icon(Icons.camera_alt, size: 30)
                              : null,
                        ),
                      ),
                      if (provider.profileImage != null ||
                          (photoUrl != null && photoUrl!.isNotEmpty))
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: provider.removePhoto,
                            tooltip: 'Remove Photo',
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(
                  label: "Name",
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  errorText: provider.nameError,
                  onChanged: provider.clearNameError,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: "Email",
                  controller: provider.emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: provider.emailError,
                  onChanged: provider.clearEmailError,
                ),
                const SizedBox(height: 30),
                Center(
                  child: provider.isSaving
                      ? const CircularProgressIndicator()
                      : Semantics(
                          label: 'Save Profile Button',
                          button: true,
                          child: CustomButton(
                            strButtonText: "Save",
                            dHeight: 50.h,
                            dWidth: 200.w,
                            bgColor: AppColors.primary,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            buttonAction: () => _saveProfile(provider, context),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    String? errorText,
    void Function(String)? onChanged,
    int? maxLength,
  }) {
    return Semantics(
      label: label,
      textField: true,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          counterText: '',
        ),
      ),
    );
  }
}
