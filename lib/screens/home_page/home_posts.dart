import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:loggy/loggy.dart';
import 'package:lottie/lottie.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/home_page/colored_text.dart';
import 'package:rootasjey/types/alias/firestore/document_change_map.dart';
import 'package:rootasjey/types/alias/firestore/query_doc_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snap_map.dart';
import 'package:rootasjey/types/alias/firestore/query_snapshot_stream_subscription.dart';
import 'package:rootasjey/types/alias/json_alias.dart';
import 'package:rootasjey/types/enums/enum_page_state.dart';
import 'package:rootasjey/types/enums/enum_signal_id.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/types/user/user_firestore.dart';

class HomePosts extends StatefulWidget {
  /// Home posts section.
  const HomePosts({
    super.key,
    this.margin = EdgeInsets.zero,
  });

  /// Space around this widget.
  final EdgeInsetsGeometry margin;

  @override
  State<HomePosts> createState() => _HomePostsState();
}

class _HomePostsState extends State<HomePosts> with UiLoggy {
  /// True if there're more posts to fetch.
  // bool _hasNext = true;

  /// Page state.
  EnumPageState _pageState = EnumPageState.idle;

  /// Amount of posts to fetch.
  final int _limit = 2;

  /// Posts list.
  final List<Post> _posts = [];

  /// Listens to posts' updates.
  QuerySnapshotStreamSubscription? _postSubscription;

  /// Firestore collection's name.
  final String _collectionName = "posts";

  @override
  void initState() {
    super.initState();
    fetchLastPosts();
  }

  @override
  void dispose() {
    _posts.clear();
    _postSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin,
      child: Wrap(
        spacing: 12.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          TextButton(
            onPressed: onTapPosts,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.pink.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Text(
              "POSTS",
              style: Utils.calligraphy.body3(
                textStyle: const TextStyle(
                  fontSize: 42.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          if (_pageState == EnumPageState.loading)
            Lottie.asset(
              "assets/animations/dots.json",
              width: 100.0,
              height: 60.0,
            ),
          if (_posts.isNotEmpty)
            ..._posts.map((post) {
              return ColoredText(
                onTap: () {
                  debugPrint("project $post");
                },
                textHoverColor: Colors.pink,
                textValue: "${post.name} •",
              );
            }),
        ],
      ),
    );
  }

  void fetchLastPosts() async {
    setState(() {
      _pageState = EnumPageState.loading;
      _posts.clear();
    });
    try {
      final QueryMap query = getFirestoreQuery();
      listenToPostEvents(query);

      final QuerySnapMap snapshot = await query.get();

      if (snapshot.size == 0) {
        setState(() {
          _pageState = EnumPageState.idle;
        });

        return;
      }

      for (final QueryDocSnapMap doc in snapshot.docs) {
        final Json map = doc.data();
        map["id"] = doc.id;
        _posts.add(Post.fromMap(map));
      }
    } catch (error) {
      loggy.error(error);
    } finally {
      setState(() {
        _pageState = EnumPageState.idle;
      });
    }
  }

  /// Return the query to listen changes to.
  QueryMap getFirestoreQuery() {
    // final DocumentSnapshot? lastDocument = _lastDocument;

    final Signal<UserFirestore> signalUserFirestore =
        context.get(EnumSignalId.userFirestore);
    final String userId = signalUserFirestore.value.id;

    if (userId.isEmpty) {
      return FirebaseFirestore.instance
          .collection(_collectionName)
          .where("visibility", isEqualTo: "public")
          .orderBy("updated_at", descending: true)
          .limit(_limit);

      // return FirebaseFirestore.instance
      //     .collection(_collectionName)
      //     .where("visibility", isEqualTo: "public")
      //     .orderBy("updated_at", descending: true)
      //     .endAtDocument(lastDocument);
    }

    return FirebaseFirestore.instance
        .collection(_collectionName)
        .where("user_id", isEqualTo: userId)
        .orderBy("updated_at", descending: true)
        .limit(_limit);

    // return FirebaseFirestore.instance
    //     .collection(_collectionName)
    //     .where("user_id", isEqualTo: userId)
    //     .orderBy("updated_at", descending: true)
    //     .endAtDocument(lastDocument);
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

  void onTapPosts() {}
}
