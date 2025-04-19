import 'package:flutter/material.dart';
import 'package:shortly_provider/core/constants/app_icons.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/onboarding/widgets/my_text_field.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();
  bool isOtp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Form(
            key: _formKey1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 56.h),

                //image
                Center(
                  child: Image.asset(
                    AppIcons.app_logo,
                    width: 145.w,
                    height: 144.h,
                  ),
                ),
                CustomSpacers.height40,

                Text(
                  AppLocalizations.of(context)!.login,
                  style: TextStyle(fontSize: 25.w, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
                CustomSpacers.height26,

                //INPUT TEXT FIELD FOR EMAIL ===================================
                MyTextfield(
                  labelText: AppLocalizations.of(context)!.emailorphone,
                  controller: _emailController,
                  type: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Please enter email/phone";
                    }
                    return null;
                  },
                ),
                CustomSpacers.height26,

                //INPUT FIELD FOR PHONE NUMBER ==================================
                // MyTextfield(
                //   labelText: "Phone Number",
                //   controller: _phoneController,
                //   type: TextInputType.phone,
                //   validator: (v) {
                //     if (v == null || v.isEmpty) {
                //       return "Please enter phone number";
                //     }
                //     return null;
                //   },
                // ),
                // CustomSpacers.height26,

                //INPUT TEXTFIELD FOR PASSWORD =====================================
                isOtp
                    ? MyTextfield(
                        labelText: AppLocalizations.of(context)!.otp,
                        controller: _otpController,
                        type: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Please enter Otp";
                          }
                          return null;
                        },
                      )
                    : Container(),
                CustomSpacers.height20,

                //FORGOT PASSWORD FUNCTIONALITY =================================================
                // Text(
                //   AppLocalizations.of(context)!.forgotpassword,
                //   style: TextStyle(
                //       color: Colors.blue,
                //       fontSize: 17.w,
                //       fontWeight: FontWeight.w500),
                // ),
                // CustomSpacers.height20,

                //LOGIN BUTTON ======================================
                CustomButton(
                  strButtonText: isOtp
                      ? AppLocalizations.of(context)!.login
                      : "Generate Otp",
                  buttonAction: () {
                    if (isOtp) {
                      CustomNavigator.pushReplace(context, AppPages.navbar);
                    } else {
                      setState(() {
                        if (_formKey1.currentState!.validate()) {
                          isOtp = true;
                          // Process data.
                        }
                      });
                    }
                  },
                  dHeight: 69.h,
                  dWidth: 369.w,
                  bgColor: Colors.blue,
                  dCornerRadius: 18,
                ),

                CustomSpacers.height20,

                //LOGIN WITH GOOGLE BUTTON ======================================
                // CustomButton(
                //   strButtonText: "Login with Google",
                //   buttonAction: () {},
                //   buttonIcon: Image.asset(
                //     AppIcons.google_logo,
                //     height: 40.h,
                //     width: 40.w,
                //   ),
                //   dHeight: 69.h,
                //   dWidth: 369.w,
                //   dCornerRadius: 18,
                //   bIcon: true,
                //   textStyle: TextStyle(color: Colors.black),
                //   bgColor: Colors.white,
                //   borderColor: Colors.black,
                // ),

                // CustomSpacers.height20,

                // DONT HAVE ACCOUNT FUNCTIONALITY ===============================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.donthaveanaccount + " ",
                      style: TextStyle(
                          fontSize: 17.w, fontWeight: FontWeight.w300),
                    ),
                    GestureDetector(
                      onTap: () {
                        CustomNavigator.pushReplace(context, AppPages.signup);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 17.w,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
