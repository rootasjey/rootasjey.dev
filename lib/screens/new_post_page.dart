import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/components/error_view.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/post_editor.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/snack.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  bool _isPostCreated = false;
  bool _isLoading = true;

  DocumentReference _postSnapshot;

  String _jwt = '';

  @override
  void initState() {
    super.initState();
    createPost();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _isPostCreated && _postSnapshot != null) {
      return PostEditor(postId: _postSnapshot.id);
    }

    if (_isLoading) {
      return LoadingView(
        title: "post_creating".tr(),
      );
    }

    return ErrorView(
      textTitle: "post_create_error",
    );
  }

  void createPost() async {
    setState(() => _isLoading = true);

    try {
      final userAuth = stateUser.userAuth;

      _postSnapshot = await FirebaseFirestore.instance.collection('posts').add({
        'author': {
          'id': userAuth.uid,
        },
        'coauthors': [],
        'createdAt': DateTime.now(),
        'featured': false,
        'image': {
          'cover': '',
          'thumbnail': '',
        },
        'i18n': {},
        'lang': 'en',
        'published': false,
        'referenced': true,
        'restrictedTo': {
          'premium': false,
        },
        'stats': {
          'likes': 0,
          'shares': 0,
        },
        'summary': '',
        'tags': {},
        'timeToRead': '',
        'title': 'Untitled-${Jiffy(DateTime.now()).yMMMMEEEEdjm}',
        'updatedAt': DateTime.now(),
        'urls': {
          'image': '',
        },
      });

      _jwt = await FirebaseAuth.instance.currentUser.getIdToken();
      await createContent();
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_create_error_database".tr(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> createContent() async {
    bool success = true;

    try {
      final resp = await Cloud.fun('posts-save').call({
        'postId': _postSnapshot.id,
        'jwt': _jwt,
        'content': "Hi, ",
      });

      bool success = resp.data['success'];

      if (!success) {
        throw ErrorDescription(resp.data['error']);
      }

      _isPostCreated = true;
    } catch (error) {
      appLogger.e(error);
      Snack.e(
        context: context,
        message: "post_create_error_storage".tr(),
      );
    } finally {
      setState(() => _isLoading = false);
      return success;
    }
  }
}
