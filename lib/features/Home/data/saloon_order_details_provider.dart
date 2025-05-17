// Step 1: Create Provider Class
// lib/features/order_details/provider/saloon_order_details_provider.dart

import 'package:flutter/material.dart';

class SaloonOrderDetailsProvider extends ChangeNotifier {
  bool isOtpVerified = false;
  bool isReceiptCreated = false;
  bool isLoadingOtp = false;
  bool isLoadingReceipt = false;

  Future<void> verifyOtp(String otp) async {
    if (otp.trim().isEmpty) return;
    isLoadingOtp = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    isOtpVerified = true;
    isLoadingOtp = false;
    notifyListeners();
  }

  Future<void> createReceipt() async {
    isLoadingReceipt = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    isReceiptCreated = true;
    isLoadingReceipt = false;
    notifyListeners();
  }
}