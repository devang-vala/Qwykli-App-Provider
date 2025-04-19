import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortly_provider/core/app_imports.dart';
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

    // Handle the save logic (e.g., update Firestore, Firebase Auth, etc.)
    print('Saved Name: $name');
    print('Saved Mobile: $mobile');
    print('Saved Address: $address');
    print('Image path: ${_image?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 63, 164),
        automaticallyImplyLeading: false,
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              CustomNavigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image Picker
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Name Field
            MyTextfield(
              labelText: "Name",
              controller: nameController,
            ),
            CustomSpacers.height16,

            // Mobile Field
            MyTextfield(
              labelText: "Mobile Number",
              controller: nameController,
            ),
            CustomSpacers.height16,

            // Address Field
            MyTextfield(
              labelText: "Address",
              controller: nameController,
            ),
            CustomSpacers.height36,

            // Save Button
            CustomButton(
              dHeight: 50.h,
              dWidth: 200.w,
              bgColor: Colors.blue,
              strButtonText: "Save Changes", buttonAction: (){

            })
          ],
        ),
      ),
    );
  }
}
