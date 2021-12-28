import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/footer/footer.dart';
import 'package:rootasjey/components/application_bar/main_app_bar.dart';
import 'package:rootasjey/components/page_title.dart';
import 'package:rootasjey/components/project_card/project_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/constants.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final _projects = <Project>[];

  final _largeHorizPadding = 90.0;
  final _narrowHorizPadding = 20.0;

  final _limit = 10;
  bool _hasNext = true;
  bool _isLoading = false;
  DocumentSnapshot? _lastDoc;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child: CustomScrollView(
          slivers: [
            MainAppBar(),
            header(),
            body(),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget body() {
    Widget child;

    if (_isLoading || _projects.isEmpty) {
      child = SliverEmptyView();
    } else {
      child = projectsGrid();
    }

    final padding = MediaQuery.of(context).size.width < Constants.maxMobileWidth
        ? _narrowHorizPadding
        : _largeHorizPadding;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: 90.0,
      ),
      sliver: child,
    );
  }

  Widget footer() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Footer(),
      ]),
    );
  }

  Widget header() {
    final padding = MediaQuery.of(context).size.width < Constants.maxMobileWidth
        ? _narrowHorizPadding
        : _largeHorizPadding;

    return SliverPadding(
      padding: EdgeInsets.only(
        left: padding,
        right: padding,
        top: 90.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          PageTitle(
            textTitle: "projects".tr(),
            isLoading: _isLoading,
          ),
        ]),
      ),
    );
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
          final project = _projects.elementAt(index);

          return ProjectCard(
            project: project,
            onTap: () {
              Beamer.of(context).beamToNamed(
                "${ProjectsLocation.route}/${project.id}",
                data: {"projectId": project.id},
              );
            },
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
        _lastDoc = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      appLogger.e(error);
    }
  }

  void fetchMore() async {
    if (!_hasNext || _isLoading || _lastDoc == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .where('published', isEqualTo: true)
          .startAfterDocument(_lastDoc!)
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
        _lastDoc = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      appLogger.e(error);
    }
  }

  bool onNotification(ScrollNotification notification) {
    final double current = notification.metrics.pixels;
    final double max = notification.metrics.maxScrollExtent;

    if (current < max - 300.0) {
      return false;
    }

    fetchMore();
    return false;
  }
}
