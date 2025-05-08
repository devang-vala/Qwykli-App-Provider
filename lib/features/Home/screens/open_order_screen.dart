// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/features/Home/screens/order_details_screen.dart';
import 'package:shortly_provider/features/Home/screens/saloon_order_detail_screen.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OpenOrderScreen extends StatelessWidget {
  const OpenOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return OpenCardWidget(index: index);
        },
      ),
    );
  }
}

class OpenCardWidget extends StatelessWidget {
  int index;
  OpenCardWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Top banner
          _buildCardTopBanner(),
          CustomSpacers.height14,
          _buildRowTile(Icons.location_on, "Noida Sector 128 - Uttar Pradesh"),
          _buildRowTile(Icons.date_range, "30 April 2025"),
          _buildRowTile(Icons.lock_clock, "4:00 Pm - 5:00 Pm"),

          CustomSpacers.height10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    strButtonText: "View details",
                    dHeight: 40,
                    bIcon: true,
                    bIconLeft: true,
                    buttonIcon: const Icon(Icons.details_sharp),
                    bgColor: Colors.grey.shade200,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                    buttonAction: () {
                      index != 0
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen()))
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SaloonOrderDetailsScreen()));
                    },
                  ),
                ),
                CustomSpacers.width12,
                Expanded(
                  child: CustomButton(
                    strButtonText: AppLocalizations.of(context)!.call,
                    dHeight: 40,
                    bIcon: true,
                    bIconLeft: true,
                    buttonIcon: const Icon(Icons.call),
                    bgColor: Colors.green.shade400,
                    textStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                    buttonAction: () {},
                  ),
                ),
              ],
            ),
          ),
          CustomSpacers.height16,
        ],
      ),
    );
  }

  _buildCardTopBanner() => Container(
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
            index == 0
                ? Text('Saloon',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600))
                : index == 1
                    ? Text('Saloon',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600))
                    : Text('Ac Service',
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
          CustomSpacers.width10,
          Flexible(
            child: Text(title, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
