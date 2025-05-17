// ================= SIGNUP SCREEN ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/constants/app_data.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Onboarding/data/signup_provider.dart';
import 'package:shortly_provider/features/Onboarding/widgets/choose_lang_widget.dart';
import 'package:shortly_provider/features/Onboarding/widgets/my_text_field.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shortly_provider/ui/widget/language.dart';
import 'package:shortly_provider/ui/widget/select_service_widegt.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();

  String lang = "en";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: Consumer<SignupProvider>(
        builder: (context, provider, _) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomSpacers.height20,
                  Align(
                    alignment: Alignment.centerRight,
                    child: LanguageSelector(col: Colors.black),
                  ),
                  CustomSpacers.height20,
                  Semantics(
                    label: 'Profile image picker',
                    button: true,
                    child: _buildProfileImageSelector(provider),
                  ),
                  CustomSpacers.height30,
                  _buildFillInfo(context),
                  CustomSpacers.height20,
                  SelectServicesWidget(
                    categoryToServices: AppData.categoryToServices,
                  ),
                  CustomSpacers.height20,
                  _buildLocationSelector(context, provider),
                  CustomSpacers.height20,
                  Semantics(
                    label: 'Sign up button',
                    button: true,
                    child: CustomButton(
                      strButtonText: AppLocalizations.of(context)!.signup,
                      buttonAction: () {
                        if (_formKey.currentState!.validate()) {
                          CustomNavigator.pushReplace(context, AppPages.approval);
                        }
                      },
                      dHeight: 55.h,
                      dWidth: double.infinity,
                      bgColor: const Color(0xFF0A3D91),
                      dCornerRadius: 16,
                    ),
                  ),
                  CustomSpacers.height20,
                  _buildAlreadyHaveAnAccount(),
                  CustomSpacers.height40,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSelector(SignupProvider provider) => GestureDetector(
        onTap: provider.pickImage,
        child: CircleAvatar(
          radius: 55,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              provider.profileImage != null ? FileImage(provider.profileImage!) : null,
          child: provider.profileImage == null
              ? const Icon(Icons.add_a_photo, size: 32, color: Colors.grey)
              : null,
        ),
      );

  Widget _buildFillInfo(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          children: [
            MyTextfield(
              labelText: AppLocalizations.of(context)!.name,
              controller: _nameController,
              type: TextInputType.text,
              validator: (v) => v == null || v.isEmpty ? "Please enter name" : null,
            ),
            CustomSpacers.height20,
            MyTextfield(
              labelText: AppLocalizations.of(context)!.contact,
              controller: _phoneController,
              type: TextInputType.phone,
              maxLength: 10,
              validator: (v) {
                if (v == null || v.isEmpty) return "Please enter contact number";
                if (!RegExp(r'^\d{10}\$').hasMatch(v)) return "Contact must be 10 digits";
                return null;
              },
            ),
            CustomSpacers.height20,
            MyTextfield(
              labelText: AppLocalizations.of(context)!.address,
              controller: _addressController,
              type: TextInputType.streetAddress,
              validator: (v) => v == null || v.isEmpty ? "Please enter address" : null,
            ),
            CustomSpacers.height20,
            MyTextfield(
              labelText: AppLocalizations.of(context)!.aadhar,
              controller: _aadharController,
              type: TextInputType.number,
              maxLength: 16,
              validator: (v) {
                if (v == null || v.isEmpty) return "Please enter Aadhar number";
                if (!RegExp(r'^\d{16}\$').hasMatch(v)) return "Aadhar must be 16 digits";
                return null;
              },
            ),
          ],
        ),
      );

  Widget _buildLocationSelector(BuildContext context, SignupProvider provider) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Working Locations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          CustomSpacers.height10,
          GestureDetector(
            onTap: () => _showLocationBottomSheet(context, provider),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      provider.selectedLocations.isNotEmpty
                          ? provider.selectedLocations.join(", ")
                          : AppLocalizations.of(context)!.chooselocations,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildAlreadyHaveAnAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${AppLocalizations.of(context)!.haveanaccount} ',
            style: const TextStyle(fontSize: 16),
          ),
          GestureDetector(
            onTap: () => CustomNavigator.pushReplace(context, AppPages.login),
            child: Text(
              AppLocalizations.of(context)!.login,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
            ),
          ),
        ],
      );

  void _showLocationBottomSheet(BuildContext context, SignupProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateBottomSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchlocation,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) {
                  provider.updateSearchQuery(value);
                  setStateBottomSheet(() {});
                },
              ),
              CustomSpacers.height20,
              SizedBox(
                height: 350.h,
                child: ListView.builder(
                  itemCount: provider.filteredLocations.length,
                  itemBuilder: (context, index) {
                    final location = provider.filteredLocations[index];
                    return CheckboxListTile(
                      title: Text(location),
                      value: provider.selectedLocations.contains(location),
                      onChanged: (_) {
                        provider.toggleLocation(location);
                        setStateBottomSheet(() {});
                      },
                    );
                  },
                ),
              ),
              CustomSpacers.height20,
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D91),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}