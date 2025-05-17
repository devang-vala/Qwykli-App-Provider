import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/features/Onboarding/data/language_change_provider.dart';
import 'package:shortly_provider/main.dart';

class LanguageSelector extends StatefulWidget {
  Color col;
   LanguageSelector({super.key , required this.col});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String selectedLanguage = 'en'; // Default language

  void _selectLanguage(String langCode) {
    LanguageChangeProvider language =
        Provider.of<LanguageChangeProvider>(context, listen: false);
    setState(() {
      selectedLanguage = langCode;
      if (langCode == 'en') {
        language.changeLanguage(Locale('en'));
        lang = 'en';
      } else {
        language.changeLanguage(Locale('hi'));
        lang = 'hi';
      }
    });

    // Optional: You can trigger locale change here
    // Locale newLocale = Locale(langCode);
    // MyApp.setLocale(context, newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text(
        selectedLanguage,
        style: TextStyle(fontSize: 16 , color: widget.col ),
      ),
      PopupMenuButton<String>(
        icon:  Icon(
          Icons.language_sharp,
          size: 30,
          color: widget.col,
        ),
        onSelected: _selectLanguage,
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<String>(
            value: 'en',
            child: Text('English'),
          ),
          const PopupMenuItem<String>(
            value: 'hi',
            child: Text('Hindi'),
          ),
        ],
      ),
    ]);
  }
}
