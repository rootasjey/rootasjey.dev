import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/scroll.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:unicons/unicons.dart';

class DraftProjects extends StatefulWidget {
  const DraftProjects({Key key}) : super(key: key);

  @override
  _DraftProjectsState createState() => _DraftProjectsState();
}

class _DraftProjectsState extends State<DraftProjects> {
  final _projects = <Project>[];
  final _limit = 10;

  bool _hasNext = true;
  bool _isLoading = false;

  DocumentSnapshot _lastDocumentSnapshot;

  ReactionDisposer _scrollReaction;

  @override
  void initState() {
    super.initState();
    fetch();

    _scrollReaction = reaction(
      (_) => stateDraftProjectsScroll.hasReachedEnd,
      (bool hasReachedEnd) {
        if (hasReachedEnd && !_isLoading && _hasNext) {
          fetchMore();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollReaction.reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _projects.isEmpty) {
      return SliverEmptyView();
    }

    return projectsGrid();
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
          .where('author', isEqualTo: uid)
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
          .where('author', isEqualTo: uid)
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
      DeepEditPage(
        children: [
          EditProjectRoute(
            projectId: project.id,
          )
        ],
      ),
    );

    fetch();
  }
}
