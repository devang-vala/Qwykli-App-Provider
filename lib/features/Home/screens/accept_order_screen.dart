import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/widget/send_details_dialog_box.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class AcceptOrderScreen extends StatefulWidget {
  const AcceptOrderScreen({super.key});

  @override
  State<AcceptOrderScreen> createState() => _AcceptOrderScreenState();
}

class _AcceptOrderScreenState extends State<AcceptOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: AcceptCardWidget(),
            );
          }),
    );
  }
}



//ACCEPT CARD WIDGET ==============================================
class AcceptCardWidget extends StatefulWidget {
  const AcceptCardWidget({super.key});

  @override
  State<AcceptCardWidget> createState() => _AcceptCardWidgetState();
}

class _AcceptCardWidgetState extends State<AcceptCardWidget> {
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

            _buildListTile(Icons.home, "Noida Sector 128 - Uttar Pradesh"),

            //SEND DETAILS AND CALL OPTIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomButton(
                      strButtonText: "Accept",
                      dHeight: 40.h,
                      bIcon: true,
                      bIconLeft: true,
                      buttonIcon: Icon(Icons.add_task_sharp),
                      dWidth: 150.w,
                      bgColor:const Color.fromARGB(255, 31, 225, 38),
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      buttonAction: () {
                        
                      }),
                  CustomButton(
                      strButtonText: "Reject",
                      dHeight: 40.h,
                      bIcon: true,
                      bIconLeft: true,
                      buttonIcon: Icon(Icons.av_timer_rounded , color: Colors.white,),
                      dWidth: 150.w,
                      bgColor: Colors.red,
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
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
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}
