import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/components/sliver_edge_padding.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class DraftProjectsPage extends StatefulWidget {
  const DraftProjectsPage({Key key}) : super(key: key);

  @override
  _DraftProjectsPageState createState() => _DraftProjectsPageState();
}

class _DraftProjectsPageState extends State<DraftProjectsPage> {
  final _projects = <Project>[];
  final _limit = 10;

  bool _hasNext = true;
  bool _isLoading = false;

  DocumentSnapshot _lastDocumentSnapshot;

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
          header(context.tabsRouter),
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

  Widget header(TabsRouter tabsRouter) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.all(80.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: IconButton(
                  onPressed: context.router.pop,
                  icon: Icon(UniconsLine.arrow_left),
                ),
              ),
              headerSection(
                textTitle: "drafts".tr(),
                index: 0,
                tabsRouter: tabsRouter,
              ),
              headerSection(
                textTitle: "published".tr(),
                index: 1,
                tabsRouter: tabsRouter,
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget headerSection({
    @required String textTitle,
    @required int index,
    @required TabsRouter tabsRouter,
  }) {
    final isSelected = index == tabsRouter.activeIndex;

    return InkWell(
      onTap: () => tabsRouter.setActiveIndex(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.5,
          child: Text(
            textTitle,
            style: FontsUtils.mainStyle(
              fontSize: 40.0,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
            ),
          ),
        ),
      ),
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

          return ProjectCard(
            onTap: () => goToEditPage(project),
            popupMenuButton: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'delete':
                    delete(index);
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
            ),
            project: project,
          );
        },
        childCount: _projects.length,
      ),
    );
  }

  void fetch() async {
    setState(() {
      _projects.clear();
      _isLoading = true;
    });

    try {
      final userAuth = stateUser.userAuth;
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
      final userAuth = stateUser.userAuth;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('published', isEqualTo: false)
          .where('author.id', isEqualTo: uid)
          .startAfterDocument(_lastDocumentSnapshot)
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

  void delete(int index) async {
    setState(() => _isLoading = true);

    final removedProject = _projects.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(removedProject.id)
          .delete();

      setState(() => _isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _projects.insert(index, removedProject);
      });
    }
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

  Future goToEditPage(Project project) async {
    await context.router.push(
      EditProjectPageRoute(
        projectId: project.id,
      ),
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
}
