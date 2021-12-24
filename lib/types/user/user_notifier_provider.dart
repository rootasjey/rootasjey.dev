import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/types/user/user.dart';

typedef UserNotifierProvider = StateNotifierProvider<StateNotifier<User>, User>;
