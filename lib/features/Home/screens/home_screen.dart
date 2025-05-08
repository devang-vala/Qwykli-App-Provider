import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/main.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/features/Home/screens/accept_order_screen.dart';
import 'package:shortly_provider/features/Home/screens/open_order_screen.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isActive = false;
  final int orderCount = 3;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),

        // Tab View
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            OpenOrderScreen(),
            AcceptOrderScreen(),
          ],
        ),
      ),
    );
  }

  _buildAppBar() => PreferredSize(
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
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Colors.black87),
                      Text(
                        currentAddress.split(',')[0],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      CustomSpacers.width4,
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildSwitchToggle(),
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
                  )
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
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text: AppLocalizations.of(context)!.openorder),
                    Tab(
                      child: badges.Badge(
                        badgeContent: Text(
                          '$orderCount',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10),
                        ),
                        position:
                            badges.BadgePosition.topEnd(top: -8, end: -20),
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

  Widget _buildSwitchToggle() {
    return Row(
      children: [
        Text(
          isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            color: isActive ? Colors.greenAccent : Colors.grey.shade300,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        CustomSpacers.width8,
        Switch(
          value: isActive,
          activeColor: Colors.greenAccent,
          inactiveThumbColor: Colors.grey,
          onChanged: (val) {
            setState(() {
              isActive = val;
            });
          },
        ),
      ],
    );
  }
}
