import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'newtwork_helper.dart';

class UserId {
  static Future<int> getUserId() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    //prefs.clear();
    int userId = prefs.getInt('userId');

    if (userId == null) {
      String token = await FirebaseMessaging.instance.getToken();
      print(token);
      NetworkHelper networkHelper = NetworkHelper(
          'http://${NetworkHelper.apiHost}/api/user?token=$token');
      userId = await networkHelper.getData();
      prefs.setInt('userId', userId);
    }
    print('id ${userId}');
    return userId;
  }
}
