// ================= CLEANED OPEN ORDER SCREEN ====================
import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/features/Home/screens/order_details_screen.dart';
import 'package:shortly_provider/features/Home/screens/saloon_order_detail_screen.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';

class OpenOrderScreen extends StatelessWidget {
  const OpenOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => OpenCardWidget(index: index),
      ),
    );
  }
}

class OpenCardWidget extends StatelessWidget {
  final int index;
  const OpenCardWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final type = _getType();
    final mode = _getMode();
    final date = _getDate();

    return Semantics(
      label: '$type booking $mode on $date',
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            _buildCardTopBanner(type, mode),
            CustomSpacers.height14,
            _buildRowTile(Icons.location_on, "Noida Sector 128 - Uttar Pradesh"),
            _buildRowTile(Icons.date_range, date),
            _buildRowTile(Icons.lock_clock, "4:00 PM - 5:00 PM"),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => index == 0
                                ?  SaloonOrderDetailsScreen()
                                :  OrderDetailsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  CustomSpacers.width12,
                  Expanded(
                    child: CustomButton(
                      strButtonText: "Directions",
                      dHeight: 40,
                      bIcon: true,
                      bIconLeft: true,
                      buttonIcon: const Icon(Icons.directions, color: Colors.white),
                      bgColor: Colors.green.shade400,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      buttonAction: () {},
                    ),
                  ),
                ],
              ),
            ),
            CustomSpacers.height16,
          ],
        ),
      ),
    );
  }

  Widget _buildCardTopBanner(String type, String mode) => Container(
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
            Text(type,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            Text(mode, style: const TextStyle(color: Colors.white70)),
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
          Flexible(child: Text(title, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  String _getType() {
    if (index == 0 || index == 1) return 'Saloon';
    return 'AC Service';
  }

  String _getMode() {
    if (index == 0) return 'At Saloon';
    if (index == 1) return 'At Home';
    return 'April 14';
  }

  String _getDate() {
    return '30 April 2025';
  }
}