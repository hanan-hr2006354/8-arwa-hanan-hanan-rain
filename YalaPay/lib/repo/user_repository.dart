// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:quickmart/models/user.dart';

// class UserRepository {
//   List<User> users = [];
//   Future<List<User>> getUsers() async {
//     var response = await rootBundle.loadString('assets/data/customers.json');
//     List<dynamic> jsonData = jsonDecode(response);
//     users = jsonData.map((item) => User.fromJson(item)).toList();
//     return users;
//   }

//   bool validateCredentials(String username, String password) {
//     return users
//         .any((user) => user.username == username && user.password == password);
//   }
// }
