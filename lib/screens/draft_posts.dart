import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/app_logger.dart';

class DraftPosts extends StatefulWidget {
  @override
  _DraftPostsState createState() => _DraftPostsState();
}

class _DraftPostsState extends State<DraftPosts> {
  final postsList = <Post>[];
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
            onTap: () async {
              await context.router.push(
                EditPostRoute(postId: post.id),
              );

              fetch();
            },
            popupMenuButton: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
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
                  value: 'publish',
                  child: ListTile(
                    leading: Icon(Icons.publish_outlined),
                    title: Text("publish".tr()),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
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
          .where('published', isEqualTo: false)
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
      appLogger.e(error);
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

  void publish(int index) async {
    setState(() => isLoading = true);

    final removedPost = postsList.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(removedPost.id)
          .update({
        'published': true,
      });

      setState(() => isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        postsList.insert(index, removedPost);
      });
    }
  }
}
