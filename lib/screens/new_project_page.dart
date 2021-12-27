import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/error_view.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/project_editor.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/snack.dart';

class NewProjectPage extends StatefulWidget {
  @override
  _NewProjectPageState createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  bool _isPostCreated = false;
  bool _isLoading = false;

  DocumentReference? _projectSnapshot;

  @override
  void initState() {
    super.initState();
    createProject();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _isPostCreated && _projectSnapshot != null) {
      return ProjectEditor(projectId: _projectSnapshot!.id);
    }

    if (_isLoading) {
      return LoadingView(
        title: "project_creating".tr(),
      );
    }

    return ErrorView(
      textTitle: "project_create_error".tr(),
    );
  }

  void createProject() async {
    try {
      final userAuth = Globals.state.getUserAuth();
      if (userAuth == null) {
        throw ErrorDescription("You're not authenticated");
      }

      setState(() => _isLoading = true);

      _projectSnapshot =
          await FirebaseFirestore.instance.collection('projects').add({
        'author': {
          'id': userAuth.uid,
        },
        'coauthors': [],
        'createdAt': DateTime.now(),
        'featured': false,
        'gallery': {},
        'i18n': {},
        'image': {
          'cover': '',
          'thumbnail': '',
        },
        'platforms': {},
        'published': false,
        'referenced': true,
        'release': false,
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
        'title': '',
        'updatedAt': DateTime.now(),
        'urls': {
          'artbooking': '',
          'behance': '',
          'bitbucket': '',
          'dribbble': '',
          'facebook': '',
          'github': '',
          'gitlab': '',
          'image': '',
          'instagram': '',
          'linkedin': '',
          'other': '',
          'twitter': '',
          'website': '',
          'youtube': '',
        },
      });

      String jwt = await userAuth.getIdToken();
      final bool success = await createContent(jwt);

      if (!success) {
        throw ErrorDescription("post_create_error_storage".tr());
      }
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_create_error_database".tr(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> createContent(String jwt) async {
    bool success = true;
    setState(() => _isLoading = true);

    try {
      final resp = await Cloud.fun('projects-save').call({
        'projectId': _projectSnapshot!.id,
        'jwt': jwt,
        'content': "Hi ",
      });

      success = resp.data['success'];

      if (!success) {
        throw ErrorDescription(resp.data['error']);
      }
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_create_error_storage".tr(),
      );
    } finally {
      setState(() => _isLoading = false);
      return success;
    }
  }
}
