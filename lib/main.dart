import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/constants/app_themes.dart';
import 'package:shortly_provider/core/constants/value_constants.dart';
import 'package:shortly_provider/core/managers/app_manager.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Onboarding/data/signup_provider.dart';
import 'package:shortly_provider/features/Onboarding/screens/splash_screen.dart';
import 'package:shortly_provider/language_provider.dart';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'core/loaded_widget.dart';
String lang = "";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => SignupProvider()),
         ChangeNotifierProvider(
          create: (_) => LanguageChangeProvider(),
        ),
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
