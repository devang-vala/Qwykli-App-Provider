import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/onboarding/widgets/my_text_field.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  final picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void saveChanges() {
    final name = nameController.text;
    final mobile = mobileController.text;
    final address = addressController.text;

    print('Saved Name: $name');
    print('Saved Mobile: $mobile');
    print('Saved Address: $address');
    print('Image path: ${_image?.path}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );

    CustomNavigator.pop(context); // optional: go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => CustomNavigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Profile Image Picker
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[200],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),

            CustomSpacers.height30,

            /// Name Field
            MyTextfield(
              labelText: "Name",
              controller: nameController,
              type: TextInputType.name,
            ),
            CustomSpacers.height20,

            /// Mobile Field
            MyTextfield(
              labelText: "Mobile Number",
              controller: mobileController,
              type: TextInputType.phone,
            ),
            CustomSpacers.height20,

            /// Address Field
            MyTextfield(
              labelText: "Address",
              controller: addressController,
              type: TextInputType.streetAddress,
            ),

            CustomSpacers.height40,

            /// Save Changes Button
            CustomButton(
              dHeight: 55.h,
              dWidth: double.infinity,
              bgColor: Colors.black,
              dCornerRadius: 16,
              strButtonText: "Save Changes",
              buttonAction: saveChanges,
            ),
          ],
        ),
      ),
    );
  }
}
