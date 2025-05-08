import 'package:flutter/material.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/widget/order_details_widget.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class SaloonOrderDetailsScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Order Details",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// OTP Section
              _buildOtp(),

              const SizedBox(height: 24),

              /// Order Info
              _sectionTitle("User Details"),
              const SizedBox(height: 10),
              const SaloonOrderDetailsWidget(),

              const SizedBox(height: 30),

              /// Provider Info
              //   _sectionTitle("Provider Details"),
              //   const SizedBox(height: 10),
              //   _infoCard([
              //     _buildInfoRow(Icons.person, "Abhishek Chauhan"),
              //     _buildInfoRow(Icons.phone, "+91 8099950828"),
              //     _buildInfoRow(Icons.lock_clock, "10 PM"),
              //   ]),

            //   const SizedBox(height: 30),

              /// After Order
              _sectionTitle("After Order"),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.receipt_long, color: Colors.white),
                label: const Text(
                  "Make Receipt",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const Spacer(),

              /// Close Order Button
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Close Order",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// OTP Entry + Verify Button
  Widget _buildOtp() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: otpController,
            decoration: InputDecoration(
              hintText: "Enter OTP",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        CustomButton(
          strButtonText: "Verify",
          dHeight: 45.h,
          dWidth: 100.w,
          bgColor: Colors.green,
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
          buttonAction: () {},
        ),
      ],
    );
  }

  /// Section Header
  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      );

  /// Provider Info Card
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

class SaloonOrderDetailsWidget extends StatelessWidget {
  const SaloonOrderDetailsWidget({super.key});

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
                Text("Saloon",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                Text("At Saloon", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildListTile(Icons.person, "Ayush Raj"),
          _buildListTile(Icons.location_on, "3:00 PM - 4:00 PM"),
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
