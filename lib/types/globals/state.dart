import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/types/user/user_notifier.dart';
import 'package:rootasjey/types/user/user.dart';
import 'package:rootasjey/types/user_firestore.dart';

class GlobalState {
  final user = StateNotifierProvider<UserNotifier, User>(
    (ref) => UserNotifier(User()),
  );

  UserFirestore getUserFirestore() {
    final containerProvider = ProviderContainer();
    return containerProvider.read(user).firestoreUser ?? UserFirestore.empty();
  }

  UserNotifier getUserNotifier() {
    final containerProvider = ProviderContainer();
    return containerProvider.read(user.notifier);
  }
}
