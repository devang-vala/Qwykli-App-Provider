import 'package:flutter/material.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("AC Service",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                Text("April 14", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildListTile(Icons.person, "Ayush Raj"),
          _buildListTile(Icons.location_on, "Noida Sector 128 - Uttar Pradesh"),
          _buildListTile(Icons.lock_clock, "4:00 Pm - 5:00 Pm"),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                  dHeight: 50.h,
                  dWidth: 150.w,
                  dCornerRadius: 12,
                  bgColor: const Color.fromARGB(255, 223, 223, 223),
                  textStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  strButtonText: "Call",
                  buttonAction: () {}),
              CustomButton(
                  dHeight: 50.h,
                  dWidth: 150.w,
                  dCornerRadius: 12,
                  bgColor: const Color.fromARGB(255, 223, 223, 223),
                  textStyle: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  strButtonText: "Chat",
                  buttonAction: () {}),
            ],
          ), 
          CustomSpacers.height20,
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Flexible(
            child: Text(title, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}




