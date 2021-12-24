import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/types/user/user_notifier.dart';
import 'package:rootasjey/types/user/user.dart';

class GlobalState {
  final user = StateNotifierProvider<UserNotifier, User>(
    (ref) => UserNotifier(User()),
  );
}
