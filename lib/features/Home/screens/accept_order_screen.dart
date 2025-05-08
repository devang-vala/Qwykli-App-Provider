// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/features/Home/widget/send_confiirm.dart';
import 'package:shortly_provider/features/Home/widget/send_details_dialog_box.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class AcceptOrderScreen extends StatelessWidget {
  const AcceptOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => AcceptCardWidget(index: index),
      ),
    );
  }
}

class AcceptCardWidget extends StatelessWidget {
  int index;
  AcceptCardWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          const SizedBox(height: 12),
          _buildRowTile(Icons.location_on, "Noida Sector 128 - Uttar Pradesh"),
          const SizedBox(height: 10),

          _buildActionsButton(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  _buildHeader() => Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('AC Service',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            index == 0
                ? Text('At Saloon', style: TextStyle(color: Colors.white70))
                : index == 1
                    ? Text('At Home', style: TextStyle(color: Colors.white70))
                    : Text('April 14', style: TextStyle(color: Colors.white70)),
          ],
        ),
      );

  Widget _buildRowTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[800]),
          CustomSpacers.width12,
          Flexible(
            child: Text(title, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  _buildActionsButton(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                strButtonText: "Accept",
                dHeight: 40,
                bIcon: true,
                bIconLeft: true,
                buttonIcon: const Icon(Icons.check_circle),
                bgColor: const Color.fromARGB(167, 76, 175, 79),
                textStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                buttonAction: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => index != 1
                        ? SendDetailsDialogBox()
                        : SendConfirmDialogBox(),
                  );
                },
              ),
            ),
            CustomSpacers.width14,
            Expanded(
              child: CustomButton(
                strButtonText: "Reject",
                dHeight: 40,
                bIcon: true,
                bIconLeft: true,
                buttonIcon: const Icon(Icons.close, color: Colors.white),
                bgColor: const Color.fromARGB(195, 255, 82, 82),
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
                buttonAction: () {},
              ),
            ),
          ],
        ),
      );
}
