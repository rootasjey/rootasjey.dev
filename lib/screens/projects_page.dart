import 'package:beamer/beamer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/buttons/dark_elevated_button.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/screens/create_project_page.dart';
import 'package:rootasjey/types/alias/firestore/document_change_map.dart';
import 'package:rootasjey/types/alias/firestore/document_map.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_post_item_action.dart';
import 'package:rootasjey/types/intents/next_intent.dart';
import 'package:rootasjey/types/intents/previous_intent.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:unicons/unicons.dart';

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> with UiLoggy {
  /// True if there're more projects to fetch.
  bool _hasNext = true;

  /// True if the page is fetching projects.
  bool _loading = false;

  /// True if we're try to create a new project.
  bool _creating = false;

  bool _showCreatePage = false;

  /// Last document fetched from Firestore.
  DocumentSnapshot? _lastDocument;

  /// Maximum projects fetch per page.
  final int _limit = 10;

  /// Project list. This is the main page content.
  final List<Project> _projects = [];

  /// Allow to go forward or backward with the keyboard keys.
  final SwiperController _swipeController = SwiperController();

  /// Listens to illustration's updates.
  QuerySnapshotStreamSubscription? _postSubscription;

  final List<PopupMenuEntry<EnumProjectItemAction>> _projectPopupMenuItems = [
    PopupMenuItemIcon(
      icon: const PopupMenuIcon(UniconsLine.trash),
      textLabel: "delete".tr(),
      newValue: EnumProjectItemAction.delete,
      selected: false,
      // selected: post.visibility == EnumProjectItemAction.private,
    ),
  ];

  /// Firestore collection name.
  final String _collectionName = "projects";
  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _postSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showCreatePage) {
      return CreateProjectPage(
        onCancel: () {
          setState(() => _showCreatePage = false);
        },
        onSubmit: (String name, String summary) {
          _showCreatePage = false;
          tryCreateProject(name: name, summary: summary);
        },
      );
    }

    if (_creating) {
      return loadingView();
    }

    if (_projects.isEmpty) {
      return emptyView();
    }

    final Size windowSize = MediaQuery.of(context).size;
    final double windowHeight = windowSize.height;

    return Shortcuts(
      shortcuts: const <SingleActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowLeft): PreviousIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): NextIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          PreviousIntent: CallbackAction(
            onInvoke: (Intent intent) => _swipeController.previous(),
          ),
          NextIntent: CallbackAction(
            onInvoke: (Intent intent) => _swipeController.next(),
          ),
        },
        child: Scaffold(
          floatingActionButton: fab(),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 72.0,
                    top: 72.0,
                    bottom: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FadeInY(
                            beginY: Utilities.ui.getBeginY(),
                            delay: Duration(
                              milliseconds: Utilities.ui
                                  .getNextAnimationDelay(reset: true),
                            ),
                            child: CircleButton(
                              onTap: Beamer.of(context).beamBack,
                              icon: const Icon(UniconsLine.arrow_left),
                              backgroundColor: Colors.amber,
                            ),
                          ),
                          FadeInY(
                            beginY: Utilities.ui.getBeginY(),
                            delay: Duration(
                              milliseconds:
                                  Utilities.ui.getNextAnimationDelay(),
                            ),
                            child: const Opacity(
                              opacity: 0.6,
                              child: AppIcon(
                                margin: EdgeInsets.only(left: 12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      FadeInY(
                        beginY: Utilities.ui.getBeginY(),
                        delay: Duration(
                          milliseconds: Utilities.ui.getNextAnimationDelay(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Text(
                            "Projects".toUpperCase(),
                            style: Utilities.fonts.body2(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: FadeInY(
                  beginY: Utilities.ui.getBeginY(),
                  delay: Duration(
                    milliseconds: Utilities.ui.getNextAnimationDelay(),
                  ),
                  child: SizedBox(
                    height: windowHeight - 300.0,
                    child: Swiper(
                      loop: false,
                      controller: _swipeController,
                      pagination: const SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          color: Colors.white,
                          activeColor: Colors.amber,
                        ),
                      ),
                      control: const SwiperControl(
                        color: Colors.amber,
                        padding: EdgeInsets.all(24.0),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final Project project = _projects.elementAt(index);

                        return ProjectCard(
                          index: index,
                          useBottomSheet: false,
                          onTapCard: () => onTapProject(project),
                          project: project,
                          popupMenuEntries: _projectPopupMenuItems,
                          onPopupMenuItemSelected: onPopupMenuItemSelected,
                        );
                      },
                      itemCount: _projects.length,
                      viewportFraction: 0.5,
                      scale: 0.6,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyView() {
    const double beginY = 24.0;

    return Scaffold(
      floatingActionButton: fab(),
      body: Stack(
        children: [
          const Positioned(top: 60.0, left: 60.0, child: AppIcon()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FadeInY(
                  beginY: beginY,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Icon(UniconsLine.box, size: 42.0),
                  ),
                ),
                FadeInY(
                  beginY: beginY,
                  delay: const Duration(milliseconds: 50),
                  child: Text(
                    "You've no project at this moment. You can create one.",
                    style: Utilities.fonts.body2(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FadeInY(
                  beginY: beginY,
                  delay: const Duration(milliseconds: 100),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: DarkElevatedButton(
                      child: const Text("create project"),
                      onPressed: () {
                        setState(() => _showCreatePage = true);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fab() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.amber,
      onPressed: () => setState(() => _showCreatePage = true),
      icon: const Icon(UniconsLine.plus),
      label: const Text("Create project"),
    );
  }

  Widget loadingView() {
    return LoadingView.scaffold(
      message: _creating
          ? "Creating your new project..."
          : "Loading featured projects...",
    );
  }

  /// Make a API request call to create a new document in Firestore
  /// and suitable files in Storage.
  void tryCreateProject({
    required String name,
    required String summary,
  }) async {
    final User? user = ref.read(AppState.userProvider).authUser;
    if (user == null) {
      return;
    }

    setState(() => _creating = true);

    try {
      final DocumentMap projectSnapshot =
          await FirebaseFirestore.instance.collection("projects").add({
        "language": "en",
        "name": name,
        "summary": summary,
        "user_id": user.uid,
      });

      setState(() => _creating = false);

      if (!mounted) {
        return;
      }

      final String route = ProjectsLocation.singleProjectRoute.replaceFirst(
        ":projectId",
        projectSnapshot.id,
      );

      loggy.info("projectSnapshot.id: ${projectSnapshot.id}");
      Beamer.of(context).beamToNamed(route, data: {
        "projectId": projectSnapshot.id,
      });
    } on Exception catch (error) {
      loggy.error(error);
      setState(() {
        _creating = false;
      });
    }
  }

  void fetchProjects() async {
    setState(() {
      _loading = true;
      _projects.clear();
    });

    try {
      final QueryMap query = getAuthListenQuery();
      listenToPostEvents(query);

      final QuerySnapMap snapshot = await query.get();

      if (snapshot.size == 0) {
        setState(() {
          _hasNext = false;
          _loading = false;
        });

        return;
      }

      for (final QueryDocSnapMap doc in snapshot.docs) {
        final Json map = doc.data();
        map["id"] = doc.id;

        _projects.add(Project.fromMap(map));
      }

      setState(() {
        _loading = false;
        _lastDocument = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  void fetchMoreProjects() async {
    final DocumentSnapshot? lastDocument = _lastDocument;
    if (!_hasNext || _loading || lastDocument == null) {
      return;
    }

    setState(() => _loading = true);

    try {
      final QueryMap query = getAuthListenQuery();
      listenToPostEvents(query);

      final QuerySnapMap snapshot = await query.get();

      if (snapshot.size == 0) {
        setState(() {
          _hasNext = false;
          _loading = false;
        });

        return;
      }

      for (final QueryDocSnapMap doc in snapshot.docs) {
        final Json data = doc.data();
        data["id"] = doc.id;
        _projects.add(Project.fromMap(data));
      }

      setState(() {
        _loading = false;
        _lastDocument = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  void onTapProject(Project project) {
    Beamer.of(context).beamToNamed(
      ProjectsLocation.singleProjectRoute.replaceFirst(
        ":projectId",
        project.id,
      ),
      data: {
        "projectId": project.id,
      },
    );
  }

  /// Return the query to listen changes to.
  QueryMap getAuthListenQuery() {
    final DocumentSnapshot? lastDocument = _lastDocument;
    final String userId = ref.read(AppState.userProvider).authUser?.uid ?? "";

    if (userId.isEmpty) {
      if (lastDocument == null) {
        return FirebaseFirestore.instance
            .collection(_collectionName)
            .where("visibility", isEqualTo: "public")
            .orderBy("updated_at", descending: true)
            .limit(_limit);
      }

      return FirebaseFirestore.instance
          .collection(_collectionName)
          .where("visibility", isEqualTo: "public")
          .orderBy("updated_at", descending: true)
          .endAtDocument(lastDocument);
    }

    if (lastDocument == null) {
      return FirebaseFirestore.instance
          .collection(_collectionName)
          .where("user_id", isEqualTo: userId)
          .orderBy("updated_at", descending: true)
          .limit(_limit);
    }

    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("user_id", isEqualTo: userId)
        .orderBy("updated_at", descending: true)
        .endAtDocument(lastDocument);
  }

  void listenToPostEvents(QueryMap? query) {
    if (query == null) {
      return;
    }

    _postSubscription?.cancel();
    _postSubscription = query.snapshots().skip(1).listen(
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

  /// Fire when a new document has been created in Firestore.
  /// Add the corresponding document in the UI.
  void onAddStreamingIllustration(DocumentChangeMap documentChange) {
    final Json? data = documentChange.doc.data();

    if (data == null) {
      return;
    }

    setState(() {
      data["id"] = documentChange.doc.id;
      final Project project = Project.fromMap(data);
      _projects.insert(0, project);
    });
  }

  /// Fire when a new document has been updated in Firestore.
  /// Update the corresponding document in the UI.
  void onUpdateStreamingIllustration(DocumentChangeMap documentChange) async {
    try {
      final data = documentChange.doc.data();
      if (data == null) {
        return;
      }

      final int index = _projects.indexWhere(
        (Project p) => p.id == documentChange.doc.id,
      );

      data["id"] = documentChange.doc.id;
      final updatedProject = Project.fromMap(data);

      setState(() {
        _projects.removeAt(index);
        _projects.insert(index, updatedProject);
      });
    } on Exception catch (error) {
      loggy.error(
        "The document with the id ${documentChange.doc.id} "
        "doesn't exist in the illustrations list.",
      );

      loggy.error(error);
    }
  }

  /// Fire when a new document has been delete from Firestore.
  /// Delete the corresponding document from the UI.
  void onRemoveStreamingIllustration(DocumentChangeMap documentChange) {
    setState(() {
      _projects.removeWhere(
        (illustration) => illustration.id == documentChange.doc.id,
      );
    });
  }

  void onPopupMenuItemSelected(
    EnumProjectItemAction action,
    int index,
    Project project,
  ) {
    switch (action) {
      case EnumProjectItemAction.delete:
        tryDeleteProject(
          index: index,
          project: project,
        );
        break;
      default:
    }
  }

  void tryDeleteProject({
    required int index,
    required Project project,
  }) async {
    setState((() {
      _projects.removeAt(index);
    }));

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(project.id)
          .delete();

      if (!mounted) {
        return;
      }
    } catch (error) {
      loggy.error(error);

      setState(() {
        _projects.insert(index, project);
      });
    }
  }
}
