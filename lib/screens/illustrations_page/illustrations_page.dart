import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/hero_image.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page_body.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page_empty.dart';
import 'package:rootasjey/types/alias/firestore/document_change_map.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_illustration_item_action.dart';
import 'package:rootasjey/types/illustration/illustration.dart';
import 'package:rootasjey/types/intents/escape_intent.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/types/user/user_rights.dart';
import 'package:unicons/unicons.dart';

class IllustrationsPage extends ConsumerStatefulWidget {
  const IllustrationsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DrawingsPageState();
}

class _DrawingsPageState extends ConsumerState<IllustrationsPage> with UiLoggy {
  /// True if there're more posts to fetch.
  bool _hasNext = true;

  /// True if the page is fetching illustrations.
  bool _loading = false;

  /// True if the app is fetching more illustration data.
  bool _loadingMore = false;

  /// Last document fetched from Firestore.
  DocumentSnapshot? _lastDocument;

  /// Maximum posts fetch per page.
  final int _limit = 10;

  final List<Illustration> _illustrations = [];

  /// Listens to posts' updates.
  QuerySnapshotStreamSubscription? _illustrationSubscription;

  /// Popup menu items for post card.
  final List<PopupMenuEntry<EnumIllustrationItemAction>>
      _illustrationPopupMenuItems = [
    PopupMenuItemIcon(
      icon: const PopupMenuIcon(UniconsLine.trash),
      textLabel: "delete".tr(),
      newValue: EnumIllustrationItemAction.delete,
      selected: false,
    ),
  ];

  /// Page scroll controller.
  final ScrollController _pageScrollController = ScrollController();

  /// Firestore collection name.
  final String _collectionName = "illustrations";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _illustrationSubscription?.cancel();
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return LoadingView.scaffold(
        message: "illustrations_loading".tr(),
      );
    }

    final Size windowSize = MediaQuery.of(context).size;

    final UserFirestore? userFirestore =
        ref.watch(AppState.userProvider).firestoreUser;
    final UserRights userRights = userFirestore?.rights ?? const UserRights();
    final bool canManageIllustrations = userRights.manageIllustrations;

    if (_illustrations.isEmpty) {
      return wrapWithShortcuts(
        child: IllustrationsPageEmpty(
          canCreate: canManageIllustrations,
          fab: fab(show: canManageIllustrations),
          onShowCreatePage: onSelectFiles,
          onCancel: onCancel,
        ),
      );
    }

    return wrapWithShortcuts(
      child: IllustrationsPageBody(
        illustrations: _illustrations,
        fab: fab(show: canManageIllustrations),
        popupMenuItems:
            canManageIllustrations ? _illustrationPopupMenuItems : [],
        onPopupMenuItemSelected: onPopupMenuItemSelected,
        onTapIllustration: onTapIllustration,
        windowSize: windowSize,
      ),
    );
  }

  Widget fab({bool show = true}) {
    if (!show) {
      return Container();
    }

    return FloatingActionButton.extended(
      onPressed: onSelectFiles,
      label: Text(
        "upload".tr(),
        style: Utilities.fonts.body(
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      foregroundColor: Colors.white,
      backgroundColor: Constants.colors.palette.first,
      icon: const Icon(UniconsLine.upload),
      extendedPadding: const EdgeInsets.symmetric(horizontal: 28.0),
    );
  }

  /// Wrap the target widget with keyboard shortcuts.
  Widget wrapWithShortcuts({required Widget child}) {
    const shortcuts = <SingleActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): EscapeIntent(),
    };

    final actions = <Type, Action<Intent>>{
      EscapeIntent: CallbackAction(
        onInvoke: (Intent intent) => onCancel(),
      ),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }

  void fetchData() {
    fetchIllustrations();
  }

  void fetchIllustrations() async {
    setState(() {
      _loading = true;
      _hasNext = true;
      _illustrations.clear();
    });
    try {
      final QueryMap query = getFetchQuery();
      final QuerySnapMap snapshot = await query.get();

      listenIllustrationsEvents(getListenQuery());

      if (snapshot.docs.isEmpty) {
        setState(() {
          _loading = false;
          _hasNext = false;
        });

        return;
      }

      for (final QueryDocSnapMap document in snapshot.docs) {
        final Json data = document.data();
        data["id"] = document.id;
        _illustrations.add(Illustration.fromMap(data));
      }

      setState(() {
        _lastDocument = snapshot.docs.last;
        _hasNext = snapshot.docs.length == _limit;
      });
    } catch (error) {
      loggy.error(error);
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Fetch more illustrations data from Firestore.
  void fetchMoreIllustrations() async {
    if (!_hasNext || _lastDocument == null || _loadingMore) {
      return;
    }

    _loadingMore = true;

    try {
      final QueryMap? query = getFetchMoreQuery();
      if (query == null) {
        return;
      }

      final QuerySnapMap snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _hasNext = false;
          _loadingMore = false;
        });

        return;
      }

      for (QueryDocSnapMap document in snapshot.docs) {
        final Json data = document.data();
        data["id"] = document.id;

        _illustrations.add(Illustration.fromMap(data));
      }

      setState(() {
        _lastDocument = snapshot.docs.last;
        _hasNext = snapshot.docs.length == _limit;
        _loadingMore = false;
      });

      listenIllustrationsEvents(getListenQuery());
    } catch (error) {
      loggy.error(error);
    } finally {
      _loadingMore = false;
    }
  }

  /// Return query to fetch illustrations according to the selected tab.
  /// It's either active illustrations or archvied ones.
  QueryMap getFetchQuery() {
    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("visibility", isEqualTo: "public")
        .orderBy("user_custom_index", descending: true)
        .limit(_limit);
  }

  /// Return query to fetch more illustrations according to the selected tab.
  /// It's either active illustrations or archvied ones.
  QueryMap? getFetchMoreQuery() {
    final DocumentSnapshot? lastDocument = _lastDocument;
    if (lastDocument == null) {
      return null;
    }

    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("visibility", isEqualTo: "public")
        .orderBy("user_custom_index", descending: true)
        .limit(_limit)
        .startAfterDocument(lastDocument);
  }

  /// Return the query without an initial document for pagination.
  /// This query can be used to listen to documents.
  QueryMap? getInitialListenQuery() {
    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("visibility", isEqualTo: "public")
        .orderBy("user_custom_index", descending: true);
  }

  /// Return the query to listen changes to.
  QueryMap? getListenQuery() {
    final DocumentSnapshot? lastDocument = _lastDocument;

    if (lastDocument == null) {
      return getInitialListenQuery();
    }

    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("visibility", isEqualTo: "public")
        .orderBy("user_custom_index", descending: true)
        .endAtDocument(lastDocument);
  }

  /// Listen to tillustrations'events.
  void listenIllustrationsEvents(QueryMap? query) {
    if (query == null) {
      return;
    }

    _illustrationSubscription?.cancel();
    _illustrationSubscription = query.snapshots().skip(1).listen(
      (snapshot) {
        for (DocumentChangeMap documentChange in snapshot.docChanges) {
          switch (documentChange.type) {
            case DocumentChangeType.added:
              onAddStreamingIllustration(documentChange);
              break;
            case DocumentChangeType.modified:
              onUpdateStreamingIllustration(documentChange);
              break;
            case DocumentChangeType.removed:
              onRemoveStreamingIllustration(documentChange);
              break;
          }
        }
      },
      onError: (error) {
        loggy.error(error);
      },
    );
  }

  /// Fire when a new illustration is created in the collection.
  /// Add the corresponding document in the UI.
  void onAddStreamingIllustration(DocumentChangeMap documentChange) {
    final Json? data = documentChange.doc.data();
    if (data == null) {
      return;
    }

    setState(() {
      data["id"] = documentChange.doc.id;
      final illustration = Illustration.fromMap(data);
      _illustrations.insert(0, illustration);
    });
  }

  void onCancel() {
    if (Beamer.of(context).beamingHistory.isNotEmpty) {
      Beamer.of(context).beamBack();
      return;
    }

    Beamer.of(context, root: true).beamToNamed(HomeLocation.route);
  }

  /// Callback fired when an item is selected in an illustration popup menu.
  void onPopupMenuItemSelected(
    EnumIllustrationItemAction action,
    int index,
    Illustration illustration,
    String stringKey,
  ) {
    switch (action) {
      case EnumIllustrationItemAction.delete:
        tryDeleteIllustration(illustration, index);
        break;
      default:
    }
  }

  /// Fire when a new document has been delete from Firestore.
  /// Delete the corresponding document from the UI.
  void onRemoveStreamingIllustration(DocumentChangeMap documentChange) {
    setState(() {
      _illustrations.removeWhere(
        (illustration) => illustration.id == documentChange.doc.id,
      );
    });
  }

  void onSelectFiles() {
    final String userId =
        ref.read(AppState.userProvider).firestoreUser?.id ?? "";

    if (userId.isEmpty) {
      return;
    }

    ref.read(AppState.uploadTaskListProvider.notifier).pickIllustrations(
          userId: userId,
        );
  }

  void onTapIllustration(Illustration illustration) {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
    }

    context.pushTransparentRoute(
      HeroImage(
        heroTag: illustration.id,
        imageProvider: NetworkImage(illustration.getHDThumbnail()),
      ),
    );
  }

  /// Fire when a new document has been updated in Firestore.
  /// Update the corresponding document in the UI.
  void onUpdateStreamingIllustration(DocumentChangeMap documentChange) {
    final Json? data = documentChange.doc.data();
    if (!documentChange.doc.exists || data == null) {
      return;
    }

    final int index = _illustrations.indexWhere(
      (Illustration illustration) => illustration.id == documentChange.doc.id,
    );

    if (index < 0) {
      return;
    }

    data["id"] = documentChange.doc.id;
    final Illustration updatedIllustration = Illustration.fromMap(data);

    setState(() {
      _illustrations.removeAt(index);
      _illustrations.insert(index, updatedIllustration);
    });
  }

  /// Method that tries to delete a single illustration.
  void tryDeleteIllustration(Illustration illustration, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(illustration.id)
          .delete();
    } catch (error) {
      loggy.error(error);
    }
  }
}
