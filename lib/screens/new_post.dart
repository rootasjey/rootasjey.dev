import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user_state.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  bool isSaving = false;

  DocumentReference postSnapshot;

  final availableLang = ['en', 'fr'];
  final clearFocusNode  = FocusNode();
  final postFocusNode   = FocusNode();
  final postController  = TextEditingController();
  final titleFocusNode  = FocusNode();
  final titleController = TextEditingController();

  String postTitle    = '';
  String postContent  = '';
  String lang         = 'en';
  String jwt = '';

  Timer saveTitleTimer;
  Timer saveContentTimer;

  @override
  void initState() {
    super.initState();
    initAndCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSaving)
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircularProgressIndicator(strokeWidth: 2.0,),
                  ),

                Opacity(
                  opacity: 0.6,
                  child: Text(
                    isSaving
                      ? 'Saving...'
                      : 'New Post',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: stateColors.foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(
            top: 100.0,
            bottom: 400.0,
          ),
          child: Column(
            children: [
              actionsInput(),
              titleInput(),
              contentInput(),
            ],
          ),
        ),
      ]),
    );
  }

  Widget titleInput() {
    return Container(
      width: 700.0,
      padding: const EdgeInsets.only(top: 50.0,),
      child: TextField(
        maxLines: 1,
        autofocus: true,
        focusNode: titleFocusNode,
        controller: titleController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (newValue) {
          postTitle = newValue;

          if (saveTitleTimer != null) {
            saveTitleTimer.cancel();
          }

          saveTitleTimer = Timer(
            2.seconds,
            () => saveTitle()
          );
        },
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: InputDecoration(
          icon: Icon(Icons.title),
          hintText: 'Post Title...',
          border: OutlineInputBorder(
            borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }

  Widget contentInput() {
    return Container(
      width: 700.0,
      child: TextField(
        maxLines: null,
        autofocus: false,
        focusNode: postFocusNode,
        controller: postController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (newValue) {
          postContent = newValue;

          if (saveContentTimer != null) {
            saveContentTimer.cancel();
          }

          saveContentTimer = Timer(
            2.seconds,
            () => saveContent()
          );
        },
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: InputDecoration(
          icon: Icon(Icons.edit),
          hintText: "Once upon a time...",
          border: OutlineInputBorder(
            borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }

  Widget actionsInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 120.0),
      child: Row(
        children: <Widget>[
          langSelect(),

          Padding(padding: const EdgeInsets.only(left: 20.0),),

          FlatButton.icon(
            focusNode: clearFocusNode,
            onPressed: () {
              postContent = '';
              postController.clear();
              postFocusNode.requestFocus();
            },
            icon: Opacity(opacity: 0.6, child: Icon(Icons.clear)),
            label: Opacity(
              opacity: 0.6,
              child: Text(
                'Clear content',
              ),
            )
          ),

          Padding(padding: const EdgeInsets.only(left: 20.0),),

          FlatButton.icon(
            focusNode: postFocusNode,
            onPressed: () {
              saveTitle();
              saveContent();
            },
            icon: Opacity(opacity: 0.6, child: Icon(Icons.save)),
            label: Opacity(
              opacity: 0.6,
              child: Text(
                'Save draft',
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget langSelect() {
    return DropdownButton<String>(
      value: lang,
      style: TextStyle(
        color: stateColors.primary,
        fontSize: 20.0,
      ),
      icon: Icon(Icons.language),
      iconEnabledColor: stateColors.primary,
      onChanged: (newValue) {
        setState(() {
          lang = newValue;
        });
      },
      items: availableLang
        .map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value.toUpperCase()),
          );
        }).toList(),
    );
  }

  Future<bool> checkAuth() async {
    try {
      final userAuth = await userState.userAuth;
      if (userAuth != null) { return true; }

      FluroRouter.router.navigateTo(context, SigninRoute);
      return false;

    } catch (error) {
      debugPrint(error.toString());
      FluroRouter.router.navigateTo(context, SigninRoute);
      return false;
    }
  }

  void createPost() async {
    setState(() => isSaving = true);

    try {
      final userAuth = await userState.userAuth;

      postSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .add({
          'author': userAuth.uid,
          'coauthors': [],
          'createdAt': DateTime.now(),
          'featured': false,
          'published':false,
          'referenced': true,
          'restrictedTo': {
            'premium': false,
          },
          'summary': '',
          'tags': {},
          'timeToRead': '',
          'title': '',
          'updatedAt': DateTime.now(),
          'urls': {
            'image': '',
          },
        });

      jwt = await FirebaseAuth.instance
        .currentUser
        .getIdToken();

      setState(() => isSaving = false);

    } catch(error) {
      setState(() => isSaving = false);
      debugPrint(error.toSring());

      showSnack(
        context: context,
        message: "There was an error while saving.\n${error.toString()}",
        type: SnackType.error,
      );
    }
  }

  void initAndCheck() async {
    final result = await checkAuth();
    if (!result) { return; }

    createPost();
  }

  void saveTitle() async {
    setState(() => isSaving = true);

    try {
      await postSnapshot.update({'title': postTitle});
      setState(() => isSaving = false);

    } catch (error) {
      debugPrint(error.toString());
      setState(() => isSaving = false);
    }
  }

  void saveContent() async {
    setState(() => isSaving = true);

    try {
      final callable = CloudFunctions(
        app: Firebase.app(),
        region: 'europe-west3',
      ).getHttpsCallable(functionName: 'posts-save ');

      final resp = await callable.call({
        'postId': postSnapshot.id,
        'jwt': jwt,
        'content': postContent,
      });

      print('success: ${resp.data['success']}');
      bool success = resp.data['success'];

      if (!success) {
        throw ErrorDescription(resp.data['error']);
      }

      setState(() => isSaving = false);

    } catch (error) {
      debugPrint(error.toString());
      setState(() => isSaving = false);
    }
  }
}
