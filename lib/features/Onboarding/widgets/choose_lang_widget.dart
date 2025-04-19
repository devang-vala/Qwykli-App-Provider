import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shortly_provider/core/constants/app_colors.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shortly_provider/main.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class ChooseLangWidget extends StatefulWidget {
  void Function(String) lang;
  ChooseLangWidget({super.key, required this.lang});

  @override
  State<ChooseLangWidget> createState() => _ChooseLangWidgetState();
}

class _ChooseLangWidgetState extends State<ChooseLangWidget> {
  String selectedLang = "en";
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeProvider>(
      builder: (context, value, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //   child: Text(
              
            //     style: TextStyle(
            //         fontSize: 17.h,
            //         fontWeight: FontWeight.w500,
            //         color: AppColors.secondary),
            //   ),
            // ),
            CustomSpacers.height24,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    strButtonText: "English",
                    buttonAction: () {
                      setState(() {
                        selectedLang = "en";
                        value.changeLanguage(Locale('en'));
                        lang = 'en';
                        widget.lang(lang);

                        // Set selected language to English
                      });
                    },
                    bgColor: selectedLang == "en"
                        ? Colors.orange
                        : const Color.fromARGB(255, 219, 219, 219),
                    dHeight: 58.h,
                    dWidth: 138.w,
                    textStyle: TextStyle(
                        color: selectedLang == "en"
                            ? AppColors.primary
                            : AppColors.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.h),
                    dCornerRadius: 10.r,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    strButtonText: "Hindi",
                    buttonAction: () {
                      setState(() {
                        selectedLang = "hi";
                        value.changeLanguage(Locale('hi'));

                        // SharedPreferencesManager.setString( "lang" ,  "ar");
                        // lang = SharedPreferencesManager.getString("lang");
                        lang = 'hi';
                        widget.lang(lang);
                        // Set selected language to Arabic
                      });
                    },
                    bgColor: selectedLang == "hi"
                        ? Colors.orange
                        : const Color.fromARGB(255, 219, 219, 219),
                    dHeight: 58.h,
                    dWidth: 138.w,
                    textStyle: TextStyle(
                        // color: selectedLang == "ar"
                        //     ? AppColors.primary
                        //     : AppColors.secondary,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.h),
                    dCornerRadius: 10.r,
                  ),
                ),
              ],
            )
          ]),
    );
  }
}
