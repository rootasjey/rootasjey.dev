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
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/buttons/fab_to_top.dart';
import 'package:rootasjey/components/dialogs/delete_dialog.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/upload_panel/upload_panel.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/home_location.dart';
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
import 'package:simple_animations/simple_animations.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';
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

class _ProjectPageState extends ConsumerState<ProjectPage>
    with UiLoggy, AnimationMixin {
  late Animation<double> angle;

  /// True if the project is loading.
  bool _loading = false;

  /// True if we're trying to save the project.
  bool _saving = false;

  /// True if we're trying to delete the project.
  bool _deleting = false;

  bool _showAddTag = false;

  bool _hideFab = true;

  bool _showSettings = false;

  bool _confirmDeletePost = false;

  final Duration _duration = const Duration(
    milliseconds: 250,
  );

  String _content = "";

  /// Firestore collection name.
  final String _collectionName = "projects";

  /// Visible if the authenticated user has the right to edit this post.
  DocumentEditor _documentEditor = DocumentEditor(document: MutableDocument());

  /// Post's content.
  MutableDocument _document = MutableDocument();

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

  /// Used to add delay to post's metadata update.
  Timer? _metadataUpdateTimer;

  /// Used to add delay to post's content update.
  Timer? _contentUpdateTimer;

  final VerbalExpression _verbalExp = VerbalExpression()..space();

  @override
  void initState() {
    super.initState();
    angle = Tween(begin: 0.0, end: 60.0).animate(controller);
    fetchMetadata();
  }

  @override
  void dispose() {
    _metadataUpdateTimer?.cancel();
    _contentUpdateTimer?.cancel();
    _nameController.dispose();
    _summaryController.dispose();
    _document.removeListener(contentListener);
    _document.dispose();
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
      floatingActionButton: FabToTop(
        hideIfAtTop: _hideFab,
        fabIcon: const Icon(UniconsLine.arrow_up),
        pageScrollController: _pageScrollController,
      ),
      body: Stack(
        children: [
          ImprovedScrolling(
            scrollController: _pageScrollController,
            onScroll: onScroll,
            child: CustomScrollView(
              controller: _pageScrollController,
              slivers: [
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
                  cover: _project.cover,
                  onTryAddCoverImage: tryUploadCover,
                  onTryRemoveCoverImage: tryRemoveCoverImage,
                ),
                PostPageBody(
                  canManagePosts: canManagePosts,
                  content: _content,
                  document: _document,
                  documentEditor: _documentEditor,
                  isMobileSize: isMobileSize,
                  loading: _loading,
                  maxWidth: maxWidth,
                ),
                PostFooter(
                  content: _content,
                  maxWidth: maxWidth,
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
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: 24.0,
            left: 24.0,
            child: CircleButton(
              icon: const Icon(UniconsLine.box),
              onTap: () => Beamer.of(context, root: true).beamToNamed(
                HomeLocation.route,
              ),
            ),
          ),
          Positioned(
            top: 24.0,
            right: 24.0,
            child: CircleButton(
              tooltip: "settings".tr(),
              icon: Transform.rotate(
                angle: angle.value,
                child: const Icon(UniconsLine.setting),
              ),
              onTap: () {
                if (!_showSettings) {
                  _pageScrollController.animateTo(
                    0.0,
                    curve: Curves.decelerate,
                    duration: _duration,
                  );
                  controller.play(duration: _duration);
                } else {
                  controller.playReverse(duration: _duration);
                }

                setState(() {
                  _showSettings = !_showSettings;
                });
              },
            ),
          ),
          Positioned(
            top: 24.0,
            right: 70.0,
            child: CircleButton(
              icon: const Icon(UniconsLine.home_alt),
              onTap: () => Beamer.of(context, root: true).beamToNamed(
                HomeLocation.route,
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
    final String userId = ref.read(AppState.userProvider).authUser?.uid ?? "";
    if (userId.isEmpty) {
      loggy.error("User id is emty :o");
      return;
    }

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

  /// Creates a document with multiple levels of headers with hint text, and a
  /// regular paragraph for comparison.
  MutableDocument _createDocument() {
    return MutableDocument(
      nodes: [
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(text: ''),
          metadata: {'blockType': header1Attribution},
        ),
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(text: ''),
          metadata: {'blockType': header2Attribution},
        ),
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(text: ''),
          metadata: {'blockType': header3Attribution},
        ),
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(
            text: "there: https://google.com",
            spans: AttributedSpans(
              attributions: [
                SpanMarker(
                  attribution:
                      LinkAttribution(url: Uri.parse('https://google.com')),
                  offset: 7,
                  markerType: SpanMarkerType.start,
                ),
                SpanMarker(
                  attribution:
                      LinkAttribution(url: Uri.parse('https://google.com')),
                  offset: 24,
                  markerType: SpanMarkerType.end,
                ),
              ],
            ),
          ),
        ),
        ParagraphNode(
          id: DocumentEditor.createNodeId(),
          text: AttributedText(
            text:
                'Nam hendrerit vitae elit ut placerat. Maecenas nec congue neque. Fusce eget tortor pulvinar, cursus neque vitae, sagittis lectus. Duis mollis libero eu scelerisque ullamcorper. Pellentesque eleifend arcu nec augue molestie, at iaculis dui rutrum. Etiam lobortis magna at magna pellentesque ornare. Sed accumsan, libero vel porta molestie, tortor lorem eleifend ante, at egestas leo felis sed nunc. Quisque mi neque, molestie vel dolor a, eleifend tempor odio.',
          ),
        ),
      ],
    );
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
        // _document = deserializeMarkdownToDocument(_content)
        //   ..addListener(contentListener);
        _document = _createDocument();

        _documentEditor = DocumentEditor(
          document: _document,
        );
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
          customMetadata: customMetadata,
        ),
      );
    } catch (error) {
      loggy.error(error);
    } finally {
      setState(() => _saving = false);
    }
  }

  void onPostContentChange() {
    _content = serializeDocumentToMarkdown(_document);

    trySaveContent();
    // updateMetrics();
  }

  /// Update post's character & word count.
  void updateMetrics() async {
    final Iterable<RegExpMatch> wordMatches = _wordsRegex.allMatches(_content);

    _project = _project.copyWith(
      characterCount: _content.length,
      wordCount: wordMatches.length,
    );

    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_project.id)
          .update({
        "character_count": _project.characterCount,
        "word_count": _project.wordCount,
      });
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
      loggy.info("visibility: ${visibility.name} | selected: $selected");
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
      onPostContentChange,
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

  void onScroll(double offset) {
    if (offset <= 0) {
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
}
