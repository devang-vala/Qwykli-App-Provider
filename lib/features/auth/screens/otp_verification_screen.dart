// ================= OTP VERIFICATION SCREEN ====================
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shortly_provider/core/services/auth_service.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late Timer _timer;
  int _start = 120;
  String otpCode = '';

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _timer.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSpacers.height52,
              const Text(
                'Verification Code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              CustomSpacers.height10,
              Text(
                'Please enter the 4-digit code sent on\n+91 ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700),
              ),
              CustomSpacers.height30,
              Semantics(
                label: 'Enter the 4-digit OTP code',
                child: _buildOTPInput(),
              ),
              CustomSpacers.height10,
              Text(
                formattedTime,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Semantics(
                label: 'Verify OTP Button',
                button: true,
                child: _buildVerificationButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPInput() => PinCodeTextField(
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 70.h,
          fieldWidth: 60.w,
          activeFillColor: Colors.white,
          selectedFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          inactiveColor: Colors.grey.shade400,
          selectedColor: Colors.deepPurple,
          activeColor: Colors.deepPurple,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: false,
        keyboardType: TextInputType.number,
        onChanged: (value) => setState(() => otpCode = value),
      );

  Widget _buildVerificationButton() => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: SizedBox(
          width: double.infinity,
          height: 60.h,
          child: ElevatedButton(
            onPressed: otpCode.length == 6
                ? () async {
                    final result = await AuthService.verifyProviderLoginOTP(
                        widget.phoneNumber, otpCode);
                    if (result['success'] == true) {
                      CustomNavigator.pushReplace(context, AppPages.navbar);
                    } else {
                      _showErrorDialog(
                          result['message'] ?? 'OTP verification failed');
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D3FD3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: otpCode.length < 6
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Verify',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
          ),
        ),
      );

  void _showPendingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Pending'),
        content: const Text('Your request is pending. We will review it soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
