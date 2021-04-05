import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/markdown_viewer.dart';
import 'package:rootasjey/components/sliver_loading_view.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';

class ProjectPage extends StatefulWidget {
  final String projectId;

  ProjectPage({@required @PathParam() this.projectId});

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool isFabVisible = false;
  bool isLoading = false;
  bool isNarrow = false;

  final scrollController = ScrollController();
  final textWidth = 800.0;

  Project project;
  String projectData = '';
  Timer timer;

  @override
  initState() {
    super.initState();
    fetchMeta();
    fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
              backgroundColor: stateColors.primary,
              foregroundColor: Colors.white,
              onPressed: () => scrollController.animateTo(
                0,
                duration: 250.milliseconds,
                curve: Curves.bounceOut,
              ),
              child: Icon(Icons.arrow_upward),
            )
          : Container(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotif) {
          // FAB visibility
          if (scrollNotif.metrics.pixels < 50 && isFabVisible) {
            setState(() => isFabVisible = false);
          } else if (scrollNotif.metrics.pixels > 50 && !isFabVisible) {
            setState(() => isFabVisible = true);
          }

          return false;
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            HomeAppBar(
              automaticallyImplyLeading: true,
              title: project == null
                  ? Opacity(
                      opacity: 0.6,
                      child: Text(
                        "project".tr(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: stateColors.foreground,
                        ),
                      ),
                    )
                  : Opacity(
                      opacity: 0.6,
                      child: Text(
                        project.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: stateColors.foreground,
                        ),
                      ),
                    ),
            ),
            body(),
            SliverLayoutBuilder(
              builder: (_, constraints) {
                final isNowNarrow = constraints.crossAxisExtent < 700.0;

                if (timer != null && timer.isActive) {
                  timer.cancel();
                }

                if (isNarrow != isNowNarrow) {
                  timer = Timer(
                    1.seconds,
                    () => setState(() => isNarrow = isNowNarrow),
                  );
                }

                return SliverPadding(padding: EdgeInsets.zero);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    if (isLoading) {
      return SliverLoadingView(
        title: "loading_project".tr(),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        Row(
          children: [
            if (!isNarrow) Spacer(),
            Expanded(
              flex: 3,
              child: MarkdownViewer(
                data: projectData,
                width: textWidth,
              ),
            ),
            if (!isNarrow) Spacer(),
          ],
        ),
      ]),
    );
  }

  void fetchMeta() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .get();

      if (!doc.exists) {
        return;
      }

      final data = doc.data();
      data['id'] = doc.id;

      setState(() {
        project = Project.fromJSON(data);
      });
    } catch (error) {
      appLogger.e(error);
    }
  }

  void fetchContent() async {
    setState(() => isLoading = true);

    try {
      final response = await Cloud.fun('projects-fetch')
          .call({'projectId': widget.projectId});

      final markdownData = response.data['project'];

      projectData = markdown.markdownToHtml(markdownData);

      setState(() => isLoading = false);
    } catch (error) {
      setState(() => isLoading = false);
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_fetch_error".tr(),
      );
    }
  }
}
