import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:loggy/loggy.dart';
import 'package:mime_type/mime_type.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/types/custom_upload_task.dart';
import 'package:rootasjey/types/enums/enum_upload_type.dart';

class AppStateIllustrations with UiLoggy {
  AppStateIllustrations() {
    uploadTotalBytes = Computed(
      () => uploadTaskList.value.where((CustomUploadTask customTask) {
        final UploadTask? task = customTask.task;
        if (task == null) return false;

        final TaskState state = task.snapshot.state;
        return state == TaskState.running || state == TaskState.paused;
      }).fold(0, (totalBytes, customTask) {
        final int taskBytes = customTask.task?.snapshot.totalBytes ?? 0;
        return totalBytes + taskBytes;
      }),
    );

    uploadPercentage = Computed(() {
      final int uploadBytes = uploadBytesTransferred.value;
      final int? totalBytes = uploadTotalBytes?.value;

      if (totalBytes == null) {
        return 0;
      }

      double ratio = uploadBytes / totalBytes;
      if (ratio.isNaN || ratio.isInfinite) {
        ratio = 0.0;
      }

      final double percent = ratio * 100;
      return percent.round();
    });

    showUploadWindow = Computed(() {
      return uploadTaskList.value.isNotEmpty;
    });

    pendingTaskCount = Computed(() {
      return uploadTaskList.value.where((customUploadTask) {
        final task = customUploadTask.task;
        return task == null ||
            task.snapshot.state == TaskState.running ||
            task.snapshot.state == TaskState.paused;
      }).length;
    });

    abortedTaskCount = Computed(() {
      return uploadTaskList.value.where((customUploadTask) {
        final task = customUploadTask.task;
        return task?.snapshot.state == TaskState.canceled ||
            task?.snapshot.state == TaskState.error;
      }).length;
    });

    successTaskCount = Computed(() {
      return uploadTaskList.value.where((customUploadTask) {
        final task = customUploadTask.task;
        return task?.snapshot.state == TaskState.success;
      }).length;
    });

    runningTaskCount = Computed(() {
      return uploadTaskList.value.where((customUploadTask) {
        final task = customUploadTask.task;
        return task?.snapshot.state == TaskState.running;
      }).length;
    });

    pausedTaskCount = Computed(() {
      return uploadTaskList.value.where((customUploadTask) {
        final task = customUploadTask.task;
        return task?.snapshot.state == TaskState.paused;
      }).length;
    });
  }

  /// Upload task list signal.
  final Signal<List<CustomUploadTask>> uploadTaskList = Signal([]);

  /// Upload bytes transferred signal.
  final Signal<int> uploadBytesTransferred = Signal(0);

  /// Upload total bytes signal.
  Computed<int>? uploadTotalBytes;

  /// Upload percentage signal.
  Computed<int>? uploadPercentage;

  /// Upload window visibility signal.
  Computed<bool>? showUploadWindow;

  /// Pending task count.
  late Computed<int> pendingTaskCount;

  /// Aborted task count.
  late Computed<int> abortedTaskCount;

  /// Success task count.
  late Computed<int> successTaskCount;

  /// Running task count.
  late Computed<int> runningTaskCount;

  /// Paused task count.
  late Computed<int> pausedTaskCount;

  /// Add a new upload task to the pending upload queue.
  void add(CustomUploadTask customUploadTask) {
    uploadTaskList.updateValue((prevList) => [...prevList, customUploadTask]);
  }

  /// Empty the upload queue.
  void clear() {
    uploadTaskList.value = [];
  }

  /// Pause all upload tasks.
  void pauseAll() {
    for (var customUploadTask in uploadTaskList.value) {
      customUploadTask.task?.pause();
    }
  }

  /// Resume all upload tasks.
  void resumeAll() {
    for (var customUploadTask in uploadTaskList.value) {
      customUploadTask.task?.resume();
    }
  }

  /// Remove the target upload task.
  void remove(CustomUploadTask customUploadTask) {
    uploadTaskList.value = uploadTaskList.value.where((uploadTask) {
      return uploadTask.targetId != customUploadTask.targetId;
    }).toList();
  }

  /// Cancel each existing task in the queue.
  void cancelAll() {
    for (var customUploadTask in uploadTaskList.value) {
      if (customUploadTask.task?.snapshot.state != TaskState.success) {
        _cleanTask(customUploadTask);
        continue;
      }

      removeDone(customUploadTask);
    }
  }

  /// Cancel the target upload task.
  void cancel(CustomUploadTask customUploadTask) {
    _cleanTask(customUploadTask);
  }

  /// Remove the target upload task.
  /// It should be called when the task is completed.
  void removeDone(CustomUploadTask customUploadTask) {
    remove(customUploadTask);
  }

  /// Choose an image to use as a cover.
  Future<FilePickerResult?> pickCover({
    required EnumUploadType uploadType,
    required String targetId,
    required String userId,
  }) async {
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
    _uploadCover(
      file: firstFile,
      targetId: targetId,
      userId: userId,
    );

    return result;
  }

  /// Choose an image to upload as a new illustration.
  Future<FilePickerResult?> pickIllustrations({required String userId}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: Constants.allowedImageExt,
      allowMultiple: true,
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

    for (final file in result.files) {
      _uploadIllustration(
        file: file,
        userId: userId,
      );
    }

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

  Future<CustomUploadTask> _uploadIllustration({
    required PlatformFile file,
    required String userId,
  }) async {
    String fileName =
        file.name.isNotEmpty ? file.name : "unknown-${DateTime.now()}";

    final CustomUploadTask customUploadTask = CustomUploadTask(
      name: fileName,
    );

    add(customUploadTask);

    String extension = file.extension ?? "";
    if (extension.isEmpty) {
      final int lastIndexDot = fileName.lastIndexOf(".") + 1;
      extension = fileName.substring(lastIndexDot);
    }

    final illustrationSnapshot =
        await FirebaseFirestore.instance.collection("illustrations").add({
      "extension": extension,
      "name": fileName,
      "user_id": userId,
      "visibility": "public",
    });

    customUploadTask.targetId = illustrationSnapshot.id;

    return await _startStorageUpload(
      extension: extension,
      file: file,
      fileName: fileName,
      targetId: illustrationSnapshot.id,
      customUploadTask: customUploadTask,
      uploadType: EnumUploadType.illustration,
      userId: userId,
    );
  }

  Future<CustomUploadTask> _uploadCover({
    required PlatformFile file,
    required String targetId,
    required String userId,
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

    String extension = file.extension ?? "";

    if (extension.isEmpty) {
      final int lastIndexDot = fileName.lastIndexOf(".") + 1;
      extension = fileName.substring(lastIndexDot);
    }

    return await _startStorageUpload(
      customUploadTask: customUploadTask,
      extension: extension,
      file: file,
      fileName: fileName,
      targetId: targetId,
      uploadType: EnumUploadType.projectCover,
      userId: userId,
    );
  }

  /// Return file metadata according to the upload purpose
  /// (e.g. gg, post's cover).
  Map<String, String> getCustomMetadata({
    required EnumUploadType uploadType,
    required String extension,
    required String targetId,
    required String userId,
  }) {
    switch (uploadType) {
      case EnumUploadType.illustration:
        return {
          "document_id": targetId,
          "document_type": "illustration",
          "extension": extension,
          "related_document_type": "illustration",
          "user_id": userId,
          "visibility": "public",
        };
      case EnumUploadType.postCover:
        return {
          "document_id": targetId,
          "document_type": "cover",
          "extension": extension,
          "related_document_type": "post",
          "user_id": userId,
          "visibility": "public",
        };
      case EnumUploadType.projectCover:
        return {
          "document_id": targetId,
          "document_type": "cover",
          "extension": extension,
          "related_document_type": "project",
          "user_id": userId,
          "visibility": "public",
        };
      default:
        return {};
    }
  }

  /// Return a storage path according to the upload purpose
  /// (e.g. illustration, post's cover).
  String getStoragePath({
    required EnumUploadType uploadType,
    required String targetId,
    required String extension,
  }) {
    switch (uploadType) {
      case EnumUploadType.illustration:
        return "illustrations/$targetId/original.$extension";
      case EnumUploadType.postCover:
        return "posts/$targetId/cover/original.$extension";
      case EnumUploadType.projectCover:
        return "projects/$targetId/cover/original.$extension";
      default:
        return "";
    }
  }

  Future<CustomUploadTask> _startStorageUpload({
    required PlatformFile file,
    required String fileName,
    required String extension,

    /// Project's id or Post's id.
    required String targetId,

    /// Current authenticated user id.
    required String userId,
    required CustomUploadTask customUploadTask,
    required EnumUploadType uploadType,
  }) async {
    if (userId.isEmpty) {
      return customUploadTask;
    }

    final storagePath = getStoragePath(
      uploadType: uploadType,
      targetId: targetId,
      extension: extension,
    );

    final FirebaseStorage storage = FirebaseStorage.instance;

    final UploadTask uploadTask = storage.ref(storagePath).putData(
        file.bytes ?? Uint8List(0),
        SettableMetadata(
          customMetadata: getCustomMetadata(
            uploadType: uploadType,
            extension: extension,
            targetId: targetId,
            userId: userId,
          ),
          contentType: mimeFromExtension(
            extension,
          ),
        ));

    customUploadTask.task = uploadTask;

    final List<CustomUploadTask> filteredState =
        uploadTaskList.value.where((customTask) {
      return customTask.targetId != customUploadTask.targetId;
    }).toList();

    uploadTaskList.value = [
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

    uploadTaskList.set(uploadTaskList.value);
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
