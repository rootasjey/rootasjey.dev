
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/screens/edit_project.dart';
import 'package:rootasjey/state/user_state.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/auth_guards.dart';

class DraftProjects extends StatefulWidget {
  @override
  _DraftProjectsState createState() => _DraftProjectsState();
}

class _DraftProjectsState extends State<DraftProjects> {
  final projectsList = List<Project>();
  final limit = 10;

  bool hasNext = true;
  bool isLoading = false;
  var lastDoc;

  int maxNavigationAttempts = 5;
  int navigationAttempts = 0;

  @override
  void initState() {
    super.initState();
    initAndCheck();
  }

  void initAndCheck() async {
    final result = await canNavigate(context: context);
    if (!result) { return; }

    fetch();
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
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return EditProject(
                      projectId: project.id,
                    );
                  },
                ),
              );

              fetch();
            },
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
                const PopupMenuItem(
                  value: 'publish',
                  child: ListTile(
                    leading: Icon(Icons.publish_outlined),
                    title: Text(
                      'Publish',
                      style: TextStyle(),
                    ),
                  ),
                ),

                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text(
                      'Delete',
                      style: TextStyle(),
                    ),
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

  void fetch() async {
    setState(() {
      projectsList.clear();
      isLoading = true;
    });

    try {
      final userAuth = await userState.userAuth;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
        .collection('projects')
        .where('published', isEqualTo: false)
        .where('author', isEqualTo: uid)
        .limit(limit)
        .get();

      if (snapshot.size == 0) {
        setState(() {
          hasNext = false;
          isLoading = false;
        });

        return;
      }

      lastDoc = snapshot.docs.last;

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        projectsList.add(Project.fromJSON(data));
      });

      setState(() {
        isLoading = false;
        hasNext = limit == snapshot.size;
      });

    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void delete(int index) async {
    setState(() => isLoading = true);

    final removedProject = projectsList.removeAt(index);

    try {
      await FirebaseFirestore.instance
        .collection('projects')
        .doc(removedProject.id)
        .delete();

      setState(() => isLoading = false);

    } catch (error) {
      debugPrint(error.toString());

      setState(() {
        projectsList.insert(index, removedProject);
      });
    }
  }

  void publish(int index) async {
    setState(() => isLoading = true);

    final removedProject = projectsList.removeAt(index);

    try {
      await FirebaseFirestore.instance
        .collection('projects')
        .doc(removedProject.id)
        .update({
          'published': true,
        });

      setState(() => isLoading = false);

    } catch (error) {
      debugPrint(error.toString());

      setState(() {
        projectsList.insert(index, removedProject);
      });
    }
  }
}
