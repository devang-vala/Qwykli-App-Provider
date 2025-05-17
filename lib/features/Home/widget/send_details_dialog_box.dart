// ================= CLEANED SEND DETAILS DIALOG ====================
import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class SendDetailsDialogBox extends StatefulWidget {
  final String? phone;
  const SendDetailsDialogBox({super.key, this.phone});

  @override
  State<SendDetailsDialogBox> createState() => _SendDetailsDialogBoxState();
}

class _SendDetailsDialogBoxState extends State<SendDetailsDialogBox> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  String? phoneError;

  @override
  void initState() {
    super.initState();
    if (widget.phone != null) {
      phoneController.text = widget.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Send Details"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label: 'Enter customer phone number',
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  errorText: phoneError,
                  border: const OutlineInputBorder(),
                  counterText: '',
                ),
                onChanged: (_) {
                  if (phoneError != null) {
                    setState(() => phoneError = null);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              label: 'Enter any remarks (optional)',
              child: TextField(
                controller: remarksController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Remarks",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        CustomButton(
          strButtonText: "Send",
          dHeight: 45.h,
          dWidth: 100.w,
          bgColor: Colors.black,
          textStyle: const TextStyle(color: Colors.white),
          buttonAction: () {
            final phone = phoneController.text.trim();
            if (phone.isEmpty || !RegExp(r'^\d{10}\$').hasMatch(phone)) {
              setState(() => phoneError = "Enter a valid 10-digit phone number");
              return;
            }
            // Simulate sending...
            Navigator.pop(context, {
              'phone': phone,
              'remarks': remarksController.text.trim(),
            });
          },
        )
      ],
    );
  }
}