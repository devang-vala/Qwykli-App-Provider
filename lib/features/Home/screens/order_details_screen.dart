// ================= RESTORED + ENHANCED ORDER DETAILS SCREEN ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/features/Home/data/order_details_provider.dart';
import 'package:shortly_provider/features/Home/widget/order_details_widget.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderDetailsProvider>(context);

    return GestureDetector(
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
              _sectionTitle("Provider Details"),
              const SizedBox(height: 10),
              _infoCard(context, provider),
              const SizedBox(height: 30),
              AnimatedOpacity(
                opacity: provider.isOtpVerified ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: provider.isOtpVerified
                    ? provider.isLoadingReceipt
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle("After Order"),
                              const SizedBox(height: 10),
                              _animatedActionButton(
                                context,
                                label: "Make Receipt",
                                color: Colors.deepPurple,
                                icon: Icons.receipt_long,
                                onTap: () => _confirmAction(
                                  context,
                                  title: "Create Receipt?",
                                  onConfirm: () => provider.createReceipt(),
                                ),
                              ),
                            ],
                          )
                    : const SizedBox(),
              ),
              const SizedBox(height: 30),
              AnimatedOpacity(
                opacity: provider.isReceiptCreated ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: provider.isReceiptCreated
                    ? _animatedActionButton(
                        context,
                        label: "Close Order",
                        color: Colors.red.shade400,
                        icon: Icons.close,
                        onTap: () => _confirmAction(
                          context,
                          title: "Close Order?",
                          onConfirm: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Order closed successfully.")),
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpSection(BuildContext context, OrderDetailsProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            label: 'Enter OTP',
            child: TextField(
              controller: otpController,
              decoration: InputDecoration(
                hintText: "Enter OTP",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        provider.isLoadingOtp
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(height: 45, width: 45, child: CircularProgressIndicator()),
              )
            : Semantics(
                label: 'Verify OTP button',
                button: true,
                child: CustomButton(
                  strButtonText: "Verify",
                  dHeight: 45,
                  dWidth: 100,
                  bgColor: Colors.green,
                  textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                  buttonAction: () => provider.verifyOtp(otpController.text),
                ),
              ),
      ],
    );
  }

  Widget _infoCard(BuildContext context, OrderDetailsProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.person, provider.providerName),
          _buildInfoRow(Icons.phone, provider.providerPhone),
          _buildInfoRow(Icons.lock_clock, provider.providerTime),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: const Icon(Icons.edit, size: 18),
            label: const Text("Edit Provider Details"),
            onPressed: () => _showEditProviderDialog(context, provider),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600));

  Widget _animatedActionButton(
    BuildContext context, {
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
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

  void _confirmAction(BuildContext context,
      {required String title, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text("Confirm"))
        ],
      ),
    );
  }

  void _showEditProviderDialog(
      BuildContext context, OrderDetailsProvider provider) {
    final name = TextEditingController(text: provider.providerName);
    final phone = TextEditingController(text: provider.providerPhone);
    final time = TextEditingController(text: provider.providerTime);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Provider Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phone,
              decoration: const InputDecoration(hintText: "Phone"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: time,
              decoration: const InputDecoration(hintText: "Time"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                provider.updateProviderDetails(
                    name.text, phone.text, time.text);
                Navigator.pop(context);
              },
              child: const Text("Update"))
        ],
      ),
    );
  }
}