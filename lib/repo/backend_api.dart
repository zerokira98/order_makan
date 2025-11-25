import 'dart:convert' show jsonEncode;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:http/http.dart' as http;
import 'package:order_makan/helper.dart' show baseApiUrl, apiKey;

class BackendApi {
  static Future<http.Response> testHit() {
    if (kDebugMode) {
      print('base:$baseApiUrl');
    }
    return http.get(Uri.parse(baseApiUrl));
  }

  static Future sendNotifOrderCreated(String strukId) {
    return http.post(Uri.parse("$baseApiUrl/notif-order-created"),
        headers: {"x-api-key": apiKey, "Content-Type": "application/json"},
        body: jsonEncode({"strukId": strukId}));
  }
}
