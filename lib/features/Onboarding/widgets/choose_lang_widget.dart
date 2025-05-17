import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/core/constants/app_colors.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/features/Onboarding/data/language_change_provider.dart';
import 'package:shortly_provider/ui/molecules/custom_button.dart';

class ChooseLangWidget extends StatelessWidget {
  final void Function(String) lang;
  const ChooseLangWidget({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeProvider>(
      builder: (context, provider, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomSpacers.height24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Semantics(
                label: 'Select English Language',
                button: true,
                selected: provider.selectedLang == "en",
                child: CustomButton(
                  strButtonText: "English",
                  buttonAction: () {
                    provider.setLang('en');
                    provider.changeLanguage(const Locale('en'));
                    lang('en');
                  },
                  bgColor: provider.selectedLang == "en"
                      ? Colors.orange
                      : const Color.fromARGB(255, 219, 219, 219),
                  dHeight: 58.h,
                  dWidth: 138.w,
                  textStyle: TextStyle(
                    color: provider.selectedLang == "en"
                        ? AppColors.primary
                        : AppColors.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.h,
                  ),
                  dCornerRadius: 10.r,
                ),
              ),
              Semantics(
                label: 'Select Hindi Language',
                button: true,
                selected: provider.selectedLang == "hi",
                child: CustomButton(
                  strButtonText: "Hindi",
                  buttonAction: () {
                    provider.setLang('hi');
                    provider.changeLanguage(const Locale('hi'));
                    lang('hi');
                  },
                  bgColor: provider.selectedLang == "hi"
                      ? Colors.orange
                      : const Color.fromARGB(255, 219, 219, 219),
                  dHeight: 58.h,
                  dWidth: 138.w,
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  dCornerRadius: 10.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
