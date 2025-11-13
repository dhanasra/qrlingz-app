  import 'dart:io';
import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

String? colorToString(Color? color) {
    if(color==null){
      return null;
    }
    return 'Color(0x${color.value.toRadixString(16).padLeft(8, '0')})';
}

Color? stringToColor(String? colorString) {
  if(colorString==null){
    return null;
  }
  String hexString = colorString.substring(8, 16);
  int colorValue = int.parse(hexString, radix: 16);
  return Color(colorValue);
}

String getDataType(String scanData){

  // website check
  final RegExp urlRegex = RegExp(
      r'^(?:http:\/\/|https:\/\/)?(?:www\.)?[a-zA-Z0-9-]+(?:\.[a-zA-Z]{2,})+(?:\/\S*)?$',
  );
  var isUrl = urlRegex.hasMatch(scanData);
  if(isUrl){
    return "Website";
  }
  
  //phone check
  if(scanData.startsWith("tel")){
    return "Phone";
  }

  //mail check
  if(scanData.startsWith("mailto")){
     return "Email";
  }

  //wifi check
  if(scanData.startsWith("WIFI")){
    return "Wifi";
  }

  //contact card check
  if(scanData.contains("VCARD")){
    return "VCard";
  }

  // sms check
  if(scanData.startsWith("smsto")){
    return "SMS";
  }

  if(scanData.startsWith("https://www.instagram.com")){
    return "Instagram";
  }
  if(scanData.startsWith("https://twitter.com")){
    return "X";
  }
  if(scanData.startsWith("https://www.snapchat.com")){
    return "Snapchat";
  }
  if(scanData.startsWith("https://www.paypal.me")){
    return "Paypal";
  }
  if(scanData.startsWith("https://www.pinterest.com")){
    return "Pinterest";
  }

  if(scanData.startsWith("whatsapp:")){
    return "Whatsapp";
  }
  if(scanData.startsWith("viber:")){
    return "Viber";
  }

  if(scanData.startsWith("https://www.youtube.com/")){
    return "Youtube";
  }

  if(scanData.startsWith("spotify:")){
    return "Spotify";
  }

  return "Text";
}

Locale getLocale(String languageCode){
  switch(languageCode){
    case "en": return const Locale("en", "US");
    case "ta": return const Locale("ta", "IN");
    case "ml": return const Locale("ml", "IN");
    case "kn": return const Locale("kn", "IN");
    case "hi": return const Locale("hi", "IN");
    case "bn": return const Locale("bn", "IN"); 
    case "pt": return const Locale("pt", "BR"); 
    case "ur": return const Locale("ur", "PK"); 
    case "ar": return const Locale("ar", "SA");
    case "my": return const Locale("my", "MM");
    case "gu": return const Locale("gu", "IN"); 
    case "fr": return const Locale("fr", "FR");
    case "de": return const Locale("de", "DE");
    default: return const Locale("en", "US");
  }
}

String getLanguage(String languageCode){
  switch(languageCode){
    case "en": return "ENGLISH";
    case "ta": return "தமிழ்";
    case "ml": return "മലയാളം";
    case "kn": return "ಕನ್ನಡ";
    case "hi": return "हिंदी";
    case "ar": return "العربية";
    case "bn": return "বাংলা";
    case "pt": return "Português";
    case "de": return "Deutsch";
    case "fr": return "Français";
    case "my": return "မြန်မာ";
    case "ur": return "اردو";
    case "gu": return "ગુજરાતી";
    default: return "ENGLISH";
  }
}

Future<void> saveVCard({required String data}) async {
  try {

    final directory = Directory('/storage/emulated/0/Download');
    final file = File('${directory.path}/qrlingz.vcf');
    await file.writeAsString(data);
    OpenFilex.open(file.path);
  } catch (_) {}
}

getBarcodeType(String type){

   switch(type){
    case "code_39": return Barcode.code39();
    case "code_93": return Barcode.code93();
    case "code_128": return Barcode.code128();
    case "codabar": return Barcode.codabar();
    case "gs1_128": return Barcode.gs128();
    case "itf": return Barcode.itf();
    case "itf_14": return Barcode.itf14();
    case "itf_16": return Barcode.itf16();
    case "ean_13": return Barcode.ean13();
    case "ean_8": return Barcode.ean8();
    case "ean_2": return Barcode.ean2();
    case "ean_5": return Barcode.ean5();
    case "isbn": return Barcode.isbn();
    case "upc_a": return Barcode.upcA();
    case "upc_e": return Barcode.upcE();
    case "telepen": return Barcode.telepen();
    case "rm4scc": return Barcode.rm4scc();
    case "pdf417": return Barcode.pdf417();
    case "data_matrix": return Barcode.dataMatrix();
    case "aztec": return Barcode.aztec();
    default: return Barcode.code39();
  }
}

getBarcodeSampleData(String type) {
    switch(type) {
        case "code_39": return "CODE39SAMPLE";
        case "code_93": return "CODE93SAMPLE";
        case "code_128": return "CODE128SAMPLE";
        case "codabar": return "0123456789";
        case "gs1_128": return "123456789012345678";
        case "itf": return "1234567890";
        case "itf_14": return "12345678901231";
        case "itf_16": return "1234567890123452";
        case "ean_13": return "4006381333931";
        case "ean_8": return "73513537";
        case "ean_2": return "12";
        case "ean_5": return "12345";
        case "isbn": return "9783161484100";
        case "upc_a": return "012345678905";
        case "upc_e": return "0123456";
        case "telepen": return "TELEPEN1234";
        case "rm4scc": return "RM4SCC12345";
        case "pdf417": return "PDF417SAMPLE";
        case "data_matrix": return "DMATRIX12345";
        case "aztec": return "AZTEC12345";
        default: return "DEFAULTSAMPLE";
    }
}

String getLabel(String type) {
    switch(type) {
        case "code_39": return "Code 39";
        case "code_93": return "Code 93";
        case "code_128": return "Code 128";
        case "codabar": return "CODABAR";
        case "gs1_128": return "GS1-128";
        case "itf": return "Interleaved 2 of 5 (ITF)";
        case "itf_14": return "ITF-14";
        case "itf_16": return "ITF-16";
        case "ean_13": return "EAN 13";
        case "ean_8": return "EAN 8";
        case "ean_2": return "EAN 2";
        case "ean_5": return "EAN 5";
        case "isbn": return "ISBN";
        case "upc_a": return "UPC-A";
        case "upc_e": return "UPC-E";
        case "telepen": return "Telepen";
        case "rm4scc": return "RM4SCC";
        case "pdf417": return "PDF417";
        case "data_matrix": return "Data Matrix";
        case "aztec": return "Aztec";
        default: return "Code 39";
    }
}

Map<String, IconData> getFeedbackIcons() {

  return {
    "star": Icons.star_outline,
    "light": Icons.light_outlined,
    "check": Icons.check_circle_outline_outlined,
    "history": Icons.history_outlined,
    "calendar": Icons.calendar_month_outlined,
    "info": Icons.info_outline_rounded,
    "kitchen": Icons.kitchen_outlined,
    "drink": Icons.local_drink_outlined,
    "ac_unit": Icons.ac_unit_outlined,
    "alarm": Icons.access_alarms_outlined,
    "building": Icons.account_balance_wallet_outlined,
    "person": Icons.account_circle_outlined,
    "travel": Icons.card_travel_outlined,
    "location": Icons.location_city_outlined,
    "shopping_bag": Icons.shopping_bag_outlined,
    "wine": Icons.wine_bar_outlined,
    "wind_power": Icons.wind_power_outlined,
    "weekend": Icons.weekend_outlined,
    "wifi": Icons.wifi,
    "bed": Icons.bed_outlined,
    "people": Icons.people_outline
  };
}

String getFormatInstructions(String type) {
  switch (type) {
    case "upc_e":
      return '* Ex. 01234567\n* Charset: Number (0-9)\n* Capacity: 7 digits + 1 check digit';
    case "upc_a":
      return '* Ex. 012345678911\n* Charset: Number (0-9)\n* Capacity: 11 digits + 1 check digit';
    case "pdf417":
      return '* Ex. PDF417SAMPLE\n* Charset: All 256 ASCII characters\n* Capacity: Upto 800 characters';
    case "ean_13":
      return '* Ex. 4006381333931\n* Charset: Number (0-9)\n* Capacity: 12 digits + 1 check digit';
    case "ean_8":
      return '* Ex. 73513537\n* Charset: Number (0-9)\n* Capacity: 7 digits + 1 check digit';
    case "ean_5":
      return '* Ex. 12345\n* Charset: Number (0-9)\n* Capacity: 4 digits + 1 check digit';
    case "ean_2":
      return '* Ex. 12\n* Charset: Number (0-9)\n* Capacity: 1 digit + 1 check digit';
    case "code_39":
      return '* Ex. CODE39SAMPLE\n* Charset: Number (0-9) and upper letters (A-Z) and special characters and space\n* Capacity: No specific restrictions.';
    case "code_93":
      return '* Ex. CODE93SAMPLE\n* Charset: Number (0-9) and upper letters (A-Z) and special characters and space\n* Capacity: No specific restrictions.';
    case "code_128":
      return '* Ex. CODE128SAMPLE\n* Charset: All 128 ASCII characters\n* Capacity: No specific restrictions.';
    case "codabar":
      return '* Ex. 0123456789\n* Charset: Number (0-9) and special characters (\$/-:+)\n* Capacity: No specific restrictions.';
    case "itf":
      return '* Ex. 0123456789\n* Charset: Number (0-9)\n* Capacity: Even number of digits';
    case "itf_14":
      return '* Ex. 01234567890123\n* Charset: Number (0-9)\n* Capacity: 14 digits';
    case "itf_16":
      return '* Ex. 0123456789012345\n* Charset: Number (0-9)\n* Capacity: 16 digits';
    case "telepen":
      return "* Telepen\n* Charset: All uppercase letters (A-Z), numbers (0-9), and special characters (\$/+%-)";
    case "rm4scc":
      return "* RM4SCC\n* Charset: All uppercase letters (A-Z) and numbers (0-9)";
    case "data_matrix":
      return "* Data Matrix\n* Charset: All printable ASCII characters";
    case "aztec":
      return "* Aztec\n* Charset: All printable ASCII characters";
    case "isbn":
      return "* ISBN\n* Ex. 9780132350884\n* Charset: Number (0-9)\n* Capacity: 13 digits";
    case "gs1_128":
      return "* GS1-128 (UCC/EAN-128)\n* Charset: All printable ASCII characters";
    default:
      return "Barcode type not recognized";
  }
}


String generateUniqueString() {
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String randomChars = generateRandomChars(4);
  String uniqueString = timestamp.substring(timestamp.length - 4) + randomChars;
  return uniqueString;
}

String generateRandomChars(int length) {
  const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}