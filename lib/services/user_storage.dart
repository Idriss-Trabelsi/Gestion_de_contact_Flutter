import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';

class UserStorage {
  static Future<List<User>> loadUsers() async {
    final String data = await rootBundle.loadString('assets/json/users.json');
    final List<dynamic> jsonResult = json.decode(data);
    return jsonResult.map((e) => User.fromJson(e)).toList();
  }
}
