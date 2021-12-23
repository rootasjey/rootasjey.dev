import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/header_section.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/header_section_data.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/flash_helper.dart';
import 'package:unicons/unicons.dart';

class PublishedPostsPage extends StatefulWidget {
  @override
  _PublishedPostsPageState createState() => _PublishedPostsPageState();
}

class _PublishedPostsPageState extends State<PublishedPostsPage> {
  final _posts = <Post>[];
  final _limit = 10;

  bool _hasNext = true;
  bool _isLoading = false;

  DocumentSnapshot? _lastDocumentSnapshot;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              header(),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 90.0,
              right: 90.0,
              bottom: 300.0,
            ),
            sliver: body(),
          ),
        ],
      ),
    );
  }

  Widget body() {
    if (!_isLoading && _posts.isEmpty) {
      return SliverEmptyView();
    }

    return postsListView();
  }

  Widget header() {
    final String? currentPath = Beamer.of(context).currentPages.last.name;

    final List<HeaderSectionData> headerSectionData = [
      HeaderSectionData(
        titleValue: "drafts".tr(),
        path: DashboardLocationContent.draftPostsRoute,
      ),
      HeaderSectionData(
        titleValue: "published".tr(),
        path: DashboardLocationContent.publishedPostsRoute,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(
        80.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: IconButton(
              onPressed: Beamer.of(context).beamBack,
              icon: Icon(UniconsLine.arrow_left),
            ),
          ),
          ...headerSectionData.map(
            (data) => HeaderSection(
              titleValue: data.titleValue,
              onTap: _onTapHeaderSection,
              path: data.path,
              isSelected: data.path == currentPath,
            ),
          ),
        ],
      ),
    );
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
                  case 'delete':
                    confirmDeletePost(index);
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
        childCount: _posts.length,
      ),
    );
  }

  void confirmDeletePost(int index) {
    FlashHelper.deleteDialog(
      context,
      message: "post_delete_description".tr(),
      onConfirm: () async {
        deletePost(index);
      },
    );
  }

  void deletePost(int index) async {
    setState(() => _isLoading = true);

    final removedPost = _posts.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(removedPost.id)
          .delete();
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _posts.insert(index, removedPost);
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void fetch() async {
    setState(() {
      _posts.clear();
      _isLoading = true;
    });

    try {
      final userAuth = stateUser.userAuth!;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('published', isEqualTo: true)
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
      final userAuth = stateUser.userAuth!;
      final uid = userAuth.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('published', isEqualTo: true)
          .where('author.id', isEqualTo: uid)
          .limit(_limit)
          .startAfterDocument(_lastDocumentSnapshot!)
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

  void goToEditPostPage(Post post) async {
    Beamer.of(context).beamToNamed(
      "${DashboardLocationContent.editPostsRoute}/${post.id}",
      data: {"postId": post.id},
    );

    fetch();
  }

  bool onNotification(ScrollNotification scrollNotification) {
    final double current = scrollNotification.metrics.pixels;
    final double max = scrollNotification.metrics.maxScrollExtent;

    if (current < max - 300.0) {
      return false;
    }

    fetchMore();
    return false;
  }

  void unpublish(int index) async {
    setState(() => _isLoading = true);

    final removedPost = _posts.removeAt(index);

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(removedPost.id)
          .update({
        'published': false,
      });

      setState(() => _isLoading = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _posts.insert(index, removedPost);
      });
    }
  }

  void viewOnline(Post post) {
    Beamer.of(context).beamToNamed(
      "${PostsLocation.route}/${post.id}",
      data: {"postId": post.id},
    );
  }

  void _onTapHeaderSection(String path) {
    Beamer.of(context).beamToNamed(path);
  }
}
