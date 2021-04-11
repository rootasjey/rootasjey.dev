import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/scroll.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:unicons/unicons.dart';

class PublishedProjects extends StatefulWidget {
  @override
  _PublishedProjectsState createState() => _PublishedProjectsState();
}

class _PublishedProjectsState extends State<PublishedProjects> {
  final projectsList = <Project>[];
  final limit = 10;

  bool hasNext = true;
  bool isLoading = false;

  DocumentSnapshot _lastDocumentSnapshot;

  ReactionDisposer _scrollReaction;

  @override
  void initState() {
    super.initState();
    fetch();

    _scrollReaction = reaction(
      (_) => statePubProjectsScroll.hasReachEnd,
      (bool hasReachedEnd) {
        if (hasReachedEnd && hasNext) {
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
    return body();
  }

  Widget body() {
    if (!isLoading && projectsList.isEmpty) {
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
          final project = projectsList.elementAt(index);

          return ProjectCard(
            onTap: () {
              context.router.push(
                DeepEditPage(
                  children: [
                    EditProjectRoute(
                      projectId: project.id,
                    )
                  ],
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
        childCount: projectsList.length,
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
      projectsList.clear();
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('published', isEqualTo: true)
          .limit(limit)
          .get();

      if (snapshot.size == 0) {
        setState(() {
          hasNext = false;
          isLoading = false;
        });

        return;
      }

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        projectsList.add(Project.fromJSON(data));
      });

      setState(() {
        isLoading = false;
        hasNext = limit == snapshot.size;
        _lastDocumentSnapshot = snapshot.docs.last;
      });
    } catch (error) {
      appLogger.e(error);
      setState(() => isLoading = false);
    }
  }

  void fetchMore() async {
    if (!hasNext || _lastDocumentSnapshot == null) {
      return;
    }

    setState(() => isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('published', isEqualTo: true)
          .limit(limit)
          .startAfterDocument(_lastDocumentSnapshot)
          .get();

      if (snapshot.size == 0) {
        setState(() {
          hasNext = false;
          isLoading = false;
        });

        return;
      }

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        projectsList.add(Project.fromJSON(data));
      });

      setState(() {
        isLoading = false;
        hasNext = limit == snapshot.size;
        _lastDocumentSnapshot = snapshot.docs.last;
      });
    } catch (error) {
      appLogger.e(error);
      setState(() => isLoading = false);
    }
  }

  void delete(int index) async {
    setState(() => isLoading = true);

    final removedPost = projectsList.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(removedPost.id)
          .delete();

      setState(() => isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        projectsList.insert(index, removedPost);
      });
    }
  }

  void unpublish(int index) async {
    setState(() => isLoading = true);

    final removedPost = projectsList.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(removedPost.id)
          .update({
        'published': false,
      });

      setState(() => isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        projectsList.insert(index, removedPost);
      });
    }
  }

  void goToEditPage(Project project) async {
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

  void viewOnline(Project project) {
    context.router.root.push(
      ProjectsDeepRoute(
        children: [
          ProjectPageRoute(projectId: project.id),
        ],
      ),
    );
  }
}
