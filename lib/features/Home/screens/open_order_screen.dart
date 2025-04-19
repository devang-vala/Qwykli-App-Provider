import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/widget/send_details_dialog_box.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OpenOrderScreen extends StatefulWidget {
  const OpenOrderScreen({super.key});

  @override
  State<OpenOrderScreen> createState() => _OpenOrderScreenState();
}

class _OpenOrderScreenState extends State<OpenOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: GestureDetector(
                  onTap: () {
                    CustomNavigator.pushTo(
                        context, AppPages.OrderDetailsScreen);
                  },
                  child: OpenCardWidget()),
            );
          }),
    );
  }
}

//OPEN CARD WIDGET ==============================================
class OpenCardWidget extends StatefulWidget {
  const OpenCardWidget({super.key});

  @override
  State<OpenCardWidget> createState() => _OpenCardWidgetState();
}

class _OpenCardWidgetState extends State<OpenCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200.h,
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
            //CONTAINER APP BAR
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
            // _buildListTile(Icons.person, "Abhishek"),
            CustomSpacers.height14,
            _buildListTile(Icons.person, "Abhishek"),
            CustomSpacers.height10,

            _buildListTile(Icons.home, "Noida Sector 128 - Uttar Pradesh"),
            CustomSpacers.height12,

            //SEND DETAILS AND CALL OPTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomButton(
                      strButtonText: AppLocalizations.of(context)!.senddetails,
                      dHeight: 40.h,
                      bIcon: true,
                      bIconLeft: true,
                      buttonIcon: Icon(Icons.details_sharp),
                      dWidth: 180.w,
                      bgColor: const Color.fromARGB(255, 255, 155, 188),
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      buttonAction: () {
                        //SHOW DIALOG BOX ==========================
                        showDialog(
                            context: context,
                            barrierColor: Colors.black.withOpacity(0.4),
                            barrierDismissible: true,
                            builder: (context) {
                              return SendDetailsDialogBox();
                            });
                      }),
                  CustomButton(
                      strButtonText: AppLocalizations.of(context)!.call,
                      dHeight: 40.h,
                      bIcon: true,
                      bIconLeft: true,
                      buttonIcon: Icon(Icons.call),
                      dWidth: 130.w,
                      bgColor: Colors.lightGreen,
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      buttonAction: () {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
