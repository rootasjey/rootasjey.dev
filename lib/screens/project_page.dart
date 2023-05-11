import 'dart:async';
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:lottie/lottie.dart';
import 'package:rootasjey/components/buttons/fab_to_top.dart';
import 'package:rootasjey/components/dialogs/delete_dialog.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/upload_panel/upload_panel.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/screens/post/post_app_bar.dart';
import 'package:rootasjey/screens/post/post_cover.dart';
import 'package:rootasjey/screens/post/post_footer.dart';
import 'package:rootasjey/screens/post/post_page_body.dart';
import 'package:rootasjey/screens/post/post_page_header.dart';
import 'package:rootasjey/screens/post/post_settings.dart';
import 'package:rootasjey/types/alias/firestore/document_map.dart';
import 'package:rootasjey/types/alias/firestore/document_snapshot_map.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_content_visibility.dart';
import 'package:rootasjey/types/enums/enum_cover_corner.dart';
import 'package:rootasjey/types/enums/enum_cover_width.dart';
import 'package:rootasjey/types/enums/enum_upload_type.dart';
import 'package:rootasjey/types/project/project.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/types/user/user_rights.dart';
import 'package:unicons/unicons.dart';
import 'package:verbal_expressions/verbal_expressions.dart';

class ProjectPage extends ConsumerStatefulWidget {
  const ProjectPage({
    super.key,
    required this.projectId,
  });

  final String projectId;

  @override
  ConsumerState<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends ConsumerState<ProjectPage> with UiLoggy {
  /// True if the project is loading.
  bool _loading = false;

  /// True if we're trying to save the project.
  bool _saving = false;

  /// True if we're trying to delete the project.
  bool _deleting = false;

  /// Display add tag component.
  bool _showAddTag = false;

  /// True if we're hiding the Floating Action Button.
  bool _hideFab = true;

  /// True if we're showing the app bar title.
  bool _showAppBarTitle = false;

  /// True if we're showing the settings.
  bool _showSettings = false;

  bool _confirmDeletePost = false;

  /// True if we can edit the post.
  bool _editing = false;

  /// Last saved offset.
  /// Useful to determinate the scroll direction.
  double _prevOffset = 0.0;

  /// Icon size.
  double copyIconSize = 24.0;

  /// Copy icon component
  /// (switch temporaryly to a check mark when tapped).
  Icon copyIcon = const Icon(UniconsLine.copy, size: 24.0);

  /// Page project.
  Project _project = Project.empty();

  /// Regex to detect and count words.
  final RegExp _wordsRegex = RegExp(r"[\w-._]+");

  /// Page scroll controller.
  final ScrollController _pageScrollController = ScrollController();

  /// Page scroll direction.
  /// Show or hide widget according to direction (e.g. FAB).
  ScrollDirection _scrollDirection = ScrollDirection.idle;

  /// Post's document subcription.
  /// We use this stream to listen to document fields updates.
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _projectSubscription;

  /// Post's content as String.
  String _content = "";

  /// Firestore collection name.
  final String _collectionName = "projects";

  /// Input controller for project's title (metadata).
  final TextEditingController _nameController = TextEditingController();

  /// Input controller for project's summary (metadata).
  final TextEditingController _summaryController = TextEditingController();

  /// Input controller for project's tags (metadata).
  final TextEditingController _tagInputController = TextEditingController();

  /// Controller for post content.
  final TextEditingController _contentController = TextEditingController();

  /// Used to add delay to post's metadata update.
  Timer? _metadataUpdateTimer;

  /// Used to add delay to post's content update.
  Timer? _contentUpdateTimer;

  /// Regex to detect spaces between words.
  final VerbalExpression _verbalSpaceExp = VerbalExpression()..space();

  @override
  void initState() {
    super.initState();
    fetchMetadata();
  }

  @override
  void dispose() {
    _metadataUpdateTimer?.cancel();
    _contentUpdateTimer?.cancel();
    _nameController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _projectSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserFirestore? userFirestore =
        ref.watch(AppState.userProvider).firestoreUser;

    final UserRights rights = userFirestore?.rights ?? const UserRights();

    final bool canManagePosts = rights.managePosts;
    final Size windowSize = MediaQuery.of(context).size;
    final bool isMobileSize =
        windowSize.width < Utilities.size.mobileWidthTreshold;

    if (_deleting) {
      return LoadingView.scaffold(
        message: "Deleting ${_project.name}...",
      );
    }

    const double maxWidth = 640.0;

    return Scaffold(
      floatingActionButton: fab(canEdit: canManagePosts),
      body: Stack(
        children: [
          ImprovedScrolling(
            scrollController: _pageScrollController,
            onScroll: onScroll,
            child: CustomScrollView(
              controller: _pageScrollController,
              slivers: [
                PostAppBar(
                  showTitle: _showAppBarTitle,
                  textTitle: _project.name,
                  showSettings: _showSettings,
                  onTapSettings: canManagePosts ? onTapSettings : null,
                  onTapTitle: onTapTitle,
                ),
                PostSettings(
                  confirmDelete: _confirmDeletePost,
                  cover: _project.cover,
                  hasCover: _project.cover.storagePath.isNotEmpty,
                  isMobileSize: isMobileSize,
                  language: _project.language,
                  onCancelDeletePost: onCancelDeletePost,
                  onLanguageChanged: tryUpdateLanguage,
                  onCloseSetting: onCloseSetting,
                  onConfirmDeletePost: onConfirmDeletePost,
                  onCoverWidthTypeSelected: tryUpdateCoverWidthType,
                  onCoverCornerTypeSelected: tryUpdateCoverCornerType,
                  onTryDeletePost: tryDeleteProject,
                  onTryAddCoverImage: tryUploadCover,
                  onVisibilitySelected: tryUpdateProjectVisibility,
                  onTryRemoveCoverImage: tryRemoveCoverImage,
                  show: _showSettings,
                  visibility: _project.visibility,
                ),
                PostPageHeader(
                  showAddTag: _showAddTag,
                  canManagePosts: canManagePosts,
                  createdAt: _project.createdAt,
                  documentId: _project.id,
                  summary: _project.summary,
                  summaryController: _summaryController,
                  language: _project.language,
                  tags: _project.tags,
                  publishedAt: _project.createdAt,
                  isMobileSize: isMobileSize,
                  name: _project.name,
                  onNameChanged: onNameChanged,
                  nameController: _nameController,
                  userId: _project.userId,
                  updatedAt: _project.updatedAt,
                  visibility: _project.visibility,
                  onToggleAddTagVisibility: onToggleAddTagVisibility,
                  tagInputController: _tagInputController,
                  onInputTagChanged: onInputTagChanged,
                  onRemoveTag: onRemoveTag,
                ),
                PostCover(
                  cover: _project.cover,
                  isMobileSize: isMobileSize,
                  onTryAddCoverImage: tryUploadCover,
                  onTryRemoveCoverImage: tryRemoveCoverImage,
                  showControlButtons: canManagePosts,
                  windowSize: windowSize,
                ),
                PostPageBody(
                  canManagePosts: canManagePosts,
                  content: _content,
                  isMobileSize: isMobileSize,
                  loading: _loading,
                  maxWidth: maxWidth,
                  editing: _editing,
                  editingController: _contentController,
                  onContentChanged: onContentChanged,
                  copyIcon: copyIcon,
                  onCopy: onCopy,
                ),
                PostFooter(
                  maxWidth: maxWidth,
                  show: canManagePosts,
                  wordCount: _project.wordCount,
                  updatedAt: _project.updatedAt,
                ),
              ],
            ),
          ),
          if (_saving)
            Positioned(
              bottom: 40.0,
              left: 40.0,
              child: Material(
                elevation: 6.0,
                borderRadius: BorderRadius.circular(28.0),
                color: const Color(0xffeeeeee),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 200.0,
                  ),
                  child: Row(
                    children: [
                      Lottie.asset(
                        "assets/animations/dots.json",
                        repeat: true,
                        width: 100.0,
                        height: 60.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          "updating".tr(),
                          overflow: TextOverflow.ellipsis,
                          style: Utilities.fonts.body(
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            left: isMobileSize ? 0.0 : 16.0,
            bottom: isMobileSize ? 0.0 : 16.0,
            child: const UploadPanel(),
          ),
        ],
      ),
    );
  }

  Widget fab({bool canEdit = false}) {
    if (canEdit) {
      return fabEdit();
    }

    return FabToTop(
      hideIfAtTop: _hideFab,
      fabIcon: const Icon(UniconsLine.arrow_up),
      pageScrollController: _pageScrollController,
    );
  }

  Widget fabEdit() {
    if (_scrollDirection == ScrollDirection.forward) {
      return Container();
    }

    return FloatingActionButton.extended(
      onPressed: () {
        setState(() => _editing = !_editing);
      },
      extendedPadding: const EdgeInsets.symmetric(
        horizontal: 32.0,
      ),
      foregroundColor: Colors.white,
      backgroundColor: Colors.pink,
      label: Text(
        _editing ? "render" : "edit".tr(),
        style: Utilities.fonts.body(
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      icon: _editing
          ? const Icon(UniconsLine.eye)
          : const Icon(UniconsLine.edit_alt),
    );
  }

  void contentListener() {
    _contentUpdateTimer?.cancel();
    _contentUpdateTimer = Timer(
      const Duration(seconds: 1),
      trySaveContent,
    );
  }

  void confirmDeletePost() {
    Utilities.ui.showAdaptiveDialog(
      context,
      builder: (BuildContext context) {
        return DeleteDialog(
          descriptionValue: "This action is irreversible",
          titleValue: "Delete this project?",
          onValidate: tryDeleteProject,
        );
      },
    );
  }

  Future<void> fetchContent() async {
    try {
      final Reference fileStorage = FirebaseStorage.instance
          .ref()
          .child("$_collectionName/${widget.projectId}/post.md");

      final Uint8List? data = await fileStorage.getData();

      if (data == null) {
        _content = "Start typing here...";
        return;
      }

      _content = utf8.decode(data, allowMalformed: true);

      if (_content.isEmpty) {
        _content = "Start typing here...";
      }

      setState(() {
        _contentController.text = _content;
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  Future<void> fetchMetadata() async {
    setState(() => _loading = true);

    try {
      final DocumentMap query = FirebaseFirestore.instance
          .collection("projects")
          .doc(widget.projectId);

      listenToDocument(query);

      final DocumentSnapshotMap snapshot = await query.get();
      final Json? map = snapshot.data();

      if (!snapshot.exists || map == null) {
        loggy.error("Project ${snapshot.id} does not seem to exist;");
        return;
      }

      setState(() {
        map["id"] = snapshot.id;
        _project = Project.fromMap(map);
        _summaryController.text = _project.summary;
        _nameController.text = _project.name;
      });

      if (_project.storagePath.isNotEmpty) {
        fetchContent();
      }
    } on Exception catch (error) {
      loggy.error(error);
    }

    setState(() => _loading = false);
  }

  /// Show or hide app bar title based on the scroll Y offset.
  void handleAppBarTitleVisibility(double offset) {
    if (offset <= 60) {
      if (!_showAppBarTitle) {
        return;
      }

      setState(() {
        _showAppBarTitle = false;
      });

      return;
    }

    if (_showAppBarTitle) {
      return;
    }

    setState(() {
      _showAppBarTitle = true;
    });
  }

  /// Show or hide the floating action button based on the scroll Y offset.
  void handleFabVisibility(double offset) {
    if (_editing) {
      return;
    }

    if (offset <= 60) {
      if (_hideFab) {
        return;
      }

      setState(() => _hideFab = true);
      return;
    }

    if (!_hideFab) {
      return;
    }

    setState(() => _hideFab = false);
  }

  void listenToDocument(DocumentReference<Map<String, dynamic>> query) {
    _projectSubscription?.cancel();
    _projectSubscription = query.snapshots().skip(1).listen((snapshot) {
      if (!snapshot.exists) {
        _projectSubscription?.cancel();
        return;
      }

      final Json? data = snapshot.data();
      if (data == null) {
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        data["id"] = snapshot.id;
        _project = Project.fromMap(data);

        if (_loading && _project.storagePath.isNotEmpty) {
          _loading = false;
        }
      });
    }, onError: (error) {
      loggy.error(error);
    }, onDone: () {
      _projectSubscription?.cancel();
    });
  }

  /// Cancel delete confirmation about this project.
  void onCancelDeletePost() {
    setState(() => _confirmDeletePost = false);
  }

  /// Hide settings panel.
  void onCloseSetting() {
    setState(() => _showSettings = false);
  }

  /// Show delete confirmation UI.
  void onConfirmDeletePost() {
    setState(() => _confirmDeletePost = true);
  }

  void onContentChanged(String content) {
    _content = content;

    _contentUpdateTimer?.cancel();
    _contentUpdateTimer = Timer(
      const Duration(seconds: 1),
      trySaveContent,
    );
  }

  void onInputTagChanged(String tag) {
    String editedTag = tag;

    if (tag.contains(",") || tag.contains(";")) {
      editedTag = tag.replaceAll(",", "").replaceAll(";", "").trim();

      if (editedTag.isEmpty) {
        return;
      }

      _tagInputController.clear();
      tryUpdateTags(editedTag);
    }

    if (_verbalSpaceExp.hasMatch(tag)) {
      editedTag = tag.trim();

      _tagInputController.clear();
      tryUpdateTags(editedTag);
    }
  }

  void onNameChanged(String? value) {
    _metadataUpdateTimer?.cancel();
    _metadataUpdateTimer = Timer(
      const Duration(seconds: 1),
      tryUpdateProjectName,
    );
  }

  void onRemoveTag(String tag) async {
    final List<String> initialTags = _project.tags;

    _project = _project.copyWith(
      tags: _project.tags..remove(tag),
    );

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "tags": _project.listToMapStringBool(),
      });
    } catch (error) {
      loggy.error(error);
      _project = _project.copyWith(tags: initialTags);
    }
  }

  /// React to scroll events.
  void onScroll(double offset) {
    updateScrollDirection(offset);
    handleAppBarTitleVisibility(offset);
    handleFabVisibility(offset);
  }

  void onTapSettings() {
    if (!_showSettings) {
      _pageScrollController.animateTo(
        0.0,
        curve: Curves.decelerate,
        duration: const Duration(
          milliseconds: 250,
        ),
      );
    }

    setState(() => _showSettings = !_showSettings);
  }

  void onTapTitle() {
    _pageScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.bounceIn,
    );
  }

  void onToggleAddTagVisibility() {
    setState(() => _showAddTag = !_showAddTag);
  }

  void tryDeleteProject() async {
    setState((() => _deleting = true));

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(widget.projectId)
          .delete();

      if (!mounted) {
        return;
      }

      Beamer.of(context).beamBack();
    } catch (error) {
      loggy.error(error);
    } finally {
      setState(() => _deleting = false);
    }
  }

  /// Remove project's cover image and delete storage objects.
  void tryRemoveCoverImage() async {
    final String prevStoragePath = _project.storagePath;

    setState(() {
      _project = _project.copyWith(
          cover: _project.cover.copyWith(
        storagePath: "",
      ));
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "cover.storage_path": "",
      });
    } catch (error) {
      loggy.error(error);
      setState(() {
        _project = _project.copyWith(
            cover: _project.cover.copyWith(
          storagePath: prevStoragePath,
        ));
      });
    }
  }

  /// Save project's content.
  Future<void> trySaveContent() async {
    final Iterable<RegExpMatch> wordMatches = _wordsRegex.allMatches(_content);

    // Optimistic update
    _project = _project.copyWith(
      characterCount: _content.length,
      wordCount: wordMatches.length,
    );

    setState(() => _saving = true);

    try {
      final Reference fileStorage = FirebaseStorage.instance.ref().child(
            _project.storagePath,
          );

      final FullMetadata metadata = await fileStorage.getMetadata();
      final Map<String, String>? customMetadata = metadata.customMetadata;

      if (customMetadata != null) {
        customMetadata
          ..update(
            "character_count",
            (String prevLength) => "${_content.length}",
            ifAbsent: () => "${_content.length}",
          )
          ..update(
            "word_count",
            (String prevLength) => "${wordMatches.length}",
            ifAbsent: () => "${wordMatches.length}",
          );
      }

      await fileStorage.putString(
        _content,
        metadata: SettableMetadata(
          cacheControl: metadata.cacheControl,
          contentDisposition: metadata.contentDisposition,
          contentEncoding: metadata.contentEncoding,
          contentLanguage: metadata.contentLanguage,
          contentType: "text/markdown; charset=UTF-8",
          // contentType: "application/json; charset=UTF-8",
          customMetadata: customMetadata,
        ),
      );
    } catch (error) {
      loggy.error(error);
    } finally {
      setState(() => _saving = false);
    }
  }

  /// Update cover's width.
  void tryUpdateCoverWidthType(
    EnumCoverWidth coverWidthType,
    bool selected,
  ) async {
    if (!selected) {
      loggy.info("visibility: ${coverWidthType.name} | selected: $selected");
      return;
    }

    final EnumCoverWidth prevWidthType = coverWidthType;

    setState(() {
      _saving = true;
      _project = _project.copyWith(
        cover: _project.cover.copyWith(
          widthType: coverWidthType,
        ),
      );
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "cover.width_type": coverWidthType.name,
      });
    } catch (error) {
      loggy.error(error);
      _project = _project.copyWith(
        cover: _project.cover.copyWith(
          widthType: prevWidthType,
        ),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  /// Update cover corners;
  void tryUpdateCoverCornerType(
    EnumCoverCorner coverCornerType,
    bool selected,
  ) async {
    if (!selected) {
      loggy.info("visibility: ${coverCornerType.name} | selected: $selected");
      return;
    }

    final EnumCoverCorner prevCornerType = coverCornerType;

    setState(() {
      _saving = true;
      _project = _project.copyWith(
        cover: _project.cover.copyWith(
          cornerType: coverCornerType,
        ),
      );
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "cover.corner_type": coverCornerType.name,
      });
    } catch (error) {
      loggy.error(error);
      _project = _project.copyWith(
        cover: _project.cover.copyWith(
          cornerType: prevCornerType,
        ),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  void tryUpdateLanguage(String newLanguage) async {
    final String prevLanguage = _project.language;
    setState(() {
      _saving = true;
      _project = _project.copyWith(language: newLanguage);
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "language": newLanguage,
      });
    } catch (error) {
      loggy.error(error);

      _project = _project.copyWith(language: prevLanguage);
    } finally {
      setState(() => _saving = false);
    }
  }

  void tryUpdateProjectName() async {
    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "name": _nameController.text,
        "summary": _summaryController.text,
      });
    } catch (error) {
      loggy.error(error);
    } finally {
      setState(() => _saving = false);
    }
  }

  void tryUpdateProjectVisibility(
    EnumContentVisibility visibility,
    bool selected,
  ) async {
    if (!selected) {
      return;
    }

    setState(() {
      _saving = true;
      _project = _project.copyWith(
        visibility: visibility,
      );
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "visibility": visibility.name,
      });
    } catch (error) {
      loggy.error(error);
    } finally {
      setState(() => _saving = false);
    }
  }

  void tryUpdateTags(String tag) async {
    final List<String> initialTags = _project.tags;

    _project = _project.copyWith(
      tags: _project.tags..add(tag),
    );

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "tags": _project.listToMapStringBool(),
      });
    } catch (error) {
      loggy.error(error);
      _project = _project.copyWith(tags: initialTags);
    }
  }

  void tryUploadCover() async {
    final String userId =
        ref.read(AppState.userProvider).firestoreUser?.id ?? "";
    if (userId.isEmpty) {
      return;
    }

    ref.read(AppState.uploadTaskListProvider.notifier).pickCover(
          targetId: _project.id,
          uploadType: EnumUploadType.projectCover,
          userId: userId,
        );
  }

  void updateScrollDirection(double offset) {
    final bool atEdge = _pageScrollController.position.atEdge;
    final bool forwarding = _prevOffset < offset;

    ScrollDirection newScrollDirection = ScrollDirection.forward;

    if (forwarding) {
      newScrollDirection = ScrollDirection.forward;
    }

    if (!forwarding && !_pageScrollController.position.outOfRange) {
      newScrollDirection = ScrollDirection.reverse;
    }

    if (atEdge && offset == 0.0) {
      newScrollDirection = ScrollDirection.idle;
    }

    if (atEdge && offset > 0.0) {
      newScrollDirection = ScrollDirection.forward;
    }

    if (offset < 0.0) {
      newScrollDirection = ScrollDirection.reverse;
    }

    _prevOffset = offset;

    if (_scrollDirection != newScrollDirection) {
      setState(() {
        _scrollDirection = newScrollDirection;
      });
    }
  }

  void onCopy(String code) {
    Clipboard.setData(ClipboardData(text: code));
    setState(() {
      copyIcon = Icon(UniconsLine.check, size: copyIconSize);
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        copyIcon = Icon(UniconsLine.copy, size: copyIconSize);
      });
    });
  }
}
