import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/user.dart';
import 'package:quickmart/repo/user_repository.dart';

class UserNotifier extends Notifier<List<User>> {
  final usersRepository = UsersRepository();
  @override
  List<User> build() {
    initializeState();
    return [];
  }

  void initializeState() async {
    state = await usersRepository.getUsers();
  }

  void addUser(User user) {
    state = [...state, user];
  }

  bool validateCredentials(String email, String password) {
    return usersRepository.validateCredentials(email, password);
  }
}

final userNotifierProvider =
    NotifierProvider<UserNotifier, List<User>>(() => UserNotifier());
