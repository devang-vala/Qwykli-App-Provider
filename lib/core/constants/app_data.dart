import 'dart:ui';

import 'package:intl/intl.dart';

import '../helpers/utils.dart';

class AppData {


  static String lang = "en";

  //Convert to Argb
  static List<int> hexToRgba(String hexColor) {
    Color color = hexToColor(hexColor);
    return [color.red, color.green, color.blue, 255];
  }

  //Format Date and Time
  static String FormatDate(String a) {
    DateTime dateTime = DateTime.parse(a);

    String formattedDate = DateFormat('dd.MM.yyyy').format(dateTime);

    return formattedDate;
  }

  static String FormatTime(String a) {
    DateTime dateTime = DateTime.parse(a);

    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }


static Color hexToColor(String hexColor) {
  // Remove the leading '#' if it exists
  hexColor = hexColor.replaceAll('#', '');
  
  // Add the leading '0xFF' for opacity if it's not already included
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }

  return Color(int.parse('0x$hexColor'));
}



  

  static List<Map<String, dynamic>> InvoicePrice = [{"title" : "Intem1", "price" : "price1"}  , {"title" : "Intem1", "price" : "price1"}, {"title" : "Intem1", "price" : "price1"}, {"title" : "Intem1", "price" : "price1"}];


    static const Map<String, List<String>> categoryToServices = {
    "Electrician": ["AC Repair", "Wiring", "Fan Installation"],
    "Plumber": ["Leak Fix", "Pipe Installation"],
    "Salon": ["Haircut", "Shaving"],
  };
}
