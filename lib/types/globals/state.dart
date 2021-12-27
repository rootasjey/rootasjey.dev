import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/types/user/user_auth.dart';
import 'package:rootasjey/types/user/user_notifier.dart';
import 'package:rootasjey/types/user/user.dart';
import 'package:rootasjey/types/user_firestore.dart';

class GlobalsState {
  final user = StateNotifierProvider<UserNotifier, User>(
    (ref) => UserNotifier(User()),
  );

  UserFirestore getUserFirestore() {
    final containerProvider = ProviderContainer();
    return containerProvider.read(user).firestoreUser ?? UserFirestore.empty();
  }

  UserAuth? getUserAuth() {
    final containerProvider = ProviderContainer();
    return containerProvider.read(user).authUser;
  }

  UserNotifier getUserNotifier() {
    final containerProvider = ProviderContainer();
    return containerProvider.read(user.notifier);
  }
}
