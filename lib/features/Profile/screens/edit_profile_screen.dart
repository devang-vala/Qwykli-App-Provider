// ================= CLEANED EDIT PROFILE SCREEN ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/constants/app_colors.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Profile/data/edit_profile_provider.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileProvider(),
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
                  child: GestureDetector(
                    onTap: provider.pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: provider.profileImage != null
                          ? FileImage(provider.profileImage!)
                          : null,
                      child: provider.profileImage == null
                          ? const Icon(Icons.camera_alt, size: 30)
                          : null,
                    ),
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
                  label: "Phone",
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  errorText: provider.phoneError,
                  onChanged: provider.clearPhoneError,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: "Address",
                  controller: addressController,
                  keyboardType: TextInputType.streetAddress,
                  errorText: provider.addressError,
                  onChanged: provider.clearAddressError,
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
                            buttonAction: () => provider.saveProfile(
                              nameController.text.trim(),
                              phoneController.text.trim(),
                              addressController.text.trim(),
                              context,
                            ),
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