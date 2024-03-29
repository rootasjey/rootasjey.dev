import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_icon.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/posts_page/create_post_page.dart';
import 'package:rootasjey/screens/posts_page/posts_page_body.dart';
import 'package:rootasjey/screens/posts_page/posts_page_empty_view.dart';
import 'package:rootasjey/types/alias/firestore/document_change_map.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_post_item_action.dart';
import 'package:rootasjey/types/enums/enum_signal_id.dart';
import 'package:rootasjey/types/intents/escape_intent.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/types/user/user_firestore.dart';
import 'package:rootasjey/types/user/user_rights.dart';

/// A page widget showing posts.
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with UiLoggy {
  /// True if there're more posts to fetch.
  bool _hasNext = true;

  /// True if the page is fetching posts.
  bool _loading = false;

  /// True if we're try to create a new post.
  bool _creating = false;

  /// If true, show a specific UI to create a post.
  bool _showCreatePage = false;

  /// Last document fetched from Firestore.
  DocumentSnapshot? _lastDocument;

  /// Maximum posts fetch per page.
  final int _limit = 10;

  /// Project list. This is the main page content.
  final List<Post> _posts = [];

  /// Listens to posts' updates.
  QuerySnapshotStreamSubscription? _postSubscription;

  /// Popup menu items for post card.
  final List<PopupMenuEntry<EnumPostItemAction>> _postPopupMenuItems = [
    PopupMenuItemIcon(
      icon: const PopupMenuIcon(TablerIcons.trash),
      textLabel: "delete".tr(),
      newValue: EnumPostItemAction.delete,
      selected: false,
    ),
  ];

  /// Firestore collection name.
  final String _collectionName = "posts";

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  void dispose() {
    _postSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);

    final UserRights userRights = signalUserFirestore.value.rights;
    final bool canManagePosts = userRights.managePosts;

    if (_showCreatePage) {
      return CreatePostPage(
        onCancel: () {
          setState(() => _showCreatePage = false);
        },
        onSubmit: (String name, String summary) {
          _showCreatePage = false;
          tryCreatePost(
            name: name,
            summary: summary,
          );
        },
      );
    }

    if (_creating) {
      return LoadingView.scaffold(
        message: _creating ? "post_creating".tr() : "posts_loading",
      );
    }

    if (_posts.isEmpty) {
      return wrapWithShortcuts(
        child: PostsPageEmptyView(
          canCreate: canManagePosts,
          fab: fab(show: canManagePosts),
          onShowCreatePage: onShowCreate,
          onCancel: () => Utils.passage.back(context),
        ),
      );
    }

    final Size windowSize = MediaQuery.of(context).size;

    return wrapWithShortcuts(
      child: PostsPageBody(
        canManage: canManagePosts,
        fab: fab(show: canManagePosts),
        posts: _posts,
        postPopupMenuItems: _postPopupMenuItems,
        onTapPost: onTapPost,
        onPopupMenuItemSelected: onPopupMenuItemSelected,
        windowSize: windowSize,
      ),
    );
  }

  Widget fab({required bool show}) {
    if (!show) {
      return Container();
    }

    return FloatingActionButton.extended(
      backgroundColor: Colors.amber,
      onPressed: onShowCreate,
      icon: const Icon(TablerIcons.plus),
      label: Text(
        "post_create".tr(),
        style: Utils.calligraphy.body(
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Wrap the target widget with keyboard shortcuts.
  Widget wrapWithShortcuts({required Widget child}) {
    const shortcuts = <SingleActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.escape): EscapeIntent(),
    };

    final actions = <Type, Action<Intent>>{
      EscapeIntent: CallbackAction(
        onInvoke: (Intent intent) => Utils.passage.back(context),
      ),
    };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }

  void onShowCreate() {
    setState(() => _showCreatePage = true);
  }

  /// Make a API request call to create a new document in Firestore
  /// and suitable files in Storage.
  void tryCreatePost({
    required String name,
    required String summary,
  }) async {
    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);

    final String userId = signalUserFirestore.value.id;
    if (userId.isEmpty) return;
    setState(() => _creating = true);

    try {
      // final DocumentMap postSnapshot =
      //     await FirebaseFirestore.instance.collection(_collectionName).add({
      //   "language": "en",
      //   "name": name,
      //   "summary": summary,
      //   "user_id": userId,
      // });

      setState(() => _creating = false);
      // if (!mounted) return;
    } on Exception catch (error) {
      loggy.error(error);
      setState(() => _creating = false);
    }
  }

  void fetchPosts() async {
    setState(() {
      _loading = true;
      _posts.clear();
    });

    try {
      final QueryMap query = getFirestoreQuery();
      listenToPostEvents(query);

      final QuerySnapMap snapshot = await query.get();

      if (snapshot.size == 0) {
        setState(() {
          _hasNext = false;
          _loading = false;
        });

        return;
      }

      for (final QueryDocSnapMap doc in snapshot.docs) {
        final Json map = doc.data();
        map["id"] = doc.id;

        _posts.add(Post.fromMap(map));
      }

      setState(() {
        _loading = false;
        _lastDocument = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  void fetchMoreProjects() async {
    final DocumentSnapshot? lastDocument = _lastDocument;
    if (!_hasNext || _loading || lastDocument == null) {
      return;
    }

    setState(() => _loading = true);

    try {
      final QueryMap query = getFirestoreQuery();
      listenToPostEvents(query);

      final QuerySnapMap snapshot = await query.get();

      if (snapshot.size == 0) {
        setState(() {
          _hasNext = false;
          _loading = false;
        });

        return;
      }

      for (final QueryDocSnapMap doc in snapshot.docs) {
        final Json data = doc.data();
        data["id"] = doc.id;
        _posts.add(Post.fromMap(data));
      }

      setState(() {
        _loading = false;
        _lastDocument = snapshot.docs.last;
        _hasNext = _limit == snapshot.size;
      });
    } catch (error) {
      loggy.error(error);
    }
  }

  void onTapPost(Post post) {}

  /// Return the query to listen changes to.
  QueryMap getFirestoreQuery() {
    final DocumentSnapshot? lastDocument = _lastDocument;

    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);
    final String userId = signalUserFirestore.value.id;

    if (userId.isEmpty) {
      if (lastDocument == null) {
        return FirebaseFirestore.instance
            .collection(_collectionName)
            .where("visibility", isEqualTo: "public")
            .orderBy("updated_at", descending: true)
            .limit(_limit);
      }

      return FirebaseFirestore.instance
          .collection(_collectionName)
          .where("visibility", isEqualTo: "public")
          .orderBy("updated_at", descending: true)
          .endAtDocument(lastDocument);
    }

    if (lastDocument == null) {
      return FirebaseFirestore.instance
          .collection(_collectionName)
          .where("user_id", isEqualTo: userId)
          .orderBy("updated_at", descending: true)
          .limit(_limit);
    }

    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("user_id", isEqualTo: userId)
        .orderBy("updated_at", descending: true)
        .endAtDocument(lastDocument);
  }

  void listenToPostEvents(QueryMap? query) {
    if (query == null) {
      return;
    }

    _postSubscription?.cancel();
    _postSubscription = query.snapshots().skip(1).listen(
      (snapshot) {
        for (DocumentChangeMap documentChange in snapshot.docChanges) {
          switch (documentChange.type) {
            case DocumentChangeType.added:
              onAddPostDocument(documentChange);
              break;
            case DocumentChangeType.modified:
              onUpdatePostDocument(documentChange);
              break;
            case DocumentChangeType.removed:
              onRemovePostDocument(documentChange);
              break;
          }
        }
      },
      onError: (error) {
        loggy.error(error);
      },
    );
  }

  /// Fire when a new document has been created in Firestore.
  /// Add the corresponding document in the UI.
  void onAddPostDocument(DocumentChangeMap documentChange) {
    final Json? map = documentChange.doc.data();

    if (map == null) {
      return;
    }

    setState(() {
      map["id"] = documentChange.doc.id;
      final Post post = Post.fromMap(map);
      _posts.insert(0, post);
    });
  }

  /// Fire when a new document has been updated in Firestore.
  /// Update the corresponding document in the UI.
  void onUpdatePostDocument(DocumentChangeMap documentChange) async {
    try {
      final Json? data = documentChange.doc.data();
      if (data == null) {
        return;
      }

      final int index = _posts.indexWhere(
        (Post p) => p.id == documentChange.doc.id,
      );

      data["id"] = documentChange.doc.id;
      final updatedProject = Post.fromMap(data);

      setState(() {
        _posts.removeAt(index);
        _posts.insert(index, updatedProject);
      });
    } on Exception catch (error) {
      loggy.error(
        "The document with the id ${documentChange.doc.id} "
        "doesn't exist in the post list.",
      );

      loggy.error(error);
    }
  }

  /// Fire when a new document has been delete from Firestore.
  /// Delete the corresponding document from the UI.
  void onRemovePostDocument(DocumentChangeMap documentChange) {
    setState(() {
      _posts.removeWhere(
        (illustration) => illustration.id == documentChange.doc.id,
      );
    });
  }

  void onPopupMenuItemSelected(
    EnumPostItemAction action,
    int index,
    Post post,
  ) {
    switch (action) {
      case EnumPostItemAction.delete:
        tryDeletePost(
          index: index,
          post: post,
        );
        break;
      default:
    }
  }

  void tryDeletePost({
    required int index,
    required Post post,
  }) async {
    setState((() {
      _posts.removeAt(index);
    }));

    try {
      await FirebaseFirestore.instance
          .collection(_collectionName)
          .doc(post.id)
          .delete();

      if (!mounted) {
        return;
      }
    } catch (error) {
      loggy.error(error);

      setState(() {
        _posts.insert(index, post);
      });
    }
  }
}
