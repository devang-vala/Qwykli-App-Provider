import 'package:flutter/material.dart';
import 'package:shortly_provider/core/constants/app_colors.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/screens/home_screen.dart';
import 'package:shortly_provider/features/Onboarding/screens/price_sheet.dart';
import 'package:shortly_provider/features/Profile/screens/profile_screen.dart';
import 'package:shortly_provider/features/Profile/screens/worker_list_screen.dart';
import 'package:shortly_provider/features/Service%20History/screens/service_history_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class NavBarScreen extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    PriceSelectionPage(),
    WorkerListScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _selectedIndex != 2
      //     ? AppBar(
      //         backgroundColor:Color(0xFF3B8DFF),
      //         title: const Text(
      //           "Shortly",
      //           style: TextStyle(
      //             fontSize: 22,
      //             fontWeight: FontWeight.w600,
      //             color: Colors.white
      //           ),
      //         ),
      //         centerTitle: false,
      //         elevation: 5,
      //       )
      //     : null,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: _pages[_selectedIndex],
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 1),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 73.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // shape: BoxShape.circle
        ),
        child: Material(
          elevation: 10.0,
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
            iconSize: 24.h,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "Shortly",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.price_change),
                label: "Price Sheet",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.workspaces_rounded),
                label: "Worker",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: AppLocalizations.of(context)!.profile,
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: const Color.fromARGB(255, 199, 198, 198),
          ),
        ),
      ),
    );
  }
}
