import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
import 'package:lottie/lottie.dart';
import 'package:rootasjey/components/buttons/fab_to_top.dart';
import 'package:rootasjey/components/dialogs/delete_dialog.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/upload_panel/upload_panel.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/post/post_app_bar.dart';
import 'package:rootasjey/screens/post/post_cover.dart';
import 'package:rootasjey/screens/post/post_footer.dart';
import 'package:rootasjey/screens/post/post_page_body.dart';
import 'package:rootasjey/screens/post/post_page_header.dart';
import 'package:rootasjey/screens/post/post_settings.dart';
import 'package:rootasjey/types/alias/firestore/doc_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/firestore/document_map.dart';
import 'package:rootasjey/types/alias/firestore/document_snapshot_map.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_content_visibility.dart';
import 'package:rootasjey/types/enums/enum_cover_corner.dart';
import 'package:rootasjey/types/enums/enum_cover_width.dart';
import 'package:rootasjey/types/enums/enum_signal_id.dart';
import 'package:rootasjey/types/enums/enum_upload_type.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/types/user/user_rights.dart';
import 'package:verbal_expressions/verbal_expressions.dart';

class PostPage extends StatefulWidget {
  const PostPage({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with UiLoggy {
  /// True if the post is loading.
  bool _loading = false;

  /// True if we're trying to save the post.
  bool _saving = false;

  /// True if we're trying to delete the post.
  bool _deleting = false;

  bool _showAddTag = false;

  bool _hideFab = true;
  bool _showAppBarTitle = false;

  bool _showSettings = false;

  bool _confirmDeletePost = false;

  bool _editing = false;

  /// Last saved offset.
  /// Useful to determinate the scroll direction.
  double _prevOffset = 0.0;

  /// Page's post. Main data.
  Post _post = Post.empty();

  final RegExp _wordsRegex = RegExp(r"[\w-._]+");

  /// Page scroll controller.
  final ScrollController _pageScrollController = ScrollController();

  /// Page scroll direction.
  /// Show or hide widget according to direction (e.g. FAB).
  ScrollDirection _scrollDirection = ScrollDirection.idle;

  /// Post's document subcription.
  /// We use this stream to listen to document fields updates.
  DocSnapshotStreamSubscription? _postSubscription;

  /// Post's content as String.
  String _content = "";

  /// Firestore collection name.
  final String _collectionName = "posts";

  /// Input controller for post's title (metadata).
  final TextEditingController _nameController = TextEditingController();

  /// Input controller for post's summary (metadata).
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
    _postSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);

    final UserRights rights = signalUserFirestore.value.rights;

    final bool canManagePosts = rights.managePosts;
    const double maxWidth = 640.0;
    final Size windowSize = MediaQuery.of(context).size;
    final bool isMobileSize =
        windowSize.width < Utilities.size.mobileWidthTreshold;

    if (_deleting) {
      return LoadingView.scaffold(
        message: "Deleting ${_post.name}...",
      );
    }

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
                  textTitle: _post.name,
                  showSettings: _showSettings,
                  onTapSettings: canManagePosts ? onTapSettings : null,
                  onTapTitle: onTapTitle,
                ),
                PostSettings(
                  confirmDelete: _confirmDeletePost,
                  cover: _post.cover,
                  hasCover: _post.cover.storagePath.isNotEmpty,
                  isMobileSize: isMobileSize,
                  language: _post.language,
                  onCancelDeletePost: onCancelDeletePost,
                  onLanguageChanged: tryUpdateLanguage,
                  onCloseSetting: onCloseSetting,
                  onConfirmDeletePost: onConfirmDeletePost,
                  onCoverWidthTypeSelected: tryUpdateCoverWidthType,
                  onCoverCornerTypeSelected: tryUpdateCoverCornerType,
                  onTryDeletePost: tryDeletePost,
                  onTryAddCoverImage: tryUploadCover,
                  onVisibilitySelected: tryUpdatePostVisibility,
                  onTryRemoveCoverImage: tryRemoveCoverImage,
                  show: _showSettings,
                  visibility: _post.visibility,
                ),
                PostPageHeader(
                  showAddTag: _showAddTag,
                  canManagePosts: canManagePosts,
                  createdAt: _post.createdAt,
                  documentId: _post.id,
                  summary: _post.summary,
                  summaryController: _summaryController,
                  language: _post.language,
                  tags: _post.tags,
                  publishedAt: _post.createdAt,
                  isMobileSize: isMobileSize,
                  name: _post.name,
                  onNameChanged: onNameChanged,
                  nameController: _nameController,
                  userId: _post.userId,
                  updatedAt: _post.updatedAt,
                  visibility: _post.visibility,
                  onToggleAddTagVisibility: onToggleAddTagVisibility,
                  tagInputController: _tagInputController,
                  onInputTagChanged: onInputTagChanged,
                  onRemoveTag: onRemoveTag,
                ),
                PostCover(
                  cover: _post.cover,
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
                ),
                PostFooter(
                  maxWidth: maxWidth,
                  show: canManagePosts,
                  wordCount: _post.wordCount,
                  updatedAt: _post.updatedAt,
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
      fabEdit();
    }

    return FabToTop(
      hideIfAtTop: _hideFab,
      fabIcon: const Icon(TablerIcons.arrow_up),
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
      icon:
          _editing ? const Icon(TablerIcons.eye) : const Icon(TablerIcons.edit),
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
          titleValue: "Delete this post?",
          onValidate: tryDeletePost,
        );
      },
    );
  }

  Future<void> fetchContent() async {
    try {
      final Reference fileStorage = FirebaseStorage.instance
          .ref()
          .child("$_collectionName/${widget.postId}/post.md");

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
          .collection(_collectionName)
          .doc(widget.postId);

      listenToDocument(query);

      final DocumentSnapshotMap snapshot = await query.get();
      final Json? map = snapshot.data();

      if (!snapshot.exists || map == null) {
        loggy.error("Post ${snapshot.id} does not seem to exist;");
        return;
      }

      setState(() {
        map["id"] = snapshot.id;
        _post = Post.fromMap(map);
        _summaryController.text = _post.summary;
        _nameController.text = _post.name;
      });

      if (_post.storagePath.isNotEmpty) {
        fetchContent();
      }
    } on Exception catch (error) {
      loggy.error(error);
    }

    setState(() => _loading = false);
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
    _postSubscription?.cancel();
    _postSubscription = query.snapshots().skip(1).listen((snapshot) {
      if (!snapshot.exists) {
        _postSubscription?.cancel();
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
        _post = Post.fromMap(data);

        if (_loading && _post.storagePath.isNotEmpty) {
          _loading = false;
        }
      });
    }, onError: (error) {
      loggy.error(error);
    }, onDone: () {
      _postSubscription?.cancel();
    });
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
    updateScrollDirection(offset);
    handleAppBarTitleVisibility(offset);
    handleFabVisibility(offset);
  }

  void onNameChanged(String? value) {
    _metadataUpdateTimer?.cancel();
    _metadataUpdateTimer = Timer(
      const Duration(seconds: 1),
      tryUpdatePostName,
    );
  }

  void onTapTitle() {
    _pageScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.bounceIn,
    );
  }

  /// Cancel delete confirmation about this post.
  void onCancelDeletePost() {
    setState(() => _confirmDeletePost = false);
  }

  /// Hide settings panel.
  void onCloseSetting() {
    setState(() => _showSettings = false);
  }

  void onContentChanged(String content) {
    _content = content;

    _contentUpdateTimer?.cancel();
    _contentUpdateTimer = Timer(
      const Duration(seconds: 1),
      trySaveContent,
    );
  }

  /// Show delete confirmation UI.
  void onConfirmDeletePost() {
    setState(() => _confirmDeletePost = true);
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

  void onRemoveTag(String tag) async {
    final List<String> initialTags = _post.tags;

    _post = _post.copyWith(
      tags: _post.tags..remove(tag),
    );

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_post.id)
          .update({
        "tags": _post.listToMapStringBool(),
      });
    } catch (error) {
      loggy.error(error);
      _post = _post.copyWith(tags: initialTags);
    }
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

  void onToggleAddTagVisibility() {
    setState(() => _showAddTag = !_showAddTag);
  }

  void tryDeletePost() async {
    setState((() => _deleting = true));

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(widget.postId)
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

  /// Remove post's cover image and delete storage objects.
  void tryRemoveCoverImage() async {
    final String prevStoragePath = _post.storagePath;

    setState(() {
      _post = _post.copyWith(
          cover: _post.cover.copyWith(
        storagePath: "",
      ));
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_post.id)
          .update({
        "cover.storage_path": "",
      });
    } catch (error) {
      loggy.error(error);
      setState(() {
        _post = _post.copyWith(
            cover: _post.cover.copyWith(
          storagePath: prevStoragePath,
        ));
      });
    }
  }

  /// Save post's content.
  Future<void> trySaveContent() async {
    final Iterable<RegExpMatch> wordMatches = _wordsRegex.allMatches(_content);

    // Optimistic update
    _post = _post.copyWith(
      characterCount: _content.length,
      wordCount: wordMatches.length,
    );

    setState(() => _saving = true);

    try {
      final Reference fileStorage = FirebaseStorage.instance.ref().child(
            _post.storagePath,
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
    final String prevLanguage = _post.language;
    setState(() {
      _saving = true;
      _post = _post.copyWith(language: newLanguage);
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_post.id)
          .update({
        "language": newLanguage,
      });
    } catch (error) {
      loggy.error(error);

      _post = _post.copyWith(language: prevLanguage);
    } finally {
      setState(() => _saving = false);
    }
  }

  void tryUpdatePostName() async {
    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_post.id)
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

  void tryUploadCover() async {
    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);
    final String userId = signalUserFirestore.value.id;
    if (userId.isEmpty) return;

    Utils.state.illustrations.pickCover(
      targetId: _post.id,
      uploadType: EnumUploadType.postCover,
      userId: userId,
    );
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
      _post = _post.copyWith(
        cover: _post.cover.copyWith(
          widthType: coverWidthType,
        ),
      );
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_post.id)
          .update({
        "cover.width_type": coverWidthType.name,
      });
    } catch (error) {
      loggy.error(error);
      _post = _post.copyWith(
        cover: _post.cover.copyWith(
          widthType: prevWidthType,
        ),
      );
    } finally {
      setState(() => _saving = false);
    }
  }

  void tryUpdatePostVisibility(
    EnumContentVisibility visibility,
    bool selected,
  ) async {
    if (!selected) {
      return;
    }

    setState(() {
      _saving = true;
      _post = _post.copyWith(
        visibility: visibility,
      );
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_post.id)
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
    final List<String> initialTags = _post.tags;

    _post = _post.copyWith(
      tags: _post.tags..add(tag),
    );

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_post.id)
          .update({
        "tags": _post.listToMapStringBool(),
      });
    } catch (error) {
      loggy.error(error);
      _post = _post.copyWith(tags: initialTags);
    }
  }

  /// Update cover corners.
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
      _post = _post.copyWith(
        cover: _post.cover.copyWith(
          cornerType: coverCornerType,
        ),
      );
    });

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_post.id)
          .update({
        "cover.corner_type": coverCornerType.name,
      });
    } catch (error) {
      loggy.error(error);
      _post = _post.copyWith(
        cover: _post.cover.copyWith(
          cornerType: prevCornerType,
        ),
      );
    } finally {
      setState(() => _saving = false);
    }
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
}
