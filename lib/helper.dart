import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:order_makan/repo/user_model.dart' show User;

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

String? usernameValidator(String? value) {
  if (value == null) return "not initialized";
  if (value.isEmpty) return "cant empty";
  if (value.length < 3) return "too short";
  return null;
}

NumberFormat numfor = NumberFormat("###,###", 'ID_id');

extension Uppercasing on String {
  String firstUpcase() {
    String a = this[0].toUpperCase() + substring(1);

    return a;
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

extension UserParsing on auth.User {
  User get toUser {
    return User(
        email: email, foto: photoURL, namaKaryawan: displayName, id: uid);
  }
}

extension DateParsing on DateTime {
  String get clockTimeOnly {
    return "$hour:$minute:$second";
  }
}

extension DurationParsing on Duration {
  // String get clockTimeOnly {
  //   this.
  //   return "$:$minute:$second";
  // }
}
