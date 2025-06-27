import 'package:flutter/material.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Service%20History/screens/history_order_details_screen.dart';
import 'package:shortly_provider/features/Service%20History/screens/service_history_screen.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';
import 'package:shortly_provider/ui/widget/language.dart';
import 'package:shortly_provider/core/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final data = await ProfileService.getProfile();
      setState(() {
        profileData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: ' + error!)),
      );
    }
    final name = profileData?['name'] ?? '';
    final phone = profileData?['phone'] ?? '';
    final photo = profileData?['photo'] ??
        'https://randomuser.me/api/portraits/men/46.jpg';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Top Profile Header
            Container(
              height: 260.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                // gradient: LinearGradient(
                //   // colors: [
                //   //   Color(0xFF0A3D91),
                //   //   Color(0xFF0A3D91),
                //   // ],
                //   ,
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  LanguageSelector(col: Colors.white),
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(photo),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    phone,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            CustomSpacers.height20,

            /// Icon Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(Icons.edit, "Add Services", () {
                    CustomNavigator.pushTo(context, AppPages.addservicescreen);
                  }),
                  _buildIconButton(
                      Icons.work, AppLocalizations.of(context)!.workingarea,
                      () {
                    CustomNavigator.pushTo(context, AppPages.workingareascreen);
                  }),
                ],
              ),
            ),

            CustomSpacers.height20,

            /// Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.grey.withOpacity(0.15),
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ServiceHistoryScreen()));
                      },
                      child: _buildInfoRow(
                          AppLocalizations.of(context)!.totalorderclosed + ' :',
                          (profileData?['totalOrderClosed']?.toString() ??
                              '0'))),
                  // _buildInfoRow(AppLocalizations.of(context)!.totalearnings + ' :', "₹10,000"),
                  _buildInfoRow(
                      AppLocalizations.of(context)!.pendingorders + ' :',
                      (profileData?['pendingOrders']?.toString() ?? '0')),
                ],
              ),
            ),

            CustomSpacers.height20,

            _buildListTile(
                Icons.edit, AppLocalizations.of(context)!.editprofile, () {
              CustomNavigator.pushTo(context, AppPages.editprofilescreen);
            }),
            _buildListTile(
                Icons.help, AppLocalizations.of(context)!.gethelp, () {}),
            _buildListTile(Icons.logout, AppLocalizations.of(context)!.logout,
                () {
              CustomNavigator.pushReplace(context, AppPages.login);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
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
            child: Icon(icon, size: 28, color: Colors.deepPurple),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.deepPurple, size: 26),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
