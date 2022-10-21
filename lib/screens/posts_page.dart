import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/components/min_post_card.dart';
import 'package:rootasjey/components/page_title.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/types/post.dart';

class PostsPage extends ConsumerStatefulWidget {
  const PostsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostsPageState();
}

class _PostsPageState extends ConsumerState<PostsPage> with UiLoggy {
  bool _isSmallView = false;
  bool _hasNext = true;
  bool _loading = false;

  DocumentSnapshot? _lastDoc;

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
    _isSmallView = viewWidth < Utilities.size.mobileWidthTreshold;

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: onNotification,
        child: CustomScrollView(
          slivers: [
            title(),
            body(),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget body() {
    Widget child;

    if (!_loading && _posts.isEmpty) {
      child = const SliverEmptyView();
    } else if (_isSmallView) {
      child = postsListView();
    } else {
      child = postsGridView();
    }

    return SliverPadding(
      padding: EdgeInsets.only(
        left: _isSmallView ? 20.0 : 80.0,
        right: 20.0,
        bottom: 100.0,
      ),
      sliver: child,
    );
  }

  Widget postsGridView() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360.0,
        childAspectRatio: 0.6,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts.elementAt(index);

          return PostCard(
            post: post,
            onTap: () => onGoToPost(post.id),
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
              MinPostCard(
                post: post,
                width: 420.0,
                onTap: () => onGoToPost(post.id),
              ),
              const Divider(height: 40.0),
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
            isLoading: _loading,
          ),
        ),
      ]),
    );
  }

  void fetch() async {
    setState(() {
      _posts.clear();
      _loading = true;
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
          _loading = false;
        });

        return;
      }

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        _posts.add(Post.fromJSON(data));
      }

      setState(() {
        _loading = false;
        _lastDoc = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  void fetchMore() async {
    if (!_hasNext || _loading || _lastDoc == null) {
      return;
    }

    setState(() => _loading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('published', isEqualTo: true)
          .startAfterDocument(_lastDoc!)
          .limit(_limit)
          .get();

      if (snapshot.size == 0) {
        setState(() {
          _hasNext = false;
          _loading = false;
        });

        return;
      }

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        _posts.add(Post.fromJSON(data));
      }

      setState(() {
        _loading = false;
        _lastDoc = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  void onGoToPost(String postId) {
    Beamer.of(context).beamToNamed(
      "${PostsLocation.route}/$postId",
      data: {'postId': postId},
    );
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
