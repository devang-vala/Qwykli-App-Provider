// lib/features/order_details/provider/order_details_provider.dart

import 'package:flutter/material.dart';

class OrderDetailsProvider extends ChangeNotifier {
  bool isOtpVerified = false;
  bool isReceiptCreated = false;
  bool isLoadingOtp = false;
  bool isLoadingReceipt = false;

  String providerName = "Abhishek Chauhan";
  String providerPhone = "+91 8099950828";
  String providerTime = "10 PM";

  Future<void> verifyOtp(String otp) async {
    if (otp.trim().isEmpty) return;
    isLoadingOtp = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate network/API
    isOtpVerified = true;
    isLoadingOtp = false;
    notifyListeners();
  }

  Future<void> createReceipt() async {
    isLoadingReceipt = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate network/API
    isReceiptCreated = true;
    isLoadingReceipt = false;
    notifyListeners();
  }

  void updateProviderDetails(String name, String phone, String time) {
    providerName = name;
    providerPhone = phone;
    providerTime = time;
    notifyListeners();
  }
}
