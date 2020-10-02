import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/router//route_names.dart';
import 'package:rootasjey/router//router.dart';
import 'package:rootasjey/types/post.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final postsList = List<Post>();

  final largeHorizPadding   = 90.0;
  final narrowHorizPadding  = 20.0;
  final narrowWidthLimit    = 800.0;

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

              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: 90.0,
                    ),
                    child: headerTitle(),
                  ),
                ]),
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
    if (!isLoading && postsList.isEmpty) {
      return SliverEmptyView();
    }

    return postsListView();
  }

  Widget headerTitle() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => FluroRouter.router.pop(context),
            icon: Icon(Icons.arrow_back),
          ),
        ),

        Text(
          'Posts',
          style: TextStyle(
            fontSize: 70.0,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 22.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget postsListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = postsList.elementAt(index);

          return PostCard(
            onTap: () =>
              FluroRouter.router.navigateTo(
                context,
                PostRoute.replaceFirst(':postId', post.id),
              ),
            post: post,
          );
        },
        childCount: postsList.length,
      ),
    );
  }

  void fetch() async {
    setState(() {
      postsList.clear();
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('posts')
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

        postsList.add(Post.fromJSON(data));
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
