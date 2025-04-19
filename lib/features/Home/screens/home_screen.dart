import 'package:shortly_provider/core/app_imports.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/screens/accept_order_screen.dart';
import 'package:shortly_provider/features/Home/screens/open_order_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isActive = false;
  final int orderCount = 3; // Example — replace with your actual value from Provider or state

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.h), // Custom height
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.r),

            //APPBAR===================================================================
            child: AppBar(
              backgroundColor: Color.fromARGB(255, 0, 63, 164),
              elevation: 0,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildSwitchToggle(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: (){
                      CustomNavigator.pushTo(context, AppPages.nootificationScreen);
                    },
                    child: Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              bottom: TabBar(
                indicatorWeight: 7,
                indicatorColor: AppColors.secondary,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle:
                    TextStyle(fontSize: 14.h, fontWeight: FontWeight.w600),
                labelColor: AppColors.white,
                unselectedLabelColor: const Color.fromARGB(255, 185, 185, 185),
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.openorder),
                  // Tab(text: AppLocalizations.of(context)!.acceptorder),
                  Tab(
                    child: badges.Badge(
                      badgeContent: Text(
                        '$orderCount',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      child: Text(AppLocalizations.of(context)!.acceptorder),
                      position: badges.BadgePosition.topEnd(top: -8, end: -20),
                      badgeStyle: badges.BadgeStyle(
                        badgeColor: Colors.red,
                        padding: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ],
              ),
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Shortly",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

        //BODY ===================================================================

        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            OpenOrderScreen(
                // data: value.acceptedTodayOrdersList,
                // title: AppLocalizations.of(context)!.today.toLowerCase(),
                ),
            AcceptOrderScreen(
                // data: value.acceptedTomorrowOrdersList,
                // title: AppLocalizations.of(context)!.tomorrow.toLowerCase(),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchToggle() {
    return
        // Text(
        //   isActive ? 'Active' : 'Deactive',
        //   style: TextStyle(
        //     color: isActive ? Colors.green : Colors.grey,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        Switch(
      value: isActive,
      activeColor: Colors.yellow,
      inactiveThumbColor: Colors.grey,
      onChanged: (val) {
        setState(() {
          isActive = val;
        });
      },
    );
  }
}
