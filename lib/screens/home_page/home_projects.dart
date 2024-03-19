import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/home_page/colored_text.dart';
import 'package:rootasjey/screens/home_page/select_featured_project_dialog.dart';
import 'package:rootasjey/types/alias/firestore/doc_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/firestore/document_snapshot_map.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_project_item_action.dart';
import 'package:rootasjey/types/featured_project.dart';
import 'package:rootasjey/types/home_page_data.dart';
import 'package:rootasjey/types/project/project.dart';

class HomeProjects extends StatefulWidget {
  /// Home projects section.
  const HomeProjects({
    super.key,
    this.margin = EdgeInsets.zero,
  });

  /// Space around this widget.
  final EdgeInsetsGeometry margin;

  @override
  State<HomeProjects> createState() => _HomeProjectsState();
}

class _HomeProjectsState extends State<HomeProjects> with UiLoggy {
  /// Allow section customization if true.
  bool _canEdit = false;

  /// True if there's been a project card reorder
  /// waiting to be validated by the server.
  bool _hasPendingReorder = false;

  /// Page data, especially featured projects.
  HomePageData _homePageData = HomePageData.empty();

  /// Subscription to home page data.
  DocSnapshotStreamSubscription? _homePageDataSub;

  /// Full project data initially fetched from home page data;
  final List<Project> _projects = [];

  /// Firestore collection's name (page data).
  final String _collectionName = "pages";

  /// Firestore document's name (page data).
  final String _documentName = "home";

  @override
  void initState() {
    super.initState();
    fetchPageData();
  }

  @override
  void dispose() {
    _homePageDataSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: Wrap(
        spacing: 12.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          TextButton(
            onPressed: onTapProjects,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.green.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Text(
              "PROJECTS",
              style: Utils.calligraphy.body3(
                textStyle: const TextStyle(
                  fontSize: 42.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          if (_projects.isNotEmpty)
            ..._projects.map((project) {
              return ColoredText(
                onTap: () {
                  debugPrint("project $project");
                },
                textHoverColor: Colors.pink,
                textValue: "${project.name} •",
              );
            }),
        ],
      ),
    );
  }

  /// Fetch page data (mainly featured projects).
  void fetchPageData() async {
    try {
      final query = FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_documentName);

      listenToDocumentChanges(query);
      final DocumentSnapshotMap doc = await query.get();

      final Json? data = doc.data();
      if (!doc.exists || data == null) {
        return;
      }

      setState(() {
        data["id"] = doc.id;
        _homePageData = HomePageData.fromMap(data);
      });

      fetchProjets();
    } catch (error) {
      loggy.error(error);
    }
  }

  void fetchProjets() async {
    setState(() {
      _projects.clear();
    });

    final List<FeaturedProject> featuredProjects =
        _homePageData.featuredProjects;

    for (final FeaturedProject p in featuredProjects) {
      final Project project = await fetchProject(p.id);
      _projects.add(project);
    }

    setState(() {});
  }

  Future<Project> fetchProject(String projectId) async {
    try {
      final DocumentSnapshotMap doc = await FirebaseFirestore.instance
          .collection("projects")
          .doc(projectId)
          .get();

      final Json? data = doc.data();
      if (!doc.exists || data == null) {
        return Project.empty();
      }

      data["id"] = doc.id;
      return Project.fromMap(data);
    } catch (error) {
      loggy.error(error);
      return Project.empty();
    }
  }

  void onTapProjects() {}

  void onNavigateToAllProjects() {}

  void openDialog(Project project) {
    Utils.graphic.showAdaptiveDialog(
      context,
      builder: (BuildContext context) {
        return SelectFeaturedProjectDialog(
          featuredProjectIds:
              _homePageData.featuredProjects.map((x) => x.id).toList(),
          onValidate: (selectedProjects) =>
              tryAddFeaturedProjects(selectedProjects),
        );
      },
    );
  }

  void tryAddFeaturedProjects(List<Project> projectsToAdd) async {
    if (projectsToAdd.isEmpty) {
      return;
    }

    try {
      for (var projectToAdd in projectsToAdd) {
        _homePageData.featuredProjects.add(
          FeaturedProject(
            id: projectToAdd.id,
            // color: Constants.colors.palette.pickOne().value,
            color: Constants.colors.getRandomFromPalette().value,
            name: projectToAdd.name,
          ),
        );
      }

      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_documentName)
          .update(_homePageData.toMap());
    } catch (error) {
      loggy.error(error);
    }
  }

  void onPopupMenuItemSelected(
      EnumProjectItemAction action, int index, Project project) {
    switch (action) {
      case EnumProjectItemAction.delete:
        break;
      default:
    }
  }

  void onTapProject(Project project) {}

  void onToggleEditMode() {
    setState(() {
      _canEdit = !_canEdit;
    });
  }

  void onRemoveProject(Project project) async {
    _projects.remove(project);
    _homePageData.featuredProjects.removeWhere((x) => x.id == project.id);

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_documentName)
          .update(_homePageData.toMap());

      setState(() {});
    } catch (error) {
      loggy.error(error);
      _projects.add(project);
      setState(() {});
    }
  }

  void listenToDocumentChanges(DocumentReference<Map<String, dynamic>> query) {
    _homePageDataSub?.cancel();
    _homePageDataSub = query.snapshots().skip(1).listen(
      (snapshot) {
        if (!snapshot.exists) {
          _homePageDataSub?.cancel();
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
          _homePageData = HomePageData.fromMap(data);
        });

        if (_hasPendingReorder &&
            _homePageData.featuredProjects.length == _projects.length) {
          _hasPendingReorder = false;
          return;
        }

        fetchProjets();
      },
      onError: (error) {
        loggy.error(error);
      },
      onDone: () {
        _homePageDataSub?.cancel();
      },
    );
  }

  /// Callback fired when a project card has been droped on a target.
  void onDropProject(int dropIndex, List<int> dragIndexes) {
    final firstDragIndex = dragIndexes.first;

    if (dropIndex == firstDragIndex) {
      return;
    }

    final Project dropProject = _projects.elementAt(dropIndex);
    final Project dragProject = _projects.elementAt(firstDragIndex);

    setState(() {
      _hasPendingReorder = true;
      _projects[dropIndex] = dragProject;
      _projects[firstDragIndex] = dropProject;
    });

    final HomePageData newHomePageData = _homePageData.copyWith(
      featuredProjects: _projects
          .map(
            (project) => FeaturedProject(
              id: project.id,
              color: _homePageData.featuredProjects
                  .firstWhere((x) => x.id == project.id)
                  .color,
              name: project.name,
            ),
          )
          .toList(),
    );

    try {
      FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(_documentName)
          .update(newHomePageData.toMap());
    } catch (error) {
      loggy.error(error);
    }
  }
}
