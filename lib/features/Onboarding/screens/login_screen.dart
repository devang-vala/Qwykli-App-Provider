// ================= LOGIN SCREEN (VALIDATION FIXED) ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Onboarding/data/signup_provider.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? phoneError;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: Consumer<SignupProvider>(
        builder: (context, provider, _) => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAppHeader(),
                    _buildInputTextField(),
                    CustomSpacers.height30,
                    _buildVerificationButton(),
                    _buildDontHaveAccount(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() => Column(
        children: [
          CustomSpacers.height70,
          Image.asset(AppIcons.app_logo, height: 100.h),
          CustomSpacers.height36,
          const Text('Shortly', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          CustomSpacers.height8,
          const Text('Get the best home services', style: TextStyle(fontSize: 16)),
          CustomSpacers.height4,
          const Text('Quick • Affordable • Trusted', style: TextStyle(fontSize: 14, color: Colors.grey)),
          CustomSpacers.height30,
        ],
      );

  Widget _buildInputTextField() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Semantics(
          label: 'Mobile Number Input Field',
          child: TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Enter your mobile number',
              border: const OutlineInputBorder(),
              counterText: '',
              errorText: phoneError,
            ),
            onChanged: (_) {
              if (phoneError != null) {
                setState(() => phoneError = null);
              }
            },
          ),
        ),
      );

  Widget _buildVerificationButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          width: 300.w,
          child: ElevatedButton(
            onPressed: () {
              final phone = phoneController.text.trim();
              if (phone.length != 10) {
                setState(() => phoneError = 'Please enter a valid 10-digit number');
                return;
              }
              CustomNavigator.pushReplace(
                context,
                AppPages.otpverification,
                arguments: {"phoneNumber": phone},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D3FD3),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Get Verification Code', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      );

  Widget _buildDontHaveAccount(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppLocalizations.of(context)!.donthaveanaccount} ",
              style: TextStyle(fontSize: 17.w, fontWeight: FontWeight.w300),
            ),
            GestureDetector(
              onTap: () => CustomNavigator.pushReplace(context, AppPages.signup),
              child: Text(
                AppLocalizations.of(context)!.signup,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17.w,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
}