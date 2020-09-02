import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  @required final String id;

  PostPage({this.id});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String postData = '';
  bool isLoading = false;
  final scrollController = ScrollController();
  bool isTOCVisible = false;
  Post post;
  bool isFabVisible = false;

  final textWidth = 630.0;

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
                ? 'Post'
                : post.title,
              onPressedRightButton: () => setState(
                () => isTOCVisible = !isTOCVisible
              ),
            ),
            body(),
          ],
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
            Spacer(),
            markdownViewer(),
            Spacer(),
          ],
        ),
      ]),
    );
  }

  Widget loadingView() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
            ]
          ),
        ),
      ]),
    );
  }

  Widget markdownViewer() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 400.0),
        child: Html(
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
                width: double.parse(attributes['width'], (value) => 300.0),
                height: double.parse(attributes['height'], (value) => 300.0),
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
              fontSize: FontSize(50.0),
              fontWeight: FontWeight.w500,
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
                    }
                  );
                },
              ),
            )
          ),
        ),

        if (alt != null && alt.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: FlatButton(
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
        onTap: href != null && href.isNotEmpty
          ? () => launch(href)
          : null,
        child: child,
      ),
    );
  }

  void fetchMeta() async {
    try {
      final doc = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.id)
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
        functionName: 'fetchPost',
      );

      final response = await callable.call({'postId': widget.id});
      final markdownData = response.data['post'];

      postData = markdown.markdownToHtml(markdownData);
      // print(postData);

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
}
