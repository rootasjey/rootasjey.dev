import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/mini_project_card.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/screens/home_page/select_featured_project_dialog.dart';
import 'package:rootasjey/types/alias/firestore/doc_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/firestore/document_snapshot_map.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_project_item_action.dart';
import 'package:rootasjey/types/enums/enum_signal_id.dart';
import 'package:rootasjey/types/featured_project.dart';
import 'package:rootasjey/types/home_page_data.dart';
import 'package:rootasjey/types/project/popup_entry_project.dart';
import 'package:rootasjey/types/project/project.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:supercharged/supercharged.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({
    super.key,
    this.size = Size.zero,
  });

  /// Window's size.
  final Size size;

  @override
  State<ProjectSection> createState() => _ProjectSectionState();
}

class _ProjectSectionState extends State<ProjectSection> with UiLoggy {
  /// Allow section customization if true.
  bool _canEdit = false;

  /// True if there's been a project card reorder
  /// waiting to be validated by the server.
  bool _hasPendingReorder = false;

  /// Page data, especially featured projects.
  HomePageData _homePageData = HomePageData.empty();

  /// Full project data initially fetched from home page data;
  final List<Project> _projects = [];

  final List<PopupEntryProject> _popupEnries = [
    PopupMenuItemIcon(
      icon: const PopupMenuIcon(TablerIcons.trash),
      textLabel: "delete".tr(),
    ),
  ];

  /// Firestore collection's name (page data).
  final String _collectionName = "pages";

  /// Firestore document's name (page data).
  final String _documentName = "home";

  /// Section's title.
  String _projectTitle = "";

  DocSnapshotStreamSubscription? _homePageDataSub;

  @override
  void initState() {
    super.initState();
    tryFetchPageData();
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize =
        widget.size.width < Utilities.size.mobileWidthTreshold ? 24.0 : 64.0;

    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);

    final UserFirestore userFirestore = signalUserFirestore.value;
    final bool isAuthenticated = userFirestore.id.isNotEmpty;
    // final bool isAuthenticated = userFirestore.rights.manageData;

    return SliverToBoxAdapter(
      child: Container(
        padding: getMargin(),
        color: Constants.colors.backgroundPalette.first,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: 1.0,
              child: Text(
                _projectTitle.isEmpty
                    ? "projects_featured".tr()
                    : _projectTitle,
                style: Utilities.fonts.body5(
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                children: projectCards(isAuthenticated),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.only(top: 16.0),
            //   child: Wrap(
            //     spacing: 12.0,
            //     runSpacing: 12.0,
            //     children: [
            //       MiniProjectCard(
            //         iconData: UniconsLine.pen,
            //         label: "Artbooking",
            //         onHover: onHover,
            //         color: Colors.pink,
            //       ),
            //       MiniProjectCard(
            //         iconData: UniconsLine.comment,
            //         label: "fig.style",
            //         onHover: onHover,
            //         color: Colors.amber,
            //       ),
            //       MiniProjectCard(
            //         iconData: TablerIcons.heart_medical,
            //         label: "My Health Partner",
            //         onHover: onHover,
            //         color: Colors.blue,
            //       ),
            //       MiniProjectCard(
            //         iconData: UniconsLine.image,
            //         label: "unsplasharp",
            //         onHover: onHover,
            //         color: Colors.green,
            //       ),
            //       MiniProjectCard(
            //         iconData: UniconsLine.cloud_wifi,
            //         label: "notapokedex",
            //         onHover: onHover,
            //         color: Colors.yellow.shade800,
            //       ),
            //       MiniProjectCard(
            //         iconData: UniconsLine.cloud_wifi,
            //         label: "conway",
            //         onHover: onHover,
            //         color: Colors.blueGrey,
            //       ),
            //     ],
            //   ),
            // ),
            // TextButton(
            //   onPressed: onNavigateToAllProjects,
            //   child: Text(
            //     "projects_see_all".tr(),
            //     style: Utilities.fonts.body(
            //       textStyle: TextStyle(
            //         fontSize: 16.0,
            //         fontWeight: FontWeight.w600,
            //         color: Constants.colors.palette.first,
            //       ),
            //     ),
            //   ),
            // ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton(
                  onPressed: onNavigateToAllProjects,
                  child: Text(
                    "projects_see_all".tr(),
                    style: Utilities.fonts.body(
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Constants.colors.palette.first,
                      ),
                    ),
                  ),
                ),
                ...editButton(isAuthenticated),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> editButton(bool isAuthenticated) {
    if (!isAuthenticated) {
      return [];
    }

    return [
      CircleAvatar(
        radius: 4.0,
        backgroundColor: Constants.colors.palette.last,
      ),
      TextButton(
        onPressed: onToggleEditMode,
        child: Text(
          _canEdit ? "read_only".tr() : "edit".tr(),
          style: Utilities.fonts.body(
            textStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Constants.colors.palette.first,
            ),
          ),
        ),
      ),
    ];
  }

  /// Project cards.
  List<Widget> projectCards(bool isAuthenticated) {
    int index = -1;
    final List<Widget> children = [];

    for (var project in _projects) {
      index++;
      children.add(
        MiniProjectCard(
          iconData: TablerIcons.pencil,
          onHover: onHover,
          color: Colors.pink,
          project: project,
          popupMenuEntries: _popupEnries,
          onTap: onTapProject,
          onPopupMenuItemSelected: onPopupMenuItemSelected,
          showEditMode: _canEdit,
          onRemove: onRemoveProject,
          canDrag: _canEdit,
          dragGroupName: "home-page",
          onDrop: onDropProject,
          index: index,
        ),
      );
    }

    if (isAuthenticated) {
      children.add(
        MiniProjectCard(
          iconData: TablerIcons.plus,
          iconColor: Constants.colors.palette.first,
          color: Constants.colors.palette.first,
          onTap: openDialog,
          project: Project.empty().copyWith(name: "project_add".tr()),
        ),
      );
    }

    return children;
  }

  EdgeInsets getMargin() {
    if (widget.size.width < Utilities.size.mobileWidthTreshold) {
      return const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 64.0,
        bottom: 100.0,
      );
    }

    if (widget.size.width < 1000.0) {
      return const EdgeInsets.only(
        left: 36.0,
        right: 36.0,
        top: 64.0,
        bottom: 100.0,
      );
    }

    return const EdgeInsets.only(
      left: 200.0,
      top: 100.0,
      bottom: 100.0,
    );
  }

  /// Fetch page data (mainly featured projects).
  void tryFetchPageData() async {
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

      tryFetchAllProject();
    } catch (error) {
      loggy.error(error);
    }
  }

  void tryFetchAllProject() async {
    setState(() {
      _projects.clear();
    });

    final List<FeaturedProject> featuredProjects =
        _homePageData.featuredProjects;

    for (final FeaturedProject p in featuredProjects) {
      final Project project = await tryFetchProject(p.id);
      _projects.add(project);
    }

    setState(() {});
  }

  Future<Project> tryFetchProject(String projectId) async {
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

  void onHover(String label, Color color, bool isHover) {
    setState(() {
      _projectTitle = isHover ? label : "";
    });
  }

  void onNavigateToAllProjects() {
    Beamer.of(context).beamToNamed(ProjectsLocation.route);
  }

  void openDialog(Project project) {
    Utilities.ui.showAdaptiveDialog(
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
            color: Constants.colors.palette.pickOne().value,
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

  void onTapProject(Project project) {
    Beamer.of(context).beamToNamed(
      ProjectsLocation.singleProjectRoute.replaceFirst(
        ":projectId",
        project.id,
      ),
      data: {
        "projectId": project.id,
      },
      routeState: {
        "projectName": project.name,
      },
    );
  }

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

        tryFetchAllProject();
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
