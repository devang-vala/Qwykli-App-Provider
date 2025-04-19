import 'package:flutter/material.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Onboarding/widgets/choose_lang_widget.dart';
import 'package:shortly_provider/main.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shortly_provider/ui/widget/language.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ---- Header ----
            Container(
              height: 260.h,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  // colors: [Color(0xFF3B8DFF), Color(0xFF0052D4)],
                  colors: [
                    Color.fromARGB(255, 0, 63, 164),
                    Color.fromARGB(255, 0, 63, 164)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  LanguageSelector(
                    col: Colors.white,
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/46.jpg', // Replace with user image
                    ),
                  ),
                  CustomSpacers.height6,

                  //NAME ===================
                  Text(
                    "Abhishek Chauhan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "+91 8099950828",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            CustomSpacers.height20,

            /// ---- Icon Row ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        CustomNavigator.pushTo(
                            context, AppPages.addservicescreen);
                      },
                      child: _buildIconCard(Icons.edit, "Add Services")),
                  GestureDetector(
                      onTap: () {
                        CustomNavigator.pushTo(
                            context, AppPages.workingareascreen);
                      },
                      child: _buildIconCard(Icons.work,
                          AppLocalizations.of(context)!.workingarea)),
                  GestureDetector(
                      onTap: () {
                        CustomNavigator.pushTo(
                            context, AppPages.workerlistscreen);
                      },
                      child: _buildIconCard(Icons.person,
                          AppLocalizations.of(context)!.workerlist)),
                  // _buildIconCard(Icons.help, "Get Help"),
                ],
              ),
            ),

            CustomSpacers.height20,

            /// ---- Info Card ----
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // _buildInfoRow("Passw:", "Change", isClickable: true),
                  _buildInfoRow(AppLocalizations.of(context)!.address,
                      "Noida Sector 128, Uttar Pradesh"),
                  _buildInfoRow(
                      AppLocalizations.of(context)!.totalorderclosed + ' :',
                      "9"),
                  _buildInfoRow(
                      AppLocalizations.of(context)!.totalearnings + " :",
                      "₹10000"),
                  _buildInfoRow(
                      AppLocalizations.of(context)!.pendingorders + " :", "3"),
                ],
              ),
            ),

            // ChooseLangWidget(
            //   lang: (p0) {
            //     setState(() {
            //       lang = p0;
            //     });
            //   },
            // ),

            // CustomSpacers.height26,

            //PRICE SHEET
            GestureDetector(
                onTap: () {
                  CustomNavigator.pushTo(
                      context, AppPages.priceselcetionscreen);
                },
                child: _buildListTile(Icons.price_change, "Price Sheet")),

            //BANK DETAILS
            GestureDetector(
                onTap: () {
                  CustomNavigator.pushTo(context, AppPages.bankdetailsscreen);
                },
                child: _buildListTile(
                    Icons.card_giftcard_rounded, "Bank Details")),

            //EDIT PROFILE
            GestureDetector(
              onTap: () {
                CustomNavigator.pushTo(context, AppPages.editprofilescreen);
              },
              child: _buildListTile(
                  Icons.edit, AppLocalizations.of(context)!.editprofile),
            ),

            //REFER
            _buildListTile(
                Icons.roundabout_left, AppLocalizations.of(context)!.refer),
            //GET HELP
            _buildListTile(Icons.help, AppLocalizations.of(context)!.gethelp),
            //LOGOUT
            GestureDetector(
                onTap: () {
                  CustomNavigator.pushReplace(context, AppPages.login);
                },
                child: _buildListTile(
                    Icons.logout, AppLocalizations.of(context)!.logout)),

            // /// ---- Edit Profile Button ----
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 40),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xFF3B8DFF),
            //       minimumSize: const Size(double.infinity, 50),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //     ),
            //     child:
            //         const Text("Edit Profile", style: TextStyle(fontSize: 16)),
            //   ),
            // ),

            // const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        leading: Icon(icon, size: 24),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildIconCard(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Colors.grey.withOpacity(0.3),
              ),
            ],
          ),
          child: Icon(icon, size: 28, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value, {bool isClickable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
              width: 200,
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isClickable ? Colors.blue : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
