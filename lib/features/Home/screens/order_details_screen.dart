import 'package:flutter/material.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Order details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
          backgroundColor: Color.fromARGB(255, 0, 63, 164),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // OTP Section==================================================================================================
              _buildOtp(),
              CustomSpacers.height30,

              // Order Info =====================================================================================================
              SizedBox(
                child: Divider(
                  thickness: 2,
                  color: Colors.blue,
                ),
              ),
              CustomSpacers.height10,
              Text("User Details",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              CustomSpacers.height10,
              OrderDetailsWidget(),
              CustomSpacers.height30,

              //PROVIDER Detail ===================================================================================================
              SizedBox(
                child: Divider(
                  thickness: 2,
                  color: Colors.blue,
                ),
              ),
              CustomSpacers.height10,
              Text("Provider Details",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              CustomSpacers.height10,
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 237, 237),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTile(Icons.person, "Abhishek Chauhan"),
                      _buildTile(Icons.phone, "+91 8099950828"),
                      _buildTile(Icons.lock_clock, "10 PM"),
                    ],
                  ),
                ),
              ),

              //AFTER ORDER =====================================================================================================
              CustomSpacers.height30,
              SizedBox(
                child: Divider(
                  thickness: 2,
                  color: Colors.blue,
                ),
              ),
              CustomSpacers.height10,
              Text("After Order",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              CustomSpacers.height10,
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade400,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: Text(
                      "Make Receipt",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              // Close Order Button=============================================================================================
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Close Order",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildOtp() => Row(
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
          CustomSpacers.width40,
          //VERYFYOTP BUTTON ====
          CustomButton(
              strButtonText: "Verify",
              dHeight: 45.h,
              dWidth: 100.w,
              bgColor: Colors.green,
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
              buttonAction: () {})
        ],
      );

  Widget _buildTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

//OPEN CARD WIDGET =======================================================================================
class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 244, 210),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40.h,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Color.fromARGB(255, 8, 0, 164)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "AC Service",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "April 14",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomSpacers.height10,
            _buildListTile(Icons.person, "Ayush Raj"),
            _buildListTile(Icons.home, "Noida Sector 128 - Uttar Pradesh"),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
