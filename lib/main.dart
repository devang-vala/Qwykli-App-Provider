import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/constants/app_themes.dart';
import 'package:shortly_provider/core/constants/value_constants.dart';
import 'package:shortly_provider/core/managers/app_manager.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Home/data/home_screen_provider.dart';
import 'package:shortly_provider/features/Home/data/order_details_provider.dart';
import 'package:shortly_provider/features/Home/data/saloon_order_details_provider.dart';
import 'package:shortly_provider/features/Home/screens/home_screen.dart';
import 'package:shortly_provider/features/Onboarding/data/language_change_provider.dart';
import 'package:shortly_provider/features/Onboarding/screens/splash_screen.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/l10n/app_localizations.dart';
import 'core/loaded_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shortly_provider/core/services/firebase_messaging_handler.dart';

String lang = "";
Position? currentPosition;
String currentAddress = "Fetching location...";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await AppManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageChangeProvider(),
        ),
        ChangeNotifierProvider(create: (_) => OrderDetailsProvider()),
        ChangeNotifierProvider(create: (_) => SaloonOrderDetailsProvider()),
      ],
      child: ScreenUtilInit(
          designSize:
              const Size(VALUE_FIGMA_DESIGN_WIDTH, VALUE_FIGMA_DESIGN_HEIGHT),
          builder: () => Consumer<LanguageChangeProvider>(
                builder: (context, value, child) => MaterialApp(
                  locale: value.appLocale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [Locale('en'), Locale('hi')],
                  debugShowCheckedModeBanner: false,
                  title: 'pick a service',
                  initialRoute: '/',
                  onGenerateRoute: CustomNavigator.controller,
                  themeMode: ThemeMode.light,
                  builder: OverlayManager.transitionBuilder(),
                  theme: AppThemes.light,
                  home: SplashScreen(),
                ),
              )),
    );
  }
}
