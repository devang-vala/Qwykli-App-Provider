// ================= REFACTORED HOME SCREEN ====================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/data/home_screen_provider.dart';
import 'package:shortly_provider/main.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/features/Home/screens/accept_order_screen.dart';
import 'package:shortly_provider/features/Home/screens/open_order_screen.dart';
import 'package:shortly_provider/features/Home/screens/notification_test_screen.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeScreenProvider(initialLocation: currentAddress),
      child: const HomeScreenBody(),
    );
  }
}

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});
  final int orderCount = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(context),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [OpenOrderScreen(), AcceptOrderScreen()],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final provider = Provider.of<HomeScreenProvider>(context);
    return PreferredSize(
      preferredSize: Size.fromHeight(120.h),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Semantics(
                  label: 'Tap to change location',
                  button: true,
                  child: GestureDetector(
                    onTap: () => _showLocationSelector(context, provider),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          provider.selectedLocation,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildSwitchToggle(context, provider),
                    CustomSpacers.width10,
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const NotificationTestScreen(),
                          ),
                        );
                      },
                      child: const Icon(Icons.bug_report,
                          size: 24, color: Colors.white),
                    ),
                    CustomSpacers.width10,
                    GestureDetector(
                      onTap: () {
                        CustomNavigator.pushTo(
                            context, AppPages.nootificationScreen);
                      },
                      child: const Icon(Icons.notifications,
                          size: 28, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TabBar(
                indicatorWeight: 4,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade300,
                labelStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.openorder),
                  Tab(
                    child: badges.Badge(
                      badgeContent: Text(
                        '$orderCount',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      position: badges.BadgePosition.topEnd(top: -8, end: -20),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.red,
                        padding: EdgeInsets.all(5),
                      ),
                      child: Text(AppLocalizations.of(context)!.acceptorder),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchToggle(BuildContext context, HomeScreenProvider provider) {
    return Row(
      children: [
        Text(
          provider.isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            color:
                provider.isActive ? Colors.greenAccent : Colors.grey.shade300,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        CustomSpacers.width8,
        Semantics(
          label: 'Toggle availability status',
          toggled: provider.isActive,
          child: Switch(
            value: provider.isActive,
            activeColor: Colors.greenAccent,
            inactiveThumbColor: Colors.grey,
            onChanged: provider.toggleActiveStatus,
          ),
        )
      ],
    );
  }

  void _showLocationSelector(
      BuildContext context, HomeScreenProvider provider) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.my_location, color: Colors.blue),
                title: const Text("Use Current Location"),
                onTap: () {
                  provider.useCurrentLocation(currentAddress);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ...provider.savedLocations.map((loc) => ListTile(
                    leading: const Icon(Icons.location_pin),
                    title: Text(loc),
                    onTap: () {
                      provider.setSelectedLocation(loc);
                      Navigator.pop(context);
                    },
                  )),
              const Divider(),
              const Text("Add New Location"),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Enter new address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      provider.addNewLocation(controller.text.trim());
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
