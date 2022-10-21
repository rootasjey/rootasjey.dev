import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:mime_type/mime_type.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/types/custom_upload_task.dart';

class UploadTaskListNotifier extends StateNotifier<List<CustomUploadTask>>
    with UiLoggy {
  UploadTaskListNotifier(List<CustomUploadTask> state) : super(state);

  /// Return number of tasks which are either in 1st phase
  /// (Firestor doc creation) or in an uploading/paused state.
  /// This property can be used to update the UI (showing a progress bar)
  /// immediately after selecting a file, and not when the file upload starts.
  /// Which is usally several seconds later.
  int get pendingTaskCount => state.where((customTask) {
        final task = customTask.task;
        return task == null ||
            task.snapshot.state == TaskState.running ||
            task.snapshot.state == TaskState.paused;
      }).length;

  int get abortedTaskCount => state.where((uploadTask) {
        return uploadTask.task?.snapshot.state == TaskState.canceled ||
            uploadTask.task?.snapshot.state == TaskState.error;
      }).length;

  int get successTaskCount => state.where((uploadTask) {
        return uploadTask.task?.snapshot.state == TaskState.success;
      }).length;

  int get runningTaskCount => state.where((uploadTask) {
        return uploadTask.task?.snapshot.state == TaskState.running;
      }).length;

  int get pausedTaskCount => state.where((uploadTask) {
        return uploadTask.task?.snapshot.state == TaskState.paused;
      }).length;

  void add(CustomUploadTask customUploadTask) {
    state = [
      ...state,
      customUploadTask,
    ];
  }

  void clear() {
    state = [];
  }

  void pauseAll() {
    for (var customUploadTask in state) {
      customUploadTask.task?.pause();
    }
  }

  void resumeAll() {
    for (var customUploadTask in state) {
      customUploadTask.task?.resume();
    }
  }

  void remove(CustomUploadTask customUploadTask) {
    state = state.where((uploadTask) {
      return uploadTask.targetId != customUploadTask.targetId;
    }).toList();
  }

  void cancelAll() {
    for (var customUploadTask in state) {
      if (customUploadTask.task?.snapshot.state != TaskState.success) {
        _cleanTask(customUploadTask);
        continue;
      }

      removeDone(customUploadTask);
    }
  }

  void cancel(CustomUploadTask customUploadTask) {
    _cleanTask(customUploadTask);
  }

  void removeDone(CustomUploadTask customUploadTask) {
    remove(customUploadTask);
  }

  /// A "select file/folder" window will appear. User will have to choose a file.
  /// This file will be then read, and uploaded to firebase storage;
  Future<FilePickerResult?> pickImage({required String targetId}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: Constants.allowedImageExt,
      allowMultiple: false,
      type: FileType.custom,
      withData: true,
    );

    if (result == null || result.count == 0) {
      return result;
    }

    result.files.retainWhere(_checkSize);

    if (result.count == 0) {
      return result;
    }

    final PlatformFile firstFile = result.files.first;
    _uploadCover(file: firstFile, targetId: targetId);

    return result;
  }

  /// Return true if the size is below 25Mo. Return false otherwise.
  bool _checkSize(PlatformFile file) {
    if (file.bytes == null) {
      return false;
    }

    if (file.size > 25 * 1024 * 1024) {
      return false;
    }

    return true;
  }

  Future<CustomUploadTask> _uploadCover({
    required PlatformFile file,
    required String targetId,
  }) async {
    String fileName =
        file.name.isNotEmpty ? file.name : "unknown-${DateTime.now()}";

    final CustomUploadTask customUploadTask = CustomUploadTask(
      name: fileName,
    );

    add(customUploadTask);

    if (targetId.isEmpty) {
      _cleanTask(customUploadTask);
      return customUploadTask;
    }

    customUploadTask.targetId = targetId;

    return await _startStorageUpload(
      file: file,
      fileName: fileName,
      targetId: targetId,
      customUploadTask: customUploadTask,
    );
  }

  Future<CustomUploadTask> _startStorageUpload({
    required PlatformFile file,
    required String fileName,

    /// Project's id or Post's id.
    required String targetId,
    required CustomUploadTask customUploadTask,
  }) async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (userId.isEmpty) {
      return customUploadTask;
    }

    String extension = file.extension ?? "";

    if (extension.isEmpty) {
      final int lastIndexDot = fileName.lastIndexOf(".") + 1;
      extension = fileName.substring(lastIndexDot);
    }

    final String cloudStorageFilePath =
        "projects/$targetId/cover/original.$extension";

    final FirebaseStorage storage = FirebaseStorage.instance;
    final UploadTask uploadTask = storage.ref(cloudStorageFilePath).putData(
        file.bytes ?? Uint8List(0),
        SettableMetadata(
          customMetadata: {
            "document_id": targetId,
            "document_type": "cover",
            "extension": extension,
            "related_document_type": "project",
            "user_id": userId,
            "visibility": "public",
          },
          contentType: mimeFromExtension(
            extension,
          ),
        ));

    customUploadTask.task = uploadTask;

    final List<CustomUploadTask> filteredState = state.where((customTask) {
      return customTask.targetId != customUploadTask.targetId;
    }).toList();

    state = [
      ...filteredState,
      customUploadTask,
    ];

    try {
      await uploadTask;
    } on FirebaseException catch (error) {
      loggy.error(error);
    } catch (error) {
      loggy.error(error);
    }

    state = [...state];
    return customUploadTask;
  }

  /// Remove the target task from state,
  /// Cancel upload (if it can), delete corresponding Firestore document,
  /// and Firebase storage file (if it has been created).
  void _cleanTask(CustomUploadTask customUploadTask) {
    remove(customUploadTask);
    customUploadTask.task?.cancel();
  }
}
