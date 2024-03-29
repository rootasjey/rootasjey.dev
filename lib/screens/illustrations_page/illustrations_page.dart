import 'dart:io';
import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/actions/illustration_actions.dart';
import 'package:rootasjey/components/hero_image.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page_body.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page_empty.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page_fab.dart';
import 'package:rootasjey/types/alias/firestore/document_change_map.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_illustration_item_action.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';
import 'package:rootasjey/types/enums/enum_signal_id.dart';
import 'package:rootasjey/types/illustration/illustration.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/types/user/user_rights.dart';
import 'package:url_launcher/url_launcher.dart';

class IllustrationsPage extends StatefulWidget {
  const IllustrationsPage({
    super.key,
    this.onGoHome,
    this.onGoBack,
  });

  /// Called when the user goes back to the home page.
  final void Function()? onGoHome;

  /// Callback to go back to the previous page.
  final void Function()? onGoBack;

  @override
  State<StatefulWidget> createState() => _DrawingsPageState();
}

class _DrawingsPageState extends State<IllustrationsPage> with UiLoggy {
  /// True if the license panel should be expanded.
  bool _expandLicensePanel = false;

  /// True if there're more posts to fetch.
  bool _hasNext = true;

  /// Page state (e.g. idle, loading).
  EnumPageState _pageState = EnumPageState.idle;

  /// Accent color for border and title.
  Color _accentColor = Colors.blue;

  /// Last document fetched from Firestore.
  DocumentSnapshot? _lastDocument;

  /// Illustration page size.
  int _pageSize = 9;

  /// Illustration page size for large screens.
  final int _largePageSize = 9;

  /// Illustration page size for medium screens.
  final int _mediumPageSize = 6;

  /// Illustration page size for tiny screens.
  final int _smallPageSize = 4;

  /// Current page of the illustration list.
  int _currentPage = 0;

  /// Total page of the illustration list.
  int _totalPage = 0;

  /// List of illustrations.
  final List<Illustration> _illustrations = [];

  /// Listens to posts' updates.
  QuerySnapshotStreamSubscription? _illustrationSubscription;

  /// Firestore collection name.
  final String _collectionName = "illustrations";

  @override
  void initState() {
    super.initState();
    initProps();
    fetchIllustrations();
  }

  @override
  void dispose() {
    _illustrationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pageState == EnumPageState.loading) {
      return LoadingView.scaffold(
        message: "illustration.loading".tr(),
      );
    }

    final Size windowSize = MediaQuery.of(context).size;
    _pageSize = getPageSize(windowSize);

    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);

    final UserFirestore userFirestore = signalUserFirestore.value;
    final UserRights userRights = userFirestore.rights;
    final bool canManageIllustrations = userRights.manageIllustrations;

    if (_illustrations.isEmpty) {
      return IllustrationsPageEmpty(
        canCreate: canManageIllustrations,
        fab: IllustrationsPageFab(
          isVisible: canManageIllustrations,
          pickFiles: pickFiles,
        ),
        onShowCreatePage: pickFiles,
        onCancel: onCancel,
      );
    }

    final int startIndex = _currentPage * _pageSize;
    final int endIndex = min(_illustrations.length, startIndex + _pageSize);

    return IllustrationsPageBody(
      accentColor: _accentColor,
      hasNext: _hasNext,
      canManageIllustrations: canManageIllustrations,
      onNextPage: onNextPage,
      onGoBack: widget.onGoBack,
      onPreviousPage: onPreviousPage,
      currentPage: _currentPage,
      totalPage: _totalPage,
      illustrations: _illustrations.sublist(
        max(0, startIndex),
        min(_illustrations.length, endIndex),
      ),
      expandLicensePanel: _expandLicensePanel,
      onToggleExpandLicensePanel: onToggleExpandLicensePanel,
      fab: IllustrationsPageFab(
        isVisible: canManageIllustrations,
        pickFiles: pickFiles,
      ),
      onDeleteIllustration: tryDeleteIllustration,
      onTapIllustration: onTapIllustration,
      onGoToExternalLicense: onGoToExternalLicense,
      onTapAppIcon: widget.onGoHome,
      windowSize: windowSize,
    );
  }

  void fetchIllustrations() async {
    setState(() {
      _pageState = EnumPageState.loading;
      _hasNext = true;
      _illustrations.clear();
    });

    try {
      final QueryMap query = getFetchQuery();
      final QuerySnapMap snapshot = await query.get();
      listenIllustrationsEvents(getListenQuery());

      if (snapshot.docs.isEmpty) {
        setState(() {
          _pageState = EnumPageState.idle;
          _hasNext = false;
        });

        return;
      }

      for (final QueryDocSnapMap document in snapshot.docs) {
        final Json data = document.data();
        data["id"] = document.id;
        final Illustration illustration = Illustration.fromMap(data);
        _illustrations.add(illustration);
        fixEmptyThumbnail(illustration);
      }

      if (!mounted) return;
      setState(() {
        _pageState = EnumPageState.idle;
        _lastDocument = snapshot.docs.last;
        _hasNext = snapshot.docs.length == _pageSize;
        _totalPage = _illustrations.length ~/ _pageSize;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _pageState = EnumPageState.idle);
      loggy.error(error);
    }
  }

  /// Fetch more illustrations data from Firestore.
  void fetchMoreIllustrations() async {
    if (!_hasNext ||
        _lastDocument == null ||
        _pageState == EnumPageState.loadingMore) {
      setState(() {});
      return;
    }

    _pageState = EnumPageState.loadingMore;

    try {
      final QueryMap? query = getFetchMoreQuery();
      if (query == null) return;
      final QuerySnapMap snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _hasNext = false;
          _pageState = EnumPageState.idle;
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
        _hasNext = snapshot.docs.length == _pageSize;
        _pageState = EnumPageState.idle;
        _totalPage = _illustrations.length ~/ _pageSize;
      });

      listenIllustrationsEvents(getListenQuery());
    } catch (error) {
      loggy.error(error);
      setState(() => _pageState = EnumPageState.idle);
    }
  }

  /// Fix thumbnail issues for the illustration.
  void fixEmptyThumbnail(Illustration illustration) async {
    if (illustration.getThumbnail().isNotEmpty) {
      return;
    }

    loggy.info("Thumbnail for illustration ${illustration.id} is empty.");
    await IllustrationActions.fix(illustrationId: illustration.id);
  }

  /// Return query to fetch illustrations according to the selected tab.
  /// It's either active illustrations or archvied ones.
  QueryMap getFetchQuery() {
    final query = FirebaseFirestore.instance
        .collection(_collectionName)
        .where("visibility", isEqualTo: "public")
        .orderBy("user_custom_index", descending: true)
        .limit(_pageSize);

    if (_lastDocument == null) {
      return query;
    }

    return query.startAfterDocument(_lastDocument as DocumentSnapshot);
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
        .limit(_pageSize)
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

  void initProps() {
    _accentColor = Constants.colors.getRandomBackground();
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

  void pickFiles() {
    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);
    final String userId = signalUserFirestore.value.id;

    if (userId.isEmpty) return;
    Utils.state.illustrations.pickIllustrations(userId: userId);
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

  void onToggleExpandLicensePanel() {
    setState(() {
      _expandLicensePanel = !_expandLicensePanel;
    });
  }

  void onGoToExternalLicense() {
    launchUrl(Uri.parse("https://creativecommons.org/licenses/by-sa/4.0"));
  }

  void onNextPage() {
    final int nextPage = _currentPage + 1;
    _currentPage = _hasNext ? nextPage : min(_totalPage, nextPage);
    fetchMoreIllustrations();
  }

  void onPreviousPage() {
    setState(() {
      _currentPage = max(0, _currentPage - 1);
    });
  }

  int getPageSize(Size windowSize) {
    if (windowSize.width < 400.0 || windowSize.height < 400.0) {
      return _smallPageSize;
    }

    if (windowSize.width < 900.0 || windowSize.height < 600.0) {
      return _mediumPageSize;
    }

    return _largePageSize;
  }
}
