import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
import 'package:rootasjey/types/project.dart';
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

  bool _showAddTag = false;

  bool _hideFab = true;
  bool _showAppBarTitle = false;

  bool _showSettings = false;

  bool _confirmDeletePost = false;

  bool _editing = false;

  /// Post's content as String.
  String _content = "";

  /// Firestore collection name.
  final String _collectionName = "projects";

  /// Page project.
  Project _project = Project.empty();

  final RegExp _wordsRegex = RegExp(r"[\w-._]+");

  /// Page scroll controller.
  final ScrollController _pageScrollController = ScrollController();

  /// Post's document subcription.
  /// We use this stream to listen to document fields updates.
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _projectSubscription;

  /// Input controller for project's title (metadata).
  final TextEditingController _nameController = TextEditingController();

  /// Input controller for project's summary (metadata).
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _tagInputController = TextEditingController();

  /// Controller for post content.
  final TextEditingController _contentController = TextEditingController();

  /// Used to add delay to post's metadata update.
  Timer? _metadataUpdateTimer;

  /// Used to add delay to post's content update.
  Timer? _contentUpdateTimer;

  final VerbalExpression _verbalExp = VerbalExpression()..space();

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
    final bool isMobileSize = Utilities.size.isMobileSize(context);

    if (_deleting) {
      return LoadingView.scaffold(
        message: "Deleting ${_project.name}...",
      );
    }

    const double maxWidth = 640.0;

    return Scaffold(
      floatingActionButton: fab(show: canManagePosts),
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
                ),
                PostSettings(
                  confirmDelete: _confirmDeletePost,
                  cover: _project.cover,
                  hasCover: _project.cover.storagePath.isNotEmpty,
                  language: _project.language,
                  onCancelDeletePost: onCancelDeletePost,
                  onLanguageChanged: tryUpdateLanguage,
                  onCloseSetting: onCloseSetting,
                  onConfirmDeletePost: onConfirmDeletePost,
                  onCoverWidthTypeSelected: tryUpdateCoverWithType,
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
                  showControlButtons: canManagePosts,
                  cover: _project.cover,
                  onTryAddCoverImage: tryUploadCover,
                  onTryRemoveCoverImage: tryRemoveCoverImage,
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

  Future<void> fetchContent() async {
    try {
      final Reference fileStorage = FirebaseStorage.instance
          .ref()
          .child("projects/${widget.projectId}/post.md");

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

  void onNameChanged(String? value) {
    _metadataUpdateTimer?.cancel();
    _metadataUpdateTimer = Timer(
      const Duration(seconds: 1),
      tryUpdateProjectName,
    );
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

  void tryUploadCover() async {
    ref
        .read(AppState.uploadTaskListProvider.notifier)
        .pickImage(targetId: _project.id);
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

  /// React to scroll events.
  void onScroll(double offset) {
    handleAppBarTitleVisibility(offset);
    handleFabVisibility(offset);
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

  void onToggleAddTagVisibility() {
    setState(() => _showAddTag = !_showAddTag);
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

    if (_verbalExp.hasMatch(tag)) {
      editedTag = tag.trim();

      _tagInputController.clear();
      tryUpdateTags(editedTag);
    }
  }

  void tryUpdateTags(String tag) async {
    final List<String> initialTags = _project.tags;

    _project = _project.copyWith(
      tags: _project.tags..add(tag),
    );

    try {
      await FirebaseFirestore.instance
          .collection("projects")
          .doc(_project.id)
          .update({
        "tags": _project.listToMapStringBool(),
      });
    } catch (error) {
      loggy.error(error);
      _project = _project.copyWith(tags: initialTags);
    }
  }

  void onRemoveTag(String tag) async {
    final List<String> initialTags = _project.tags;

    _project = _project.copyWith(
      tags: _project.tags..remove(tag),
    );

    try {
      await FirebaseFirestore.instance
          .collection("projects")
          .doc(_project.id)
          .update({
        "tags": _project.listToMapStringBool(),
      });
    } catch (error) {
      loggy.error(error);
      _project = _project.copyWith(tags: initialTags);
    }
  }

  /// Hide settings panel.
  void onCloseSetting() {
    setState(() => _showSettings = false);
  }

  /// Show delete confirmation UI.
  void onConfirmDeletePost() {
    setState(() => _confirmDeletePost = true);
  }

  /// Cancel delete confirmation about this project.
  void onCancelDeletePost() {
    setState(() => _confirmDeletePost = false);
  }

  /// Update cover's width.
  void tryUpdateCoverWithType(
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

  void onContentChanged(String content) {
    _content = content;

    _contentUpdateTimer?.cancel();
    _contentUpdateTimer = Timer(
      const Duration(seconds: 1),
      trySaveContent,
    );
  }

  Widget fab({required bool show}) {
    if (show) {
      FloatingActionButton.extended(
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

    return FabToTop(
      hideIfAtTop: _hideFab,
      fabIcon: const Icon(UniconsLine.arrow_up),
      pageScrollController: _pageScrollController,
    );
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
}
