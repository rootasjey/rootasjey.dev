import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/widget_config.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/snack.dart';

class PostPage extends StatefulWidget {
  @required final String id;

  PostPage({this.id});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String postData = '';
  bool isLoading = false;
  final postScroller = ScrollController();
  final tocController = TocController();
  bool isTOCVisible = false;
  Post post;
  bool isFabVisible = false;

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
          onPressed: () => tocController.jumpTo(index: 0),
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
      return SliverList(
        delegate: SliverChildListDelegate([
          Center(
            child: Text('Loading'),
          ),
        ]),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              MarkdownWidget(
                controller: tocController,
                childMargin: const EdgeInsets.only(
                  top: 40.0,
                ),
                widgetConfig: WidgetConfig(
                  p: (node) {
                    return Column(
                      children: node.children.map((childNode) {
                        if (childNode.textContent.contains("<img")) {
                          return imgElement(childNode.textContent);
                        }

                        if (childNode.textContent.contains("<spacing")) {
                          return spacingElement(childNode.textContent);
                        }

                        return SizedBox(
                          width: 630.0,
                          child: Text(
                            childNode.textContent,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w200,
                              height: 1.5,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                styleConfig: StyleConfig(
                  titleConfig: TitleConfig(
                    h1: TextStyle(
                      fontSize: 60.0,
                      fontWeight: FontWeight.w600,
                    ),
                    h2: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                    ),
                    h3: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w400,
                    ),
                    titleWrapper: (child) {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 630.0,
                              child: child,
                            ),
                          ],
                        ),
                      );
                    },
                    showDivider: false,
                  ),
                  ulConfig: UlConfig(
                    textStyle: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                      // height: 1.5,
                    ),
                    ulWrapper: (child) {
                      return SizedBox(
                        width: 630.0,
                        child: child,
                      );
                    },
                    dotMargin: const EdgeInsets.only(
                      top: 13.0,
                      right: 20.0,
                    ),
                  ),
                ),
                data: postData,
              ),

              tocElement(),
            ]
          ),
        ),
      ]),
    );
  }

  Widget tocElement() {
    if (!isTOCVisible) {
      return Padding(padding: EdgeInsets.zero,);
    }

    return Positioned(
      right: 0.0,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 260.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: TocListWidget(
          controller: tocController,
          // tocItem: (toc, isSelected) {
          //   return InkWell(
          //     onTap: () {},
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(
          //         vertical: 8.0,
          //         horizontal: 8.0,
          //       ),
          //       child: Text(toc.name),
          //     ),
          //   );
          // },
        ),
      ),
    );
  }

  Widget imgElement(String content) {
    final imgStartIndex = content.indexOf('src="') + 5;
    final imgEndIndex = content.indexOf('"', imgStartIndex);
    final src = content.substring(imgStartIndex, imgEndIndex);

    final altStartIndex = content.indexOf('alt="') + 5;
    final altEndIndex = content.indexOf('"', altStartIndex);
    final alt = content.substring(altStartIndex, altEndIndex);

    final widthStartIndex = content.indexOf('width="') + 7;
    final widthEndIndex = content.indexOf('"', widthStartIndex);
    final width = content.substring(widthStartIndex, widthEndIndex);

    final heightStartIndex = content.indexOf('height="') + 8;
    final heightEndIndex = content.indexOf('"', heightStartIndex);
    final height = content.substring(heightStartIndex, heightEndIndex);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 60.0,
      ),
      child: Column(
        children: [
          Card(
            elevation: 4.0,
            child: Ink.image(
              image: NetworkImage(src),
              width: double.parse(width, (value) => 300.0),
              height: double.parse(height, (value) => 300.0),
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
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
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
          )
        ],
      ),
    );
  }

  Widget spacingElement(String content) {
    final heightStartIndex = content.indexOf('height="') + 8;
    final heightEndIndex = content.indexOf('"', heightStartIndex);
    final height = content.substring(heightStartIndex, heightEndIndex);

    return Padding(
      padding: EdgeInsets.only(
        top: double.parse(height, (value) => 0.0),
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
      postData = response.data['post'];

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
