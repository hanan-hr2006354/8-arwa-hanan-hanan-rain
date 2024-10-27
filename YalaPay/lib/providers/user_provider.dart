import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/user.dart';

class UserNotifier extends Notifier<List<User>> {
  @override
  List<User> build() {
    initializeState();
    return [];
  }

  void initializeState() async {
    var data = await rootBundle.loadString('assets/data/users.json');

    var usersMap = jsonDecode(data);
    for (var userMap in usersMap) {
      addUser(User.fromJson(userMap));
    }
  }

  void addUser(User user) {
    state = [...state, user];
  }

  bool validateCredentials(String username, String password) {
    print(state);

    return state
        .any((user) => user.username == username && user.password == password);
  }
}

final userNotifierProvider =
    NotifierProvider<UserNotifier, List<User>>(() => UserNotifier());
