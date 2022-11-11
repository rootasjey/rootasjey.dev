import 'package:beamer/beamer.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/screens/projects_page/create_project_page.dart';
import 'package:rootasjey/screens/projects_page/projects_page_body.dart';
import 'package:rootasjey/screens/projects_page/projects_page_empty_view.dart';
import 'package:rootasjey/types/alias/firestore/document_change_map.dart';
import 'package:rootasjey/types/alias/firestore/document_map.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_project_item_action.dart';
import 'package:rootasjey/types/intents/escape_intent.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/types/user/user_rights.dart';
import 'package:unicons/unicons.dart';

/// A page widget showing projects.
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

  /// If true, show a specific UI to create a project.
  bool _showCreatePage = false;

  /// Last document fetched from Firestore.
  DocumentSnapshot? _lastDocument;

  /// Maximum projects fetch per page.
  final int _limit = 10;

  /// Project list. This is the main page content.
  final List<Project> _projects = [];

  /// Allow to go forward or backward with the keyboard keys.
  final SwiperController _swipeController = SwiperController();

  /// Listens to projects' updates.
  QuerySnapshotStreamSubscription? _projectSubscription;

  /// Popup menu items for project card.
  final List<PopupMenuEntry<EnumProjectItemAction>> _projectPopupMenuItems = [
    PopupMenuItemIcon(
      icon: const PopupMenuIcon(UniconsLine.trash),
      textLabel: "delete".tr(),
      newValue: EnumProjectItemAction.delete,
      selected: false,
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
    _projectSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserFirestore? userFirestore =
        ref.watch(AppState.userProvider).firestoreUser;
    final UserRights userRights = userFirestore?.rights ?? const UserRights();
    final bool canManageProjects = userRights.managePosts;

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
      return LoadingView.scaffold(
        message: _creating
            ? "Creating your new project..."
            : "Loading featured projects...",
      );
    }

    if (_projects.isEmpty) {
      return wrapWithShortcuts(
        child: ProjectsPageEmptyView(
          canCreate: canManageProjects,
          fab: fab(show: canManageProjects),
          onShowCreatePage: onShowCreate,
          onCancel: onCancel,
        ),
      );
    }

    final Size windowSize = MediaQuery.of(context).size;

    return wrapWithShortcuts(
      child: ProjectsPageBody(
        canManage: canManageProjects,
        fab: fab(show: canManageProjects),
        onNextProject: onNextProject,
        onPreviousProject: onPreviousProject,
        onPopupMenuItemSelected: onPopupMenuItemSelected,
        onTapProject: onTapProject,
        projects: _projects,
        projectPopupMenuItems: _projectPopupMenuItems,
        swipeController: _swipeController,
        windowSize: windowSize,
      ),
    );
  }

  Widget fab({required bool show}) {
    if (!show) {
      return Container();
    }

    return FloatingActionButton.extended(
      backgroundColor: Colors.amber,
      onPressed: onShowCreate,
      icon: const Icon(UniconsLine.plus),
      label: Text(
        "project_create".tr(),
        style: Utilities.fonts.body(
            textStyle: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        )),
      ),
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

  void onShowCreate() {
    () => setState(() => _showCreatePage = true);
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
      final QueryMap query = getFirestoreQuery();
      listenToProjectEvents(query);

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
      final QueryMap query = getFirestoreQuery();
      listenToProjectEvents(query);

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
  QueryMap getFirestoreQuery() {
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

  void listenToProjectEvents(QueryMap? query) {
    if (query == null) {
      return;
    }

    _projectSubscription?.cancel();
    _projectSubscription = query.snapshots().skip(1).listen(
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
        "doesn't exist in the project list.",
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

  void onCancel() {
    if (Beamer.of(context).beamingHistory.isNotEmpty) {
      Beamer.of(context).beamBack();
      return;
    }

    Beamer.of(context, root: true).beamToNamed(HomeLocation.route);
  }

  void onNextProject() {
    _swipeController.next();
  }

  void onPreviousProject() {
    _swipeController.previous();
  }
}
