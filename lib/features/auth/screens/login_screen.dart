// ================= LOGIN SCREEN (VALIDATION FIXED) ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:shortly_provider/core/services/auth_service.dart';

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
    return Scaffold(
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
                // _buildDontHaveAccount(context),
              ],
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
          const Text('Shortly',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          CustomSpacers.height8,
          const Text('Get the best home services',
              style: TextStyle(fontSize: 16)),
          CustomSpacers.height4,
          const Text('Quick • Affordable • Trusted',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
          CustomSpacers.height30,
        ],
      );

  Widget _buildInputTextField() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Semantics(
          label: 'Mobile Number Input Field',
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  color: Colors.grey.shade100,
                ),
                child: const Text(
                  '+91',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    hintText: 'Enter your mobile number',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    counterText: '',
                    errorText: phoneError,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                  ),
                  onChanged: (_) {
                    if (phoneError != null) {
                      setState(() => phoneError = null);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildVerificationButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SizedBox(
          width: 300.w,
          child: ElevatedButton(
            onPressed: () async {
              final phone = phoneController.text.trim();
              if (phone.length != 10) {
                setState(
                    () => phoneError = 'Please enter a valid 10-digit number');
                return;
              }
              setState(() => phoneError = null);
              try {
                // Call AuthService to request OTP
                final response =
                    await AuthService.requestProviderLoginOTP(phone);
                print('OTP response: $response'); // Debug print
                if (response['success'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('OTP sent successfully')),
                  );
                  CustomNavigator.pushReplace(
                    context,
                    AppPages.otpverification,
                    arguments: {"phoneNumber": phone},
                  );
                } else {
                  setState(() =>
                      phoneError = response['message'] ?? 'Failed to send OTP');
                }
              } catch (e) {
                setState(() => phoneError = 'Network error. Please try again.');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D3FD3),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Get Verification Code',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      );
}
