import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/screens/edit_post.dart';
import 'package:rootasjey/state/user_state.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/auth_guards.dart';

class DraftPosts extends StatefulWidget {
  @override
  _DraftPostsState createState() => _DraftPostsState();
}

class _DraftPostsState extends State<DraftPosts> {
  final postsList = List<Post>();
  final limit = 10;

  bool hasNext = true;
  bool isLoading = false;
  var lastDoc;

  @override
  void initState() {
    super.initState();
    initAndCheck();
  }

  void initAndCheck() async {
    final result = await canNavigate(context: context);
    if (!result) { return; }

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
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return EditPost(
                      postId: post.id,
                    );
                  },
                ),
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
                const PopupMenuItem(
                  value: 'publish',
                  child: ListTile(
                    leading: Icon(Icons.publish_outlined),
                    title: Text(
                      'Publish',
                      style: TextStyle(),
                    ),
                  ),
                ),

                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text(
                      'Delete',
                      style: TextStyle(),
                    ),
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
      final userAuth = await userState.userAuth;
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
      debugPrint(error.toString());
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
      debugPrint(error.toString());

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
      debugPrint(error.toString());

      setState(() {
        postsList.insert(index, removedPost);
      });
    }
  }
}
