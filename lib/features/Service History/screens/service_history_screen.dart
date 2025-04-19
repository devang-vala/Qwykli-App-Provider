import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/widget/send_details_dialog_box.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 63, 164),
        centerTitle: false,
        title: Text(
          "History",
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
              child: GestureDetector(
                  onTap: () {
                    CustomNavigator.pushTo(
                        context, AppPages.historyOrderDetailsScreen);
                  },
                  child: HistoryWidget()),
            );
          }),
    );
  }
}

//HISTORY WIDGET================================================
class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
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
