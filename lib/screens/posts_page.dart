import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/main_app_bar.dart';
import 'package:rootasjey/components/min_pub_post_card.dart';
import 'package:rootasjey/components/page_title.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/constants.dart';

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  bool _isSmallView = false;
  bool _hasNext = true;
  bool _isLoading = false;

  DocumentSnapshot _lastDoc;

  final _posts = <Post>[];

  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    final viewWidth = MediaQuery.of(context).size.width;
    _isSmallView = viewWidth < Constants.maxMobileWidth;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child: CustomScrollView(
          slivers: [
            MainAppBar(),
            title(),
            SliverPadding(
              padding: EdgeInsets.only(
                left: _isSmallView ? 20.0 : 80.0,
                right: 20.0,
                bottom: 100.0,
              ),
              sliver: body(),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                Footer(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget body() {
    if (!_isLoading && _posts.isEmpty) {
      return SliverEmptyView();
    }

    if (_isSmallView) {
      return postsListView();
    }

    return postsGridView();
  }

  Widget postsGridView() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360.0,
        childAspectRatio: 0.6,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts.elementAt(index);

          return PostCard(
            post: post,
            onTap: () {
              context.router.push(
                PostsRouter(
                  children: [
                    PostPageRoute(
                      postId: post.id,
                    ),
                  ],
                ),
              );
            },
          );
        },
        childCount: _posts.length,
      ),
    );
  }

  Widget postsListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts.elementAt(index);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MinPubPostCard(post: post),
              Divider(height: 40.0),
            ],
          );
        },
        childCount: _posts.length,
      ),
    );
  }

  Widget title() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.only(
            left: _isSmallView ? 40.0 : 100.0,
            top: 90.0,
            bottom: 40.0,
          ),
          child: PageTitle(
            textTitle: "posts".tr(),
            isLoading: _isLoading,
          ),
        ),
      ]),
    );
  }

  void fetch() async {
    setState(() {
      _posts.clear();
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
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

        _posts.add(Post.fromJSON(data));
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
          .collection('posts')
          .where('published', isEqualTo: true)
          .startAfterDocument(_lastDoc)
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

        _posts.add(Post.fromJSON(data));
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
