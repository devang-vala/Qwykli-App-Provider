// ================= CLEANED SALOON ORDER DETAIL SCREEN ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/features/Home/data/saloon_order_details_provider.dart';
import 'package:shortly_provider/features/Home/widget/order_details_widget.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class SaloonOrderDetailsScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  SaloonOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SaloonOrderDetailsProvider(),
      child: Consumer<SaloonOrderDetailsProvider>(
        builder: (context, provider, _) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              centerTitle: false,
              leading: const BackButton(color: Colors.white),
              title: const Text("Order Details",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOtpSection(context, provider),
                  const SizedBox(height: 24),
                  _sectionTitle("User Details"),
                  const SizedBox(height: 10),
                  const OrderDetailsWidget(),
                  const SizedBox(height: 30),
                  _sectionTitle("After Order"),
                  const SizedBox(height: 10),

                  AnimatedOpacity(
                    opacity: provider.isOtpVerified ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    child: provider.isOtpVerified
                        ? provider.isLoadingReceipt
                            ? const Center(child: CircularProgressIndicator())
                            : _actionButton(
                                context,
                                label: "Make Receipt",
                                icon: Icons.receipt_long,
                                color: Colors.deepPurple,
                                onTap: () => _showConfirmDialog(
                                  context,
                                  title: "Create Receipt?",
                                  onConfirm: provider.createReceipt,
                                ),
                              )
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 30),
                  AnimatedOpacity(
                    opacity: provider.isReceiptCreated ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 600),
                    child: provider.isReceiptCreated
                        ? _actionButton(
                            context,
                            label: "Close Order",
                            icon: Icons.close,
                            color: Colors.red,
                            onTap: () => _showConfirmDialog(
                              context,
                              title: "Close Order?",
                              onConfirm: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Order closed.")),
                                );
                              },
                            ),
                          )
                        : const SizedBox(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpSection(BuildContext context, SaloonOrderDetailsProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            label: 'Enter OTP',
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        provider.isLoadingOtp
            ? const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              )
            : Semantics(
                label: 'Verify OTP',
                button: true,
                child: CustomButton(
                  strButtonText: "Verify",
                  dHeight: 45,
                  dWidth: 100,
                  bgColor: Colors.green,
                  textStyle: const TextStyle(color: Colors.white),
                  buttonAction: () {
                    final otp = otpController.text.trim();
                    if (otp.isNotEmpty && RegExp(r'^\d{4,6}\$').hasMatch(otp)) {
                      provider.verifyOtp(otp);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter a valid OTP")),
                      );
                    }
                  },
                ),
              ),
      ],
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      );

  Widget _actionButton(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return Center(
      child: Semantics(
        label: label,
        button: true,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context,
      {required String title, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text("Confirm"),
          )
        ],
      ),
    );
  }
}
