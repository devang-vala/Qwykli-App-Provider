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

//================= UI ==========================
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();

//BANK DETALS=====================

 

  String lang = "en";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: Consumer<SignupProvider>(
        builder: (context, provider, _) => Scaffold(
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomSpacers.height52,
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: GestureDetector(
                //     onTap: (){

                //     },
                //     child: Icon(Icons.more_vert))),
                // CustomSpacers.height52,
                LanguageSelector(col: Colors.black,),

                // Profile Selection
                GestureDetector(
                  onTap: provider.pickImage,
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 55,
                      backgroundImage: provider.profileImage != null
                          ? FileImage(provider.profileImage!)
                          : null,
                      child: provider.profileImage == null
                          ? Icon(Icons.add_a_photo,
                              size: 30, color: Colors.white)
                          : null,
                    ),
                  ),
                ),

        

                //FIILL INFO LIKE NAME , PHONE , ADDRESS , AADHAR
                _buildFillInfo(),
                CustomSpacers.height26,

                //SELECT MULTIPLE SERVICES
                SelectServicesWidget(services: AppData.services),

                CustomSpacers.height24,

                //SELECT SERVICES FOR LOCATION
                _buildLocationSelector(provider),

                //SIGNUP BUTTON ======================================
                CustomButton(
                  strButtonText: AppLocalizations.of(context)!.signup,
                  buttonAction: () {
                    if (_formKey1.currentState!.validate()) {
                      // All fields are valid, proceed to next screen
                      CustomNavigator.pushReplace(context, AppPages.approval);
                    }
                  },
                  dHeight: 59.h,
                  dWidth: 250.w,
                  bgColor: Colors.blue,
                  dCornerRadius: 18,
                ),

                CustomSpacers.height20,

                //HAVE ACCOUNT FUNCTIONALITY ===============================================
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    '${AppLocalizations.of(context)!.haveanaccount} ',
                    style:
                        TextStyle(fontSize: 17.w, fontWeight: FontWeight.w300),
                  ),
                  GestureDetector(
                    onTap: () {
                      CustomNavigator.pushReplace(context, AppPages.login);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17.w,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ]),

                CustomSpacers.height30,
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildFillInfo() => Form(
        key: _formKey1,
        child: Column(
          children: [
            CustomSpacers.height26,

            // Name Field
            MyTextfield(
              labelText: AppLocalizations.of(context)!.name,
              controller: _nameController,
              type: TextInputType.text,
              validator: (v) =>
                  v == null || v.isEmpty ? "Please enter name" : null,
            ),
            CustomSpacers.height26,

            // Contact Field with 10-digit validation
            MyTextfield(
              labelText: AppLocalizations.of(context)!.contact,
              controller: _phoneController,
              type: TextInputType.phone,
              maxLength: 10,
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.isEmpty)
                  return "Please enter contact number";
                if (!RegExp(r'^\d{10}$').hasMatch(v))
                  return "Contact must be 10 digits";
                return null;
              },
            ),

            CustomSpacers.height26,

            // Address Field
            MyTextfield(
              labelText: AppLocalizations.of(context)!.address,
              controller: _addressController,
              type: TextInputType.text,
              validator: (v) =>
                  v == null || v.isEmpty ? "Please enter address" : null,
            ),
            CustomSpacers.height26,

            // Aadhar Field with 16-digit validation
            MyTextfield(
              labelText: AppLocalizations.of(context)!.aadhar,
              controller: _aadharController,
              type: TextInputType.number,
              maxLength: 16,
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.isEmpty) return "Please enter Aadhar number";
                if (!RegExp(r'^\d{16}$').hasMatch(v))
                  return "Aadhar must be 16 digits";
                return null;
              },
            ),
          ],
        ),
      );

  _buildLocationSelector(SignupProvider provider) => Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Working Location(s)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          CustomSpacers.height10,
          GestureDetector(
            onTap: () => setState(() => _showLocationBottomSheet(provider)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
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
                    ),
                  ),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
          CustomSpacers.height26,
        ],
      );

  void _showLocationBottomSheet(SignupProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchlocation,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
                onChanged: (value) {
                  provider.updateSearchQuery(value);
                  setModalState(() {});
                },
              ),
              CustomSpacers.height10,
              SizedBox(
                height: 350.h,
                child: ListView(
                  children: provider.filteredLocations.map((location) {
                    final selected =
                        provider.selectedLocations.contains(location);
                    return CheckboxListTile(
                      title: Text(location),
                      value: selected,
                      onChanged: (_) {
                        provider.toggleLocation(location);
                        setModalState(() {});
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Done"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
