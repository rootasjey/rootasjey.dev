import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/scroll.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:unicons/unicons.dart';

class DraftPosts extends StatefulWidget {
  @override
  _DraftPostsState createState() => _DraftPostsState();
}

class _DraftPostsState extends State<DraftPosts> {
  final _posts = <Post>[];
  final _limit = 10;

  bool _hasNext = true;
  bool _isLoading = false;

  DocumentSnapshot _lastDocumentSnapshot;

  ReactionDisposer _scrollReaction;

  @override
  void initState() {
    super.initState();
    fetch();

    _scrollReaction = reaction(
      (_) => stateDraftPostsScroll.hasReachedEnd,
      (hasReachedEnd) {
        if (hasReachedEnd && !_isLoading && _hasNext) {
          fetchMore();
        }
      },
    );
  }

  @override
  dispose() {
    _scrollReaction.reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body() {
    if (!_isLoading && _posts.isEmpty) {
      return SliverEmptyView();
    }

    return postsListView();
  }

  Widget postsListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = _posts.elementAt(index);

          return PostCard(
            onTap: () => goToEditPostPage(post),
            popupMenuButton: PopupMenuButton<String>(
              icon: Icon(UniconsLine.ellipsis_v),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    goToEditPostPage(post);
                    break;
                  case 'delete':
                    delete(index);
                    break;
                  case 'publish':
                    publish(index);
                    break;
                  default:
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(UniconsLine.edit),
                    title: Text("edit".tr()),
                  ),
                ),
                PopupMenuItem(
                  value: 'publish',
                  child: ListTile(
                    leading: Icon(UniconsLine.cloud_upload),
                    title: Text("publish".tr()),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(UniconsLine.trash),
                    title: Text("delete".tr()),
                  ),
                ),
              ],
            ),
            post: post,
            padding: const EdgeInsets.only(bottom: 20.0),
          );
        },
        childCount: _posts.length,
      ),
    );
  }

  void fetch() async {
    setState(() {
      _posts.clear();
      _isLoading = true;
    });

    try {
      final userAuth = stateUser.userAuth;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('published', isEqualTo: false)
          .where('author.id', isEqualTo: uid)
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
        _hasNext = _limit == snapshot.size;
        _lastDocumentSnapshot = snapshot.docs.last;
      });
    } catch (error) {
      appLogger.e(error);
      setState(() => _isLoading = false);
    }
  }

  void fetchMore() async {
    if (_lastDocumentSnapshot == null || !_hasNext || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userAuth = stateUser.userAuth;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('published', isEqualTo: false)
          .where('author.id', isEqualTo: uid)
          .limit(_limit)
          .startAfterDocument(_lastDocumentSnapshot)
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
        _hasNext = _limit == snapshot.size;
        _lastDocumentSnapshot = snapshot.docs.last;
      });
    } catch (error) {
      appLogger.e(error);
      setState(() => _isLoading = false);
    }
  }

  void delete(int index) async {
    setState(() => _isLoading = true);

    final removedPost = _posts.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(removedPost.id)
          .delete();

      setState(() => _isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _posts.insert(index, removedPost);
      });
    }
  }

  void goToEditPostPage(Post post) async {
    await context.router.push(
      DeepEditPage(
        children: [
          EditPostRoute(postId: post.id),
        ],
      ),
    );

    fetch();
  }

  void publish(int index) async {
    setState(() => _isLoading = true);

    final removedPost = _posts.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(removedPost.id)
          .update({
        'published': true,
      });

      setState(() => _isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _posts.insert(index, removedPost);
      });
    }
  }
}
