import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Onboarding/widgets/my_text_field.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _accountHolderNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSpacers.height20,

                /// Back Button
                GestureDetector(
                  onTap: () => CustomNavigator.pop(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color:Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),

                CustomSpacers.height30,

                /// Title
                const Text(
                  "Bank Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                CustomSpacers.height30,

                /// Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextfield(
                        labelText: "Account Holder Name",
                        controller: _accountHolderNameController,
                        type: TextInputType.name,
                        validator: (v) => v == null || v.isEmpty ? "Please enter account holder name" : null,
                      ),
                      CustomSpacers.height20,

                      MyTextfield(
                        labelText: "Account Number",
                        controller: _accountNumberController,
                        type: TextInputType.number,
                        validator: (v) => v == null || v.isEmpty ? "Please enter account number" : null,
                      ),
                      CustomSpacers.height20,

                      MyTextfield(
                        labelText: "IFSC Code",
                        controller: _ifscCodeController,
                        type: TextInputType.text,
                        validator: (v) => v == null || v.isEmpty ? "Please enter IFSC code" : null,
                      ),
                      CustomSpacers.height20,

                      MyTextfield(
                        labelText: "Bank Name",
                        controller: _bankNameController,
                        type: TextInputType.text,
                        validator: (v) => v == null || v.isEmpty ? "Please enter bank name" : null,
                      ),
                      CustomSpacers.height20,

                      MyTextfield(
                        labelText: "Branch Name",
                        controller: _branchNameController,
                        type: TextInputType.text,
                        validator: (v) => v == null || v.isEmpty ? "Please enter branch name" : null,
                      ),

                      CustomSpacers.height40,

                      /// Save Button
                      CustomButton(
                        strButtonText: "Save",
                        buttonAction: () {
                          if (_formKey.currentState!.validate()) {
                            // Save bank details functionality
                            // CustomNavigator.pushReplace(context, AppPages.navbar); // Example
                          }
                        },
                        dHeight: 55.h,
                        dWidth: double.infinity,
                        bgColor: Colors.black,
                        dCornerRadius: 16,
                      ),
                    ],
                  ),
                ),
                CustomSpacers.height30,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
