import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/globals/state/app_settings_notifier.dart';
import 'package:rootasjey/globals/state/show_upload_window_notifier.dart';
import 'package:rootasjey/globals/state/upload_bytes_transferred_notifier.dart';
import 'package:rootasjey/globals/state/upload_task_list_notifier.dart';
import 'package:rootasjey/types/app_settings.dart';
import 'package:rootasjey/types/custom_upload_task.dart';
import 'package:rootasjey/types/user/user.dart';
import 'package:rootasjey/globals/state/user_notifier.dart';

class AppState {
  static final appSettingsProvider = _appSettingsProvider;
  static final showUploadWindowProvider = _showUploadWindowProvider;
  static final uploadBytesTransferredProvider = _uploadBytesTransferredProvider;
  static final uploadPercentageProvider = _uploadPercentageProvider;
  static final uploadTaskListProvider = _uploadTaskListProvider;
  static final uploadTotalBytesProvider = _uploadTotalBytesProvider;
  static var userProvider = _userNotifierProvider;
}

// App settings
// ------------
final _appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>(
  (ref) => AppSettingsNotifier(AppSettings.empty()),
);

// User
// -----
final _userNotifierProvider = StateNotifierProvider<UserNotifier, User>(
  (ref) => UserNotifier(User()),
);

// Upload
// ------
final _uploadTaskListProvider =
    StateNotifierProvider<UploadTaskListNotifier, List<CustomUploadTask>>(
  (ref) => UploadTaskListNotifier([]),
);

final _uploadPercentageProvider = Provider<int>((ref) {
  final int uploadBytes = ref.watch(_uploadBytesTransferredProvider);
  final int totalBytes = ref.watch(_uploadTotalBytesProvider);

  double ratio = uploadBytes / totalBytes;

  if (ratio.isNaN || ratio.isInfinite) {
    ratio = 0.0;
  }

  final double percent = ratio * 100;
  return percent.round();
});

final _uploadTotalBytesProvider = Provider<int>((ref) {
  return ref.watch(_uploadTaskListProvider).where((customTask) {
    final UploadTask? task = customTask.task;
    if (task == null) return false;

    final TaskState state = task.snapshot.state;
    return state == TaskState.running || state == TaskState.paused;
  }).fold(0, (totalBytes, customTask) {
    final int taskBytes = customTask.task?.snapshot.totalBytes ?? 0;
    return totalBytes + taskBytes;
  });
});

final _uploadBytesTransferredProvider =
    StateNotifierProvider<UploadBytesTransferredNotifier, int>((ref) {
  return UploadBytesTransferredNotifier(0);
});

final _showUploadWindowProvider =
    StateNotifierProvider<ShowUploadWindowNotifier, bool>((ref) {
  final bool shouldShow = ref.watch(_uploadTaskListProvider).isNotEmpty;
  return ShowUploadWindowNotifier(shouldShow);
});
