import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yala_pay/model/user.dart';

class UserRepository {
  Future<List<User>> getUsers() async {
    var jsonString = await rootBundle.loadString('assets/data/users.json');
    final List<dynamic> data = jsonDecode(jsonString);
    return data.map((json) => User.fromJson(json)).toList();
  }
}
