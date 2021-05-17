import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class PublishedProjectsPage extends StatefulWidget {
  @override
  _PublishedProjectsPageState createState() => _PublishedProjectsPageState();
}

class _PublishedProjectsPageState extends State<PublishedProjectsPage> {
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
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              header(context.tabsRouter),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 80.0,
            ),
            sliver: body(),
          ),
        ],
      ),
    );
  }

  Widget body() {
    if (!_isLoading && _projects.isEmpty) {
      return SliverEmptyView();
    }

    return projectsGrid();
  }

  Widget header(TabsRouter tabsRouter) {
    return Padding(
      padding: const EdgeInsets.all(
        80.0,
      ),
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
            onTap: () {
              context.router.push(
                EditProjectPageRoute(
                  projectId: project.id,
                ),
              );
            },
            popupMenuButton: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'delete':
                    showDeleteDialog(index);
                    break;
                  case 'edit':
                    goToEditPage(project);
                    break;
                  case 'unpublish':
                    unpublish(index);
                    break;
                  case 'view_online':
                    viewOnline(project);
                    break;
                  default:
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(UniconsLine.edit),
                    title: Text("edit".tr()),
                  ),
                ),
                PopupMenuItem(
                  value: 'view_online',
                  child: ListTile(
                    leading: Icon(UniconsLine.eye),
                    title: Text(
                      "view_online".tr(),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'unpublish',
                  child: ListTile(
                    leading: Icon(UniconsLine.eye_slash),
                    title: Text(
                      "unpublish".tr(),
                    ),
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

  void showDeleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("are_you_sure".tr()),
            content: SingleChildScrollView(
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  "action_irreversible".tr(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: context.router.pop,
                child: Text(
                  "cancel".tr().toUpperCase(),
                  textAlign: TextAlign.end,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  delete(index);
                },
                child: Text(
                  "delete".tr().toUpperCase(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void fetch() async {
    setState(() {
      _projects.clear();
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('published', isEqualTo: true)
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
      setState(() => _isLoading = false);
    }
  }

  void fetchMore() async {
    if (_lastDocumentSnapshot == null || !_hasNext || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('published', isEqualTo: true)
          .limit(_limit)
          .startAfterDocument(_lastDocumentSnapshot)
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
      setState(() => _isLoading = false);
    }
  }

  void delete(int index) async {
    setState(() => _isLoading = true);

    final removedPost = _projects.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(removedPost.id)
          .delete();

      setState(() => _isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _projects.insert(index, removedPost);
      });
    }
  }

  void unpublish(int index) async {
    setState(() => _isLoading = true);

    final removedPost = _projects.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(removedPost.id)
          .update({
        'published': false,
      });

      setState(() => _isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _projects.insert(index, removedPost);
      });
    }
  }

  void goToEditPage(Project project) async {
    await context.router.push(
      EditProjectPageRoute(
        projectId: project.id,
      ),
    );

    fetch();
  }

  void viewOnline(Project project) {
    context.router.root.push(
      ProjectsRouter(
        children: [
          ProjectPageRoute(
            projectId: project.id,
          ),
        ],
      ),
    );
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
