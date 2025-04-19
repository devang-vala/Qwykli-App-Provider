import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Onboarding/widgets/my_text_field.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _accountHolderNameController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _iifcCodeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _branchNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSpacers.height56,
            GestureDetector(
              onTap: () {
                CustomNavigator.pop(context);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
                ),
              ),
            ),
            CustomSpacers.height80,
            Text("Bank Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Form(
              key: _formKey2,
              child: Column(
                children: [
                  CustomSpacers.height26,
                  MyTextfield(
                    labelText: "Account Holder Name",
                    controller: _accountHolderNameController,
                    type: TextInputType.text,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Please enter name" : null,
                  ),
                  CustomSpacers.height26,
                  MyTextfield(
                    labelText: "Account Number",
                    controller: _accountNumberController,
                    type: TextInputType.phone,
                    validator: (v) => v == null || v.isEmpty
                        ? "Please enter account number"
                        : null,
                  ),
                  CustomSpacers.height26,
                  MyTextfield(
                    labelText: "IIFC Code",
                    controller: _iifcCodeController,
                    type: TextInputType.text,
                    validator: (v) => v == null || v.isEmpty
                        ? "Please enter IIFC code"
                        : null,
                  ),
                  CustomSpacers.height26,
                  MyTextfield(
                    labelText: "Bank Name",
                    controller: _bankNameController,
                    type: TextInputType.text,
                    validator: (v) => v == null || v.isEmpty
                        ? "Please enter bank name"
                        : null,
                  ),
                  CustomSpacers.height26,
                  MyTextfield(
                    labelText: "Branch",
                    controller: _branchNameController,
                    type: TextInputType.text,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Please enter branch" : null,
                  ),
                  CustomSpacers.height26,
                  CustomSpacers.height26,
                  CustomButton(
                    strButtonText: "Save",
                    buttonAction: () {
                      // if (_formKey2.currentState!.validate()) {
                      // Process data.

                      //Home Page
                      // }

                    },
                    dHeight: 69.h,
                    dWidth: 369.w,
                    bgColor: Colors.blue,
                    dCornerRadius: 18,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
