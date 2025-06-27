import 'package:flutter/material.dart';
import 'package:shortly_provider/core/constants/app_colors.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/screens/home_screen.dart';
import 'package:shortly_provider/features/Onboarding/screens/price_sheet.dart';
import 'package:shortly_provider/features/Profile/screens/profile_screen.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';

class NavBarScreen extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _selectedIndex = 0;
  final List<int> _navigationStack = [0];

  final List<Widget> _pages = [
    const HomeScreen(),
    PriceSelectionPage(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
        // Avoid duplicating index in the stack
        if (_navigationStack.isEmpty || _navigationStack.last != index) {
          _navigationStack.add(index);
        }
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (_navigationStack.length > 1) {
      setState(() {
        _navigationStack.removeLast();
        _selectedIndex = _navigationStack.last;
      });
      return false; // prevent app from closing
    }
    return true; // allow app to close on home screen
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
          child: Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(20),
            child: BottomNavigationBar(
              iconSize: 24.h,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "Shortly",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.price_change),
                  label: "Price Sheet",
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
      ),
    );
  }
}
