import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/page_title.dart';
import 'package:rootasjey/components/project_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/types/project.dart';

class Projects extends StatefulWidget {
  @override
  _ProjectsState createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  final projectsList = <Project>[];

  final largeHorizPadding = 90.0;
  final narrowHorizPadding = 20.0;
  final narrowWidthLimit = 800.0;

  final limit = 10;
  bool hasNext = true;
  bool isLoading = false;
  var lastDoc;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(),
          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < narrowWidthLimit
                  ? narrowHorizPadding
                  : largeHorizPadding;

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: 90.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    PageTitle(
                      textTitle: "projects".tr(),
                      isLoading: isLoading,
                    ),
                  ]),
                ),
              );
            },
          ),
          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < narrowWidthLimit
                  ? narrowHorizPadding
                  : largeHorizPadding;

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                  vertical: 90.0,
                ),
                sliver: body(),
              );
            },
          ),
        ],
      ),
    );
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
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final project = projectsList.elementAt(index);

          return ProjectCard(
            project: project,
            onTap: () {
              context.router.push(
                ProjectPageRoute(projectId: project.id),
              );
            },
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
}
