import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/markdown_viewer.dart';
import 'package:rootasjey/components/sliver_loading_view.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/keybindings.dart';
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

  final double incrOffset = 80.0;
  final double textWidth = 750.0;
  final scrollController = ScrollController();

  FocusNode focusNode = FocusNode();

  KeyBindings _keyBindings = KeyBindings();

  Post post;

  String postData = '';

  Timer timer;

  @override
  initState() {
    super.initState();

    fetchMeta();
    fetchContent();

    // Delay initialization.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _keyBindings.init(
        scrollController: scrollController,
        pageHeight: 100.0,
        router: context.router,
      );
    });
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
        onKey: _keyBindings.onKey,
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
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 400.0),
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
      return SliverLoadingView(
        title: "loading_post".tr(),
      );
    }

    final bool isNarrow = MediaQuery.of(context).size.width < 500.0;

    return SliverList(
      delegate: SliverChildListDelegate([
        Row(
          children: [
            if (!isNarrow) Spacer(),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: MeasureSize(
                  onChange: (size) {
                    _keyBindings.updatePageHeight(size.height);
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
}
