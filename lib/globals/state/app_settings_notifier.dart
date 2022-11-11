import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/types/alias/firestore/doc_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/firestore/document_map.dart';
import 'package:rootasjey/types/alias/firestore/document_snapshot_map.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/app_settings.dart';

class AppSettingsNotifier extends StateNotifier<AppSettings> with UiLoggy {
  AppSettingsNotifier(AppSettings state) : super(state) {
    fetchSettings();
  }

  /// Listens to app settings' updates.
  DocSnapshotStreamSubscription? _appSettingsSubscription;

  Future<void> fetchSettings() async {
    try {
      final query = FirebaseFirestore.instance
          .collection("settings")
          .doc("social_networks");

      final snapshot = await query.get();
      final Json? map = snapshot.data();
      if (!snapshot.exists || map == null) {
        return;
      }

      final AppSettings appSettings = AppSettings.fromMap(map);
      state = appSettings;

      _listenToFirestoreChanges(query);
    } catch (error) {
      loggy.error(error);
    }
  }

  void _listenToFirestoreChanges(DocumentMap query) {
    _appSettingsSubscription?.cancel();
    _appSettingsSubscription = query.snapshots().listen(
          _onFirestoreData,
          onError: _onFirestoreError,
          onDone: _onFirestoreDone,
        );
  }

  void _onFirestoreData(DocumentSnapshotMap snapshot) {
    final Json? map = snapshot.data();
    if (!snapshot.exists || map == null) {
      return;
    }

    final AppSettings appSettings = AppSettings.fromMap(map);
    state = appSettings;
  }

  void _onFirestoreError(error) {
    loggy.error(error);
  }

  void _onFirestoreDone() {
    state = AppSettings.empty();
    _appSettingsSubscription?.cancel();
  }
}
