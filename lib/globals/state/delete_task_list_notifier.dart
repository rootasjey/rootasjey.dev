import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/types/custom_upload_task.dart';

/// Tasks which need to be deleted asynchronously.
class DeleteTaskListNotifier extends StateNotifier<List<CustomUploadTask>> {
  DeleteTaskListNotifier(List<CustomUploadTask> state) : super(state);

  void add(CustomUploadTask customUploadTask) {
    state = [
      ...state,
      customUploadTask,
    ];
  }

  void clear() {
    state = [];
  }

  void remove(CustomUploadTask customUploadTask) {
    state = state.where((uploadTask) {
      return uploadTask.targetId != customUploadTask.targetId;
    }).toList();
  }
}
