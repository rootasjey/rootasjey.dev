import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/buttons/dark_elevated_button.dart';
import 'package:rootasjey/components/dialogs/themed_dialog.dart';
import 'package:rootasjey/components/mini_project_card.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/alias/firestore/document_change_map.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/project/project.dart';

class SelectFeaturedProjectDialog extends ConsumerStatefulWidget {
  const SelectFeaturedProjectDialog({
    super.key,
    this.asBottomSheet = false,
    this.onValidate,
    this.featuredProjectIds = const [],
  });

  /// If true, this widget will take a suitable layout for bottom sheet.
  /// Otherwise, it will have a dialog layout.
  final bool asBottomSheet;

  /// Callback fired when we confirm the deletion.
  final void Function(List<Project> selectedProjects)? onValidate;

  /// Already selected projects.
  final List<String> featuredProjectIds;

  @override
  ConsumerState<SelectFeaturedProjectDialog> createState() =>
      _AddFeaturedProjectState();
}

class _AddFeaturedProjectState
    extends ConsumerState<SelectFeaturedProjectDialog> with UiLoggy {
  /// True if there're more projects to fetch.
  bool _hasNext = true;

  /// True if the page is fetching projects.
  bool _loading = false;

  /// True if the page is fetching more projects.
  bool _loadingMore = true;

  /// Last document fetched from Firestore.
  DocumentSnapshot? _lastDocument;

  /// Maximum projects fetch per page.
  final int _limit = 10;

  /// Project list. This is the main page content.
  final List<Project> _projects = [];

  /// Firestore collection name.
  final String _collectionName = "projects";

  /// Listens to projects' updates.
  QuerySnapshotStreamSubscription? _projectSubscription;

  /// Scroll controller for this widget.
  final ScrollController _pageScrollController = ScrollController();

  /// Selected books to add illustration(s) in.
  final List<Project> _selectedProjects = [];

  @override
  void initState() {
    super.initState();
    tryFetchProjects();
  }

  @override
  void dispose() {
    _pageScrollController.dispose();
    _lastDocument = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final void Function()? onValidateCallback = _loading ? null : onValidate;

    if (widget.asBottomSheet) {
      return mobileWidget(onValidate: onValidateCallback);
    }

    return ThemedDialog(
      autofocus: true,
      useRawDialog: true,
      title: header(),
      body: body(),
      textButtonValidation:
          "select_featured_projects".plural(_selectedProjects.length),
      footer: footer(onValidate: onValidateCallback),
      onCancel: Beamer.of(context).popRoute,
      onValidate: onValidateCallback,
    );
  }

  Widget body() {
    if (_loading) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            children: [
              Opacity(
                opacity: 0.8,
                child: Text(
                  "loading".tr(),
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 430.0,
          maxWidth: 400.0,
        ),
        child: NotificationListener<ScrollNotification>(
          onNotification: onScrollNotification,
          child: CustomScrollView(
            controller: _pageScrollController,
            slivers: [
              SliverGrid.builder(
                itemCount: _projects.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final Project project = _projects.elementAt(index);
                  final bool deactivated =
                      widget.featuredProjectIds.contains(project.id);

                  return MiniProjectCard(
                    deactivated: deactivated,
                    onTap: onTapProject,
                    selected: _selectedProjects.contains(project),
                    showLabel: true,
                    project: project,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget footer({void Function()? onValidate}) {
    return Material(
      elevation: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: widget.asBottomSheet
                ? DarkElevatedButton(
                    onPressed: onValidate,
                    child: Text("select_featured_projects"
                        .plural(_selectedProjects.length)),
                  )
                : DarkElevatedButton.large(
                    onPressed: onValidate,
                    child: Text(
                      "select_featured_projects"
                          .plural(_selectedProjects.length),
                      style: Utilities.fonts.body(
                        textStyle: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget header({
    bool create = false,
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    return Padding(
      padding: margin,
      child: Column(
        children: [
          Opacity(
            opacity: 0.8,
            child: Text(
              "projects".tr().toUpperCase(),
              style: Utilities.fonts.body(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Opacity(
              opacity: 0.4,
              child: Text(
                "project_featured_select".tr(),
                textAlign: TextAlign.center,
                style: Utilities.fonts.body(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileWidget({void Function()? onValidate}) {
    if (_loading) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            children: [
              Opacity(
                opacity: 0.8,
                child: Text(
                  "loading".tr(),
                  style: Utilities.fonts.body(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                  )),
                ),
              ),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: onScrollNotification,
          child: CustomScrollView(
            controller: _pageScrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    header(
                      margin: const EdgeInsets.all(12.0),
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final Project project = _projects.elementAt(index);

                      return MiniProjectCard(
                        onTap: onTapProject,
                        selected: _selectedProjects.contains(project),
                        project: project,
                      );
                    },
                    childCount: _projects.length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 150.0)),
            ],
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: footer(onValidate: onValidate),
        ),
      ],
    );
  }

  void tryFetchProjects() async {
    setState(() {
      _loading = true;
      _projects.clear();
    });

    try {
      final QueryMap query = getFirestoreQuery();
      listenToProjectChanges(getStreamingQuery());
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

  void tryFetchMoreProjects() async {
    setState(() {
      _loadingMore = true;
    });

    try {
      final QueryMap query = getFirestoreQuery();
      listenToProjectChanges(getStreamingQuery());
      final QuerySnapMap snapshot = await query.get();

      if (snapshot.size == 0) {
        setState(() {
          _hasNext = false;
          _loadingMore = false;
        });

        return;
      }

      for (final QueryDocSnapMap doc in snapshot.docs) {
        final Json map = doc.data();
        map["id"] = doc.id;

        _projects.add(Project.fromMap(map));
      }

      setState(() {
        _loadingMore = false;
        _lastDocument = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  /// Return the query to listen changes to.
  QueryMap getFirestoreQuery() {
    final DocumentSnapshot? lastDocument = _lastDocument;

    if (lastDocument == null) {
      return FirebaseFirestore.instance
          .collection(_collectionName)
          .where("visibility", isEqualTo: "public")
          .orderBy("created_at", descending: true)
          .limit(_limit);
    }

    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("visibility", isEqualTo: "public")
        .orderBy("created_at", descending: true)
        .limit(_limit)
        .startAfterDocument(lastDocument);
  }

  /// Return the query to listen changes to.
  QueryMap getStreamingQuery() {
    final DocumentSnapshot? lastDocument = _lastDocument;

    if (lastDocument == null) {
      return FirebaseFirestore.instance
          .collection(_collectionName)
          .where("visibility", isEqualTo: "public")
          .orderBy("created_at", descending: true)
          .limit(_limit);
    }

    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("visibility", isEqualTo: "public")
        .orderBy("created_at", descending: true)
        .limit(_limit)
        .endAtDocument(lastDocument);
  }

  void listenToProjectChanges(QueryMap? query) {
    if (query == null) {
      return;
    }

    _projectSubscription?.cancel();
    _projectSubscription = query.snapshots().skip(1).listen(
      (snapshot) {
        for (DocumentChangeMap documentChange in snapshot.docChanges) {
          switch (documentChange.type) {
            case DocumentChangeType.added:
              onAddStreamingProject(documentChange);
              break;
            case DocumentChangeType.modified:
              onUpdateStreamingProject(documentChange);
              break;
            case DocumentChangeType.removed:
              onRemoveStreamingProject(documentChange);
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
  void onAddStreamingProject(DocumentChangeMap documentChange) {
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

  void onTapProject(Project project) {
    _selectedProjects.contains(project)
        ? _selectedProjects.remove(project)
        : _selectedProjects.add(project);

    setState(() {});
  }

  /// Fire when a new document has been updated in Firestore.
  /// Update the corresponding document in the UI.
  void onUpdateStreamingProject(DocumentChangeMap documentChange) async {
    try {
      final Json? data = documentChange.doc.data();
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
  void onRemoveStreamingProject(DocumentChangeMap documentChange) {
    setState(() {
      _projects.removeWhere(
        (project) => project.id == documentChange.doc.id,
      );
    });
  }

  bool onScrollNotification(ScrollNotification scrollNotif) {
    if (scrollNotif.metrics.pixels < scrollNotif.metrics.maxScrollExtent) {
      return false;
    }

    if (_hasNext && !_loadingMore) {
      tryFetchMoreProjects();
    }

    return false;
  }

  void onValidate() {
    widget.onValidate?.call(_selectedProjects);
    Beamer.of(context).popRoute();
  }
}
