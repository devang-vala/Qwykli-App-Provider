import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Service%20History/widget/history_order_details_widget.dart';

class HistoryOrderDetailsScreen extends StatelessWidget {
  const HistoryOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Order Details",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// User Details
                _sectionTitle("User Details"),
                const SizedBox(height: 10),
                const OrderDetailsWidget(),

                const SizedBox(height: 30),

                /// Provider Details
                _divider(),
                _sectionTitle("Provider Details"),
                const SizedBox(height: 10),
                _infoCard([
                  _buildInfoRow(Icons.person, "Abhishek Chauhan"),
                  _buildInfoRow(Icons.phone, "+91 8099950828"),
                  _buildInfoRow(Icons.lock_clock, "10 PM"),
                ]),

                const SizedBox(height: 30),

                /// After Order
                _divider(),
                _sectionTitle("After Order"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(thickness: 2, color: Colors.blue),
      );

  Widget _infoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
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
}
