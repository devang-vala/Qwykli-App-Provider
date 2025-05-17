import 'package:shortly_provider/features/Home/screens/notification_screen.dart';
import 'package:shortly_provider/features/Home/screens/order_details_screen.dart';
import 'package:shortly_provider/features/Onboarding/screens/approval_screen.dart';
import 'package:shortly_provider/features/Onboarding/screens/login_screen.dart';
import 'package:shortly_provider/features/Onboarding/screens/otp_verification_screen.dart';
import 'package:shortly_provider/features/Onboarding/screens/price_sheet.dart';
import 'package:shortly_provider/features/Onboarding/screens/signup_screen.dart';
import 'package:shortly_provider/features/Onboarding/screens/splash_screen.dart';
import 'package:shortly_provider/features/Profile/screens/bank_details_screen.dart';
import 'package:shortly_provider/features/Profile/screens/add_services_screen.dart';
import 'package:shortly_provider/features/Profile/screens/edit_profile_screen.dart';
import 'package:shortly_provider/features/Profile/screens/worker_list_screen.dart';
import 'package:shortly_provider/features/Profile/screens/working_area_screen.dart';
import 'package:shortly_provider/features/Service%20History/screens/history_order_details_screen.dart';
import 'package:shortly_provider/features/navbar_screen.dart';

import '../core/app_imports.dart';
import 'app_pages.dart';

final kNavigatorKey = GlobalKey<NavigatorState>();

class CustomNavigator {
  static Route<dynamic> controller(RouteSettings settings) {
    //use settings.arguments to pass arguments in pages
    switch (settings.name) {
      case AppPages.appEntry:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
          settings: settings,
        );

      case AppPages.login:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: settings,
        );
      case AppPages.otpverification:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => OtpVerificationPage(
            phoneNumber: args["phoneNumber"] ?? '',
          ),
          settings: settings,
        );

      case AppPages.signup:
        return MaterialPageRoute(
          builder: (context) => SignupScreen(),
          settings: settings,
        );

      case AppPages.approval:
        return MaterialPageRoute(
          builder: (context) => ApprovalScreen(),
          settings: settings,
        );
      case AppPages.navbar:
        return MaterialPageRoute(
          builder: (context) => NavBarScreen(),
          settings: settings,
        );
      case AppPages.OrderDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(),
          settings: settings,
        );

      case AppPages.priceselcetionscreen:
        return MaterialPageRoute(
          builder: (context) => PriceSelectionPage(),
          settings: settings,
        );

      case AppPages.nootificationScreen:
        return MaterialPageRoute(
          builder: (context) => NotificationScreen(),
          settings: settings,
        );

      case AppPages.workerlistscreen:
        return MaterialPageRoute(
          builder: (context) => WorkerListScreen(),
          settings: settings,
        );

      case AppPages.workingareascreen:
        return MaterialPageRoute(
          builder: (context) => WorkingAreaScreen(),
          settings: settings,
        );

      case AppPages.bankdetailsscreen:
        return MaterialPageRoute(
          builder: (context) => BankDetailsScreen(),
          settings: settings,
        );

      case AppPages.addservicescreen:
        return MaterialPageRoute(
          builder: (context) => AddServiceScreen(),
          settings: settings,
        );

      case AppPages.editprofilescreen:
        return MaterialPageRoute(
          builder: (context) => EditProfileScreen(),
          settings: settings,
        );



      case AppPages.historyOrderDetailsScreen:
        return MaterialPageRoute(
          builder: (context) => HistoryOrderDetailsScreen(),
          settings: settings,
        );
      default:
        throw ('This route name does not exit');
    }
  }

  // Pushes to the route specified
  static Future<T?> pushTo<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.of(context, rootNavigator: true)
        .pushNamed(strPageName, arguments: arguments);
  }

  // Pop the top view
  static void pop(BuildContext context, {Object? result}) {
    Navigator.pop(context, result);
  }

  // Pops to a particular view
  static Future<T?> popTo<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.popAndPushNamed(
      context,
      strPageName,
      arguments: arguments,
    );
  }

  static void popUntilFirst(BuildContext context) {
    Navigator.popUntil(context, (page) => page.isFirst);
  }

  static void popUntilRoute(BuildContext context, String route, {var result}) {
    Navigator.popUntil(context, (page) {
      if (page.settings.name == route && page.settings.arguments != null) {
        (page.settings.arguments as Map<String, dynamic>)["result"] = result;
        return true;
      }
      return false;
    });
  }

  static Future<T?> pushReplace<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.pushReplacementNamed(
      context,
      strPageName,
      arguments: arguments,
    );
  }
}
