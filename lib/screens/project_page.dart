import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/markdown_viewer.dart';
import 'package:rootasjey/components/sliver_loading_view.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/keybindings.dart';
import 'package:rootasjey/utils/mesure_size.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectPage extends StatefulWidget {
  final String projectId;

  ProjectPage({@required @PathParam() this.projectId});

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool _isFabVisible = false;
  bool _isLoading = false;

  final _scrollController = ScrollController();
  final double _textWidth = 800.0;

  final _focusNode = FocusNode();

  KeyBindings _keyBindings = KeyBindings();

  Project _project;
  String _projectData = '';

  @override
  initState() {
    super.initState();
    fetchMeta();
    fetchContent();

    // Delay initialization.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _keyBindings.init(
        scrollController: _scrollController,
        pageHeight: 100.0,
        router: context.router,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: fab(),
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKey: _keyBindings.onKey,
        child: NotificationListener<ScrollNotification>(
          onNotification: onNotification,
          child: Scrollbar(
            controller: _scrollController,
            child: Focus(
              descendantsAreFocusable: false,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  appBar(),
                  body(),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      bottom: 400.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget allChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 16.0,
          children: [
            tags(),
            links(),
            programmingLang(),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return HomeAppBar(
      automaticallyImplyLeading: true,
      title: Opacity(
        opacity: 0.6,
        child: Text(
          _project != null ? _project.title : "project".tr(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: stateColors.foreground,
          ),
        ),
      ),
    );
  }

  Widget author() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24.0,
        bottom: 28.0,
      ),
      child: Row(
        children: [
          Hero(
            tag: 'pp',
            child: BetterAvatar(
              size: 60.0,
              image: AssetImage(
                'assets/images/jeje.jpg',
              ),
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(opacity: 0.8, child: Text("Jérémie CORPINOT")),
                Opacity(opacity: 0.4, child: Text("Dev web & mobile")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    if (_isLoading) {
      return SliverLoadingView(
        title: "loading_project".tr(),
        padding: const EdgeInsets.only(top: 200.0),
      );
    }

    final bool isNarrow = MediaQuery.of(context).size.width < 500.0;

    return SliverList(
      delegate: SliverChildListDelegate([
        Row(
          children: [
            if (!isNarrow) Spacer(),
            bodyCentered(),
            if (!isNarrow) Spacer(),
          ],
        ),
      ]),
    );
  }

  Widget bodyCentered() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: MeasureSize(
          onChange: (size) {
            _keyBindings.updatePageHeight(size.height);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title(),
              summary(),
              dates(),
              allChips(),
              author(),
              MarkdownViewer(
                data: _projectData,
                width: _textWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dates() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 12.0,
          children: [
            Opacity(
              opacity: 0.7,
              child: Icon(UniconsLine.clock),
            ),
            Opacity(
              opacity: 0.5,
              child: Text(
                "created:",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Text(
                Jiffy(_project.createdAt).fromNow(),
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
              child: VerticalDivider(
                thickness: 2.0,
                color: stateColors.primary,
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Text(
                "updated:",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Text(
                Jiffy(_project.updatedAt).fromNow(),
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fab() {
    if (!_isFabVisible) {
      return Container();
    }

    return FloatingActionButton(
      backgroundColor: stateColors.primary,
      foregroundColor: Colors.white,
      onPressed: () => _scrollController.animateTo(
        0,
        duration: 250.milliseconds,
        curve: Curves.bounceOut,
      ),
      child: Icon(Icons.arrow_upward),
    );
  }

  Widget links() {
    final chips = <InputChip>[];

    _project.urls.map.forEach((name, value) {
      if (value.isNotEmpty) {
        chips.add(
          InputChip(
            label: Text(name),
            tooltip: "Link",
            side: BorderSide(
              color: stateColors.secondary,
              width: 1.5,
            ),
            onPressed: () {
              launch(value);
            },
          ),
        );
      }
    });

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: chips,
    );
  }

  Widget programmingLang() {
    return Wrap(
      spacing: 8.0,
      children: _project.programmingLanguages
          .map(
            (pLang) => Tooltip(
              message: "Programming language",
              child: Chip(
                label: Text(pLang),
                side: BorderSide(
                  color: Colors.pink,
                  width: 1.5,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget summary() {
    return Align(
      alignment: Alignment.topLeft,
      child: Opacity(
        opacity: 0.7,
        child: Text(
          _project.summary,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget tags() {
    return Wrap(
      spacing: 8.0,
      children: _project.tags
          .map(
            (tag) => Tooltip(
              message: "Tag",
              child: Chip(
                label: Text(tag),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          _project.title,
          style: FontsUtils.mainStyle(
            fontSize: 60.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
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
        _project = Project.fromJSON(data);
      });
    } catch (error) {
      appLogger.e(error);
    }
  }

  void fetchContent() async {
    setState(() => _isLoading = true);

    try {
      final response = await Cloud.fun('projects-fetch')
          .call({'projectId': widget.projectId});

      final markdownData = response.data['project'];

      _projectData = markdown.markdownToHtml(markdownData);

      setState(() => _isLoading = false);
    } catch (error) {
      setState(() => _isLoading = false);
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_fetch_error".tr(),
      );
    }
  }

  bool onNotification(ScrollNotification notification) {
    // FAB visibility
    if (notification.metrics.pixels < 50 && _isFabVisible) {
      setState(() => _isFabVisible = false);
    } else if (notification.metrics.pixels > 50 && !_isFabVisible) {
      setState(() => _isFabVisible = true);
    }

    return false;
  }
}
