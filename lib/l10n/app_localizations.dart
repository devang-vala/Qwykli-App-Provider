import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @aadhar.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Details'**
  String get aadhar;

  /// No description provided for @select_service.
  ///
  /// In en, this message translates to:
  /// **'Select Services'**
  String get select_service;

  /// No description provided for @selectlocations.
  ///
  /// In en, this message translates to:
  /// **'Select Location(s)'**
  String get selectlocations;

  /// No description provided for @continuetoproceed.
  ///
  /// In en, this message translates to:
  /// **'Continue to proceed'**
  String get continuetoproceed;

  /// No description provided for @haveanaccount.
  ///
  /// In en, this message translates to:
  /// **'Have an Account ?'**
  String get haveanaccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @chooselocations.
  ///
  /// In en, this message translates to:
  /// **'Choose Locations'**
  String get chooselocations;

  /// No description provided for @searchlocation.
  ///
  /// In en, this message translates to:
  /// **'Search Location'**
  String get searchlocation;

  /// No description provided for @emailorphone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get emailorphone;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'Enter Otp'**
  String get otp;

  /// No description provided for @forgotpassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotpassword;

  /// No description provided for @donthaveanaccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account ?'**
  String get donthaveanaccount;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @openorder.
  ///
  /// In en, this message translates to:
  /// **'Open Order'**
  String get openorder;

  /// No description provided for @acceptorder.
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get acceptorder;

  /// No description provided for @senddetails.
  ///
  /// In en, this message translates to:
  /// **'Send Details'**
  String get senddetails;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @providerdetails.
  ///
  /// In en, this message translates to:
  /// **'Provider Details'**
  String get providerdetails;

  /// No description provided for @orderdetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderdetails;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @userdetails.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get userdetails;

  /// No description provided for @afterorder.
  ///
  /// In en, this message translates to:
  /// **'After Order'**
  String get afterorder;

  /// No description provided for @makereceipt.
  ///
  /// In en, this message translates to:
  /// **'Make Receipt'**
  String get makereceipt;

  /// No description provided for @closeorder.
  ///
  /// In en, this message translates to:
  /// **'Close Order'**
  String get closeorder;

  /// No description provided for @pricesheet.
  ///
  /// In en, this message translates to:
  /// **'Price Sheet'**
  String get pricesheet;

  /// No description provided for @workingarea.
  ///
  /// In en, this message translates to:
  /// **'Working Area'**
  String get workingarea;

  /// No description provided for @workerlist.
  ///
  /// In en, this message translates to:
  /// **'Worker List'**
  String get workerlist;

  /// No description provided for @totalorderclosed.
  ///
  /// In en, this message translates to:
  /// **'Total Order Closed'**
  String get totalorderclosed;

  /// No description provided for @totalearnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalearnings;

  /// No description provided for @pendingorders.
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pendingorders;

  /// No description provided for @editprofile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editprofile;

  /// No description provided for @refer.
  ///
  /// In en, this message translates to:
  /// **'Refer'**
  String get refer;

  /// No description provided for @gethelp.
  ///
  /// In en, this message translates to:
  /// **'Get Help'**
  String get gethelp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
