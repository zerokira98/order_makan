import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:order_makan/repo/user_model.dart' show User;

// String baseApiUrl = 'http://10.0.2.2:3001/ordermakan'; //android emulator
// String baseApiUrl = 'http://127.0.0.1:3001/ordermakan';//localhost
String baseApiUrl =
    'https://nodemid--get-order-a0bd7.asia-southeast1.hosted.app/ordermakan'; //firebase app hosting
String apiKey = "SaT1JjsUHiRxt3pxQXhP";

String? validateEmail(String? value) {
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return value!.isNotEmpty && !regex.hasMatch(value)
      ? 'Enter a valid email address'
      : null;
}

String? numberValidator(String? value) {
  if (value == null) return "not initialized";
  if (value.isEmpty) return "cant empty";
  if (int.tryParse(value) == null) return "not valid number";
  if (int.tryParse(value) == 0) return "cant zero";
  return null;
}

String? usernameValidator(String? value) {
  if (value == null) return "not initialized";
  if (value.isEmpty) return "cant empty";
  if (value.length < 3) return "too short";
  return null;
}
// String? usernameValidator(String? value) {
//   if (value == null) return "not initialized";
//   if (value.isEmpty) return "cant empty";
//   if (value.length < 3) return "too short";
//   return null;
// }

NumberFormat numfor = NumberFormat("###,###", 'ID_id');

extension Uppercasing on String {
  String get firstUpcase {
    if (isNotEmpty) {
      String a = this[0].toUpperCase() + substring(1);

      return a;
    }
    return this;
  }

  String numberFormat() {
    int? a = int.tryParse(this);
    if (a != null) {
      return numfor.format(a);
    } else {
      throw Exception('cant parse to int');
    }
    // return this.
  }
  // ···
}

extension Formatnum on num {
  String get numberFormatCurrency {
    try {
      return 'Rp${numfor.format(this)}';
    } catch (e) {
      return 'parse err$e';
    }
    // return this.
  }

  String numberFormat({bool? currency}) {
    try {
      if (currency == true) {
        return 'Rp${numfor.format(this)}';
      }
      return numfor.format(this);
    } catch (e) {
      return 'parse err$e';
    }
    // return this.
  }
}

extension UserParsing on auth.User {
  User get toUser {
    return User(
        email: email, foto: photoURL, namaKaryawan: displayName, id: uid);
  }
}

extension DateParsingNullable on DateTime? {
  DateTime? simpler() {
    if (this != null) {
      return DateTime(this!.year, this!.month, this!.day);
    } else {
      return null;
    }
  }

  ///yMMMd
  String formatBasic() {
    initializeDateFormatting();
    DateFormat tanggalFormat = DateFormat.yMMMd('ID_id');
    return this == null ? "Err: Null Value" : tanggalFormat.format(this!);
  }
}

extension DateParsing on DateTime {
  ///delete hour-minute-seconds from datetime [DateTime(year,month,day)]

  String get clockTimeOnly {
    return "$hour:$minute:$second";
  }

  String clockOnly() {
    initializeDateFormatting();
    DateFormat tanggalFormat = DateFormat.Hm('ID_id');
    return tanggalFormat.format(this);
  }

  String clockDetails() {
    initializeDateFormatting();
    StringBuffer thestring = StringBuffer();
    if (hour > 0) {
      thestring.write('${hour}jam ');
    }
    if (minute > 0) {
      thestring.write('${minute}menit ');
    }
    thestring.write('${second}detik');
    // DateFormat tanggalFormat = DateFormat.h('ID_id');
    return thestring.toString();
  }

  String formatLengkap() {
    initializeDateFormatting();
    DateFormat tanggalFormat = DateFormat('EEEE, d MMMM yyyy ', 'ID_id');
    return tanggalFormat.format(this);
  }

  ///10 Okt 2025
  String formatBasic() {
    initializeDateFormatting();
    DateFormat tanggalFormat = DateFormat.yMMMd('ID_id');
    return tanggalFormat.format(this);
  }

  ///Oktober 2025
  String formatMonthYear() {
    initializeDateFormatting();
    DateFormat tanggalFormat = DateFormat.yMMMM('ID_id');
    return tanggalFormat.format(this);
  }
}

extension DurationParsing on Duration {
  String clockDetails() {
    initializeDateFormatting();
    StringBuffer thestring = StringBuffer();

    if (inHours > 0) {
      thestring.write('${inHours}jam ');
    }
    if (inMinutes > 0) {
      thestring.write('${inMinutes % 60}menit ');
    }
    thestring.write('${inSeconds % 60}detik');
    // DateFormat tanggalFormat = DateFormat.h('ID_id');
    return thestring.toString();
  }
  // String get clockTimeOnly {
  //   this.
  //   return "$:$minute:$second";
  // }
}

enum Size {
  medium, //normal size text
  bold, //only bold text
  boldMedium, //bold with medium
  boldLarge, //bold with large
  extraLarge //extra large
}

enum Align {
  left, //ESC_ALIGN_LEFT
  center, //ESC_ALIGN_CENTER
  right, //ESC_ALIGN_RIGHT
}

extension PrintSize on Size {
  int get val {
    switch (this) {
      case Size.medium:
        return 0;
      case Size.bold:
        return 1;
      case Size.boldMedium:
        return 2;
      case Size.boldLarge:
        return 3;
      case Size.extraLarge:
        return 4;
    }
  }
}

extension PrintAlign on Align {
  int get val {
    switch (this) {
      case Align.left:
        return 0;
      case Align.center:
        return 1;
      case Align.right:
        return 2;
    }
  }
}
