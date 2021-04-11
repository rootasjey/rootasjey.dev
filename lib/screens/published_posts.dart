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

class PublishedPosts extends StatefulWidget {
  @override
  _PublishedPostsState createState() => _PublishedPostsState();
}

class _PublishedPostsState extends State<PublishedPosts> {
  final postsList = <Post>[];
  final limit = 10;

  bool hasNext = true;
  bool isLoading = false;

  DocumentSnapshot _lastDocumentSnapshot;

  ReactionDisposer _scrollReaction;

  @override
  void initState() {
    super.initState();
    fetch();

    _scrollReaction = reaction(
      (_) => statePubPostsScroll.hasReachedEnd,
      (hasReachedEnd) {
        if (hasReachedEnd && !isLoading && hasNext) {
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
    if (!isLoading && postsList.isEmpty) {
      return SliverEmptyView();
    }

    return postsListView();
  }

  Widget postsListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final post = postsList.elementAt(index);

          return PostCard(
            onTap: () => goToEditPostPage(post),
            popupMenuButton: PopupMenuButton<String>(
              icon: Icon(UniconsLine.ellipsis_v),
              onSelected: (value) {
                switch (value) {
                  case 'delete':
                    showDeleteDialog(index);
                    break;
                  case 'edit':
                    goToEditPostPage(post);
                    break;
                  case 'unpublish':
                    unpublish(index);
                    break;
                  case 'view_online':
                    viewOnline(post);
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
                  value: 'view_online',
                  child: ListTile(
                    leading: Icon(UniconsLine.eye),
                    title: Text(
                      "view_online".tr(),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'unpublish',
                  child: ListTile(
                    leading: Icon(UniconsLine.cloud_times),
                    title: Text("unpublish".tr()),
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
        childCount: postsList.length,
      ),
    );
  }

  void showDeleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("are_you_sure".tr()),
            content: SingleChildScrollView(
              child: Opacity(
                opacity: 0.6,
                child: Text("action_irreversible".tr()),
              ),
            ),
            actions: [
              TextButton(
                onPressed: context.router.pop,
                child: Text(
                  "canel".tr().toUpperCase(),
                  textAlign: TextAlign.end,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.router.pop();
                  delete(index);
                },
                child: Text(
                  "delete".tr().toUpperCase(),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void fetch() async {
    setState(() {
      postsList.clear();
      isLoading = true;
    });

    try {
      final userAuth = stateUser.userAuth;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('published', isEqualTo: true)
          .where('author', isEqualTo: uid)
          .limit(limit)
          .get();

      if (snapshot.size == 0) {
        setState(() {
          hasNext = false;
          isLoading = false;
        });

        return;
      }

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        postsList.add(Post.fromJSON(data));
      });

      setState(() {
        isLoading = false;
        hasNext = limit == snapshot.size;
        _lastDocumentSnapshot = snapshot.docs.last;
      });
    } catch (error) {
      appLogger.e(error);
      setState(() => isLoading = false);
    }
  }

  void fetchMore() async {
    if (_lastDocumentSnapshot == null || !hasNext || isLoading) {
      return;
    }

    setState(() => isLoading = true);

    try {
      final userAuth = stateUser.userAuth;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('published', isEqualTo: true)
          .where('author', isEqualTo: uid)
          .limit(limit)
          .startAfterDocument(_lastDocumentSnapshot)
          .get();

      if (snapshot.size == 0) {
        setState(() {
          hasNext = false;
          isLoading = false;
        });

        return;
      }

      snapshot.docs.forEach((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        postsList.add(Post.fromJSON(data));
      });

      setState(() {
        isLoading = false;
        hasNext = limit == snapshot.size;
        _lastDocumentSnapshot = snapshot.docs.last;
      });
    } catch (error) {
      appLogger.e(error);
      setState(() => isLoading = false);
    }
  }

  void delete(int index) async {
    setState(() => isLoading = true);

    final removedPost = postsList.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(removedPost.id)
          .delete();

      setState(() => isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        postsList.insert(index, removedPost);
      });
    }
  }

  void unpublish(int index) async {
    setState(() => isLoading = true);

    final removedPost = postsList.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(removedPost.id)
          .update({
        'published': false,
      });

      setState(() => isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        postsList.insert(index, removedPost);
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

  void viewOnline(Post post) {
    context.router.root.push(
      PostsDeepRoute(
        children: [
          PostPageRoute(postId: post.id),
        ],
      ),
    );
  }
}
