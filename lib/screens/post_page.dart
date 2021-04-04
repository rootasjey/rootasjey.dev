import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/markdown_viewer.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/mesure_size.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:unicons/unicons.dart';
import 'package:supercharged/supercharged.dart';

class PostPage extends StatefulWidget {
  @required
  final String postId;

  PostPage({@PathParam() this.postId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLoading = false;
  bool isTOCVisible = false;
  bool isFabVisible = false;
  bool isNarrow = false;

  double pageHeight = 100.0;

  final incrOffset = 80.0;
  final scrollController = ScrollController();
  final textWidth = 750.0;

  FocusNode focusNode = FocusNode();

  Post post;

  String postData = '';

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
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: focusNode,
        onKey: onKey,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollNotif) {
            // FAB visibility
            if (scrollNotif.metrics.pixels < 50 && isFabVisible) {
              setState(() => isFabVisible = false);
            } else if (scrollNotif.metrics.pixels > 50 && !isFabVisible) {
              setState(() => isFabVisible = true);
            }

            return false;
          },
          child: Scrollbar(
            controller: scrollController,
            child: Focus(
              descendantsAreFocusable: false,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  HomeAppBar(
                    automaticallyImplyLeading: true,
                    title: post == null
                        ? Opacity(
                            opacity: 0.6,
                            child: Text(
                              "post".tr(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: stateColors.foreground,
                              ),
                            ),
                          )
                        : Opacity(
                            opacity: 0.6,
                            child: Text(
                              post.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: stateColors.foreground,
                              ),
                            ),
                          ),
                    trailing: [
                      IconButton(
                        color: stateColors.foreground,
                        icon: Icon(UniconsLine.bars),
                        onPressed: () =>
                            setState(() => isTOCVisible = !isTOCVisible),
                      ),
                    ],
                  ),

                  body(),

                  // Watch page's size.
                  // Can host share button.
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
          ),
        ),
      ),
    );
  }

  Widget body() {
    if (isLoading) {
      return loadingView();
    }

    return SliverList(
        delegate: SliverChildListDelegate([
      Row(
        children: [
          if (!isNarrow) Spacer(),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 400.0,
                left: 20.0,
                right: 20.0,
              ),
              child: MeasureSize(
                onChange: (size) {
                  pageHeight = size.height;
                },
                child: MarkdownViewer(
                  data: postData,
                  width: textWidth,
                ),
              ),
            ),
          ),
          if (!isNarrow) Spacer(),
        ],
      ),
    ]));
  }

  Widget loadingView() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircularProgressIndicator(),
            Opacity(
              opacity: 0.6,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                ),
                child: Text(
                  "loading".tr(),
                  style: FontsUtils.mainStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  void fetchMeta() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (!doc.exists) {
        return;
      }

      final data = doc.data();
      data['id'] = doc.id;

      setState(() {
        post = Post.fromJSON(data);
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void fetchContent() async {
    setState(() => isLoading = true);

    try {
      final response =
          await Cloud.fun('posts-fetch').call({'postId': widget.postId});
      final markdownData = response.data['post'];

      postData = markdown.markdownToHtml(markdownData);

      setState(() => isLoading = false);
    } catch (error) {
      setState(() => isLoading = false);
      debugPrint(error.toString());

      Snack.e(
        context: context,
        message: "post_fetch_error".tr(),
      );
    }
  }

  double getOffsetDown({bool altPressed = false}) {
    double factor = altPressed ? 3 : 1;

    final offset = scrollController.offset + incrOffset < pageHeight
        ? scrollController.offset + (incrOffset * factor)
        : pageHeight;

    return offset;
  }

  double getOffsetUp({bool altPressed = false}) {
    double factor = altPressed ? 3 : 1;

    final offset = scrollController.offset - incrOffset > 90.0
        ? scrollController.offset - (incrOffset * factor)
        : 0.0;

    return offset;
  }

  void onKey(keyEvent) {
    // ?NOTE: Keys combinations must stay on top
    // or other matching key events will override it.

    // home
    if (keyEvent.isMetaPressed &&
        keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      scrollController.animateTo(
        0,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // end
    if (keyEvent.isMetaPressed &&
        keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      scrollController.animateTo(
        pageHeight,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // up + alt
    if (keyEvent.isAltPressed &&
        keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      scrollController.animateTo(
        getOffsetUp(altPressed: true),
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // down + alt
    if (keyEvent.isAltPressed &&
        keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      scrollController.animateTo(
        getOffsetDown(altPressed: true),
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // up
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      scrollController.animateTo(
        getOffsetUp(),
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // down
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      scrollController.animateTo(
        getOffsetDown(),
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // space
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.space)) {
      scrollController.animateTo(
        getOffsetDown(altPressed: true),
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // backspace
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.backspace)) {
      if (context.router.root.stack.length < 2) {
        return;
      }

      context.router.pop();
      return;
    }

    // home
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.home)) {
      scrollController.animateTo(
        0,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // end
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.end)) {
      scrollController.animateTo(
        pageHeight,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }
  }
}
