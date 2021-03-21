import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supercharged/supercharged.dart';

class PostPage extends StatefulWidget {
  @required
  final String postId;

  PostPage({this.postId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool isLoading = false;
  bool isTOCVisible = false;
  bool isFabVisible = false;
  bool isNarrow = false;

  final scrollController = ScrollController();
  final textWidth = 750.0;

  Post post;
  String postData = '';
  Timer timer;

  FocusNode focusNode = FocusNode();
  final keyForMarkdown = GlobalKey();
  double pageHeight = 0;
  final incrOffset = 80.0;

  @override
  initState() {
    super.initState();

    fetchMeta();
    fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: focusNode,
      onKey: (keyEvent) {
        // ?NOTE: Keys combinations must stay on top
        // or other matching key events will override it.
        // HOME
        if (keyEvent.isMetaPressed &&
            keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          scrollController.animateTo(
            0,
            duration: 100.milliseconds,
            curve: Curves.ease,
          );

          return;
        }

        // END
        if (keyEvent.isMetaPressed &&
            keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          scrollController.animateTo(
            pageHeight,
            duration: 100.milliseconds,
            curve: Curves.ease,
          );

          return;
        }

        // UP + ALT
        if (keyEvent.isAltPressed &&
            keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          scrollController.animateTo(
            getOffsetUp(altPressed: true),
            duration: 100.milliseconds,
            curve: Curves.ease,
          );

          return;
        }

        // DOWN + ALT
        if (keyEvent.isAltPressed &&
            keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          scrollController.animateTo(
            getOffsetDown(altPressed: true),
            duration: 100.milliseconds,
            curve: Curves.ease,
          );

          return;
        }

        // UP
        if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
          scrollController.animateTo(
            getOffsetUp(),
            duration: 100.milliseconds,
            curve: Curves.ease,
          );

          return;
        }

        // DOWN
        if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          scrollController.animateTo(
            getOffsetDown(),
            duration: 100.milliseconds,
            curve: Curves.ease,
          );

          return;
        }

        // LEFT
        if (keyEvent.isKeyPressed(LogicalKeyboardKey.backspace) ||
            keyEvent.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          Navigator.of(context).pop();
          return;
        }

        // HOME
        if (keyEvent.isKeyPressed(LogicalKeyboardKey.home)) {
          scrollController.animateTo(
            0,
            duration: 100.milliseconds,
            curve: Curves.ease,
          );

          return;
        }

        // END
        if (keyEvent.isKeyPressed(LogicalKeyboardKey.end)) {
          scrollController.animateTo(
            pageHeight,
            duration: 100.milliseconds,
            curve: Curves.ease,
          );

          return;
        }
      },
      child: Scaffold(
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
            : Padding(padding: EdgeInsets.zero),
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
                title: post == null
                    ? Opacity(
                        opacity: 0.6,
                        child: Text(
                          'Post',
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
                onPressedRightButton: () =>
                    setState(() => isTOCVisible = !isTOCVisible),
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
                      () {
                        setState(() => isNarrow = isNowNarrow);
                      },
                    );
                  }

                  return SliverPadding(padding: EdgeInsets.zero);
                },
              ),
            ],
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
            child: markdownViewer(),
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
                  'Loading...',
                  style: TextStyle(
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

  Widget markdownViewer() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 400.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Html(
        key: keyForMarkdown,
        data: postData,
        customRender: {
          'a': (context, child, attributes, element) {
            return textLink(
              href: attributes['href'],
              child: child,
            );
          },
          'img': (context, child, attributes, element) {
            return imageViewer(
              context: context.buildContext,
              src: attributes['src'],
              alt: attributes['alt'],
              width: double.tryParse(attributes['width']) ?? 300.0,
              height: double.tryParse(attributes['height']) ?? 300.0,
            );
          }
        },
        style: {
          'p': Style(
            width: textWidth,
            fontSize: FontSize(24.0),
            fontWeight: FontWeight.w200,
            lineHeight: 1.5,
            margin: EdgeInsets.only(
              top: 40.0,
              bottom: 20.0,
            ),
          ),
          'ul': Style(
            fontSize: FontSize(22.0),
            fontWeight: FontWeight.w300,
            lineHeight: 1.6,
          ),
          'img': Style(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 40.0,
              bottom: 20.0,
            ),
          ),
          'h1': Style(
            width: textWidth,
            fontSize: FontSize(60.0),
            fontWeight: FontWeight.w600,
            margin: EdgeInsets.only(
              top: 100.0,
              bottom: 60.0,
            ),
          ),
          'h2': Style(
            width: textWidth,
            fontSize: FontSize(40.0),
            fontWeight: FontWeight.w600,
            margin: EdgeInsets.only(
              top: 80.0,
              bottom: 40.0,
            ),
          ),
          'h3': Style(
            fontSize: FontSize(30.0),
            fontWeight: FontWeight.w400,
          ),
        },
      ),
    );
  }

  Widget imageViewer({
    @required BuildContext context,
    @required String src,
    @required String alt,
    @required double width,
    @required double height,
  }) {
    return Column(
      children: [
        Card(
          elevation: 4.0,
          child: SizedBox(
              height: 300.0,
              child: Ink.image(
                image: NetworkImage(src),
                width: width,
                height: height,
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            children: [
                              Image.network(src),
                            ],
                          );
                        });
                  },
                ),
              )),
        ),
        if (alt != null && alt.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: TextButton(
              onPressed: () => launch(src),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  alt,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget textLink({@required String href, @required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2.0,
        right: 2.0,
        bottom: 5.0,
      ),
      child: InkWell(
        onTap: href != null && href.isNotEmpty ? () => launch(href) : null,
        child: child,
      ),
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
      final callable = CloudFunctions(
        app: Firebase.app(),
        region: 'europe-west3',
      ).getHttpsCallable(
        functionName: 'posts-fetch',
      );

      final response = await callable.call({'postId': widget.postId});
      final markdownData = response.data['post'];

      postData = markdown.markdownToHtml(markdownData);

      setState(() => isLoading = false);
    } catch (error) {
      setState(() => isLoading = false);
      debugPrint(error.toString());

      showSnack(
        context: context,
        message: "Couldn't get post's content. Try again or contact us.",
        type: SnackType.error,
      );
    }
  }

  double getOffsetDown({bool altPressed = false}) {
    if (keyForMarkdown.currentContext != null) {
      final height = keyForMarkdown.currentContext.size.height;

      if (pageHeight != height) {
        pageHeight = height;
      }
    }

    double factor = altPressed ? 3 : 1;

    final offset = scrollController.offset + incrOffset < pageHeight
        ? scrollController.offset + (incrOffset * factor)
        : pageHeight;

    return offset;
  }

  double getOffsetUp({bool altPressed = false}) {
    double factor = altPressed ? 3 : 1;

    final offset = scrollController.offset - incrOffset > 90
        ? scrollController.offset - (incrOffset * factor)
        : 0;

    return offset;
  }
}
