import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/header_section.dart';
import 'package:rootasjey/components/min_project_card.dart';
import 'package:rootasjey/components/sliver_edge_padding.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/header_section_data.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/flash_helper.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:unicons/unicons.dart';

class DraftProjectsPage extends StatefulWidget {
  const DraftProjectsPage({Key? key}) : super(key: key);

  @override
  _DraftProjectsPageState createState() => _DraftProjectsPageState();
}

class _DraftProjectsPageState extends State<DraftProjectsPage> {
  final _projects = <Project>[];
  final _limit = 10;

  bool _hasNext = true;
  bool _isLoading = false;

  DocumentSnapshot? _lastDocumentSnapshot;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: CustomScrollView(
        slivers: [
          header(),
          body(),
          SliverEdgePadding(
            padding: const EdgeInsets.only(
              bottom: 300.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    Widget child;

    if (!_isLoading && _projects.isEmpty) {
      child = SliverEmptyView();
    } else {
      child = projectsGrid();
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 80.0,
      ),
      sliver: child,
    );
  }

  PopupMenuButton buildPopupMenuButton(Project project, int index) {
    return PopupMenuButton<String>(
      icon: Opacity(
        opacity: 0.6,
        child: Icon(UniconsLine.ellipsis_h),
      ),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            confirmDeleteProject(index);
            break;
          case 'publish':
            publish(index);
            break;
          default:
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'publish',
          child: ListTile(
            leading: Icon(UniconsLine.cloud_upload),
            title: Text("publish".tr()),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(UniconsLine.trash),
            title: Text("delete".tr()),
          ),
        ),
      ],
    );
  }

  Widget header() {
    final String? currentPath = Beamer.of(context).currentPages.last.name;

    final List<HeaderSectionData> headerSectionData = [
      HeaderSectionData(
          titleValue: "drafts".tr(),
          path: DashboardLocationContent.draftProjectsRoute),
      HeaderSectionData(
        titleValue: "published".tr(),
        path: DashboardLocationContent.publishedProjectsRoute,
      ),
    ];

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.all(80.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: IconButton(
                  onPressed: Beamer.of(context).beamBack,
                  icon: Icon(UniconsLine.arrow_left),
                ),
              ),
              ...headerSectionData.map(
                (data) => HeaderSection(
                  titleValue: data.titleValue,
                  onTap: _onTapHeaderSection,
                  path: data.path,
                  isSelected: data.path == currentPath,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget projectsGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final project = _projects.elementAt(index);
          final popupButton = buildPopupMenuButton(project, index);

          return MinProjectCard(
            project: project,
            width: 400.0,
            onTap: () => goToEditPage(project),
            contentPadding: const EdgeInsets.all(24.0),
            popupMenuButton: popupButton,
          );
        },
        childCount: _projects.length,
      ),
    );
  }

  void confirmDeleteProject(int index) {
    FlashHelper.deleteDialog(
      context,
      message: "project_delete_description".tr(),
      onConfirm: () {
        deleteProject(index);
      },
    );
  }

  void deleteProject(int index) async {
    setState(() => _isLoading = true);

    final removedProject = _projects.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(removedProject.id)
          .delete();
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_delete_failed".tr(),
      );

      setState(() {
        _projects.insert(index, removedProject);
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void fetch() async {
    setState(() {
      _projects.clear();
      _isLoading = true;
    });

    try {
      final userAuth = stateUser.userAuth!;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('published', isEqualTo: false)
          .where('author.id', isEqualTo: uid)
          .limit(_limit)
          .get();

      if (snapshot.size == 0) {
        setState(() {
          _hasNext = false;
          _isLoading = false;
        });

        return;
      }

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        _projects.add(Project.fromJSON(data));
      });

      setState(() {
        _isLoading = false;
        _hasNext = _limit == snapshot.size;
        _lastDocumentSnapshot = snapshot.docs.last;
      });
    } catch (error) {
      appLogger.e(error);
    }
  }

  void fetchMore() async {
    if (_lastDocumentSnapshot == null || !_hasNext || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userAuth = stateUser.userAuth!;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('published', isEqualTo: false)
          .where('author.id', isEqualTo: uid)
          .startAfterDocument(_lastDocumentSnapshot!)
          .limit(_limit)
          .get();

      if (snapshot.size == 0) {
        setState(() {
          _hasNext = false;
          _isLoading = false;
        });

        return;
      }

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        _projects.add(Project.fromJSON(data));
      });

      setState(() {
        _isLoading = false;
        _hasNext = _limit == snapshot.size;
        _lastDocumentSnapshot = snapshot.docs.last;
      });
    } catch (error) {
      appLogger.e(error);
    }
  }

  Future goToEditPage(Project project) async {
    Beamer.of(context).beamToNamed(
      "${DashboardLocationContent.editProjectsRoute}/${project.id}",
      data: {"projectId": project.id},
    );

    fetch();
  }

  bool onNotification(ScrollNotification scrollNotification) {
    final double current = scrollNotification.metrics.pixels;
    final double max = scrollNotification.metrics.maxScrollExtent;

    if (current < max - 300.0) {
      return false;
    }

    fetchMore();
    return false;
  }

  void publish(int index) async {
    setState(() => _isLoading = true);

    final removedProject = _projects.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(removedProject.id)
          .update({
        'published': true,
      });

      setState(() => _isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _projects.insert(index, removedProject);
      });
    }
  }

  void _onTapHeaderSection(String path) {
    Beamer.of(context).beamToNamed(path);
  }
}
