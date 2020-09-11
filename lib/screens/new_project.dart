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

class NewProject extends StatefulWidget {
  @override
  _NewProjectState createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  bool isSaving = false;

  DocumentReference projectSnapshot;

  final availableLang     = ['en', 'fr'];
  final clearFocusNode    = FocusNode();
  final contentFocusNode  = FocusNode();
  final contentController = TextEditingController();
  final titleFocusNode    = FocusNode();
  final titleController   = TextEditingController();

  String projectTitle     = '';
  String projectContent   = '';
  String lang             = 'en';
  String jwt              = '';

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
                      : 'New Project',
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
    return Padding(
      padding: const EdgeInsets.only(
        left: 110.0,
        top: 60.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: () => FluroRouter.router.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),

          Expanded(
            child: Container(
              width: 700.0,
              child: TextField(
                maxLines: 1,
                autofocus: true,
                focusNode: titleFocusNode,
                controller: titleController,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (newValue) {
                  projectTitle = newValue;

                  if (saveTitleTimer != null) {
                    saveTitleTimer.cancel();
                  }

                  saveTitleTimer = Timer(
                    1.seconds,
                    () => saveTitle()
                  );
                },
                style: TextStyle(
                  fontSize: 42.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Project Title...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contentInput() {
    return Container(
      width: 700.0,
      padding: const EdgeInsets.only(
        top: 40.0,
      ),
      child: TextField(
        maxLines: null,
        autofocus: false,
        focusNode: contentFocusNode,
        controller: contentController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (newValue) {
          projectContent = newValue;

          if (saveContentTimer != null) {
            saveContentTimer.cancel();
          }

          saveContentTimer = Timer(
            1.seconds,
            () => saveContent()
          );
        },
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w300,
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
              projectContent = '';
              contentController.clear();
              contentFocusNode.requestFocus();
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
            focusNode: contentFocusNode,
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

  void createProject() async {
    setState(() => isSaving = true);

    try {
      final userAuth = await userState.userAuth;

      projectSnapshot = await FirebaseFirestore.instance
        .collection('projects')
        .add({
          'author': userAuth.uid,
          'coauthors': [],
          'createdAt': DateTime.now(),
          'featured': false,
          'gallery': {},
          'platforms': {},
          'published':false,
          'referenced': true,
          'release': false,
          'restrictedTo': {
            'premium': false,
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

    createProject();
  }

  void saveTitle() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.update({'title': projectTitle});
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
      ).getHttpsCallable(functionName: 'projects-save');

      final resp = await callable.call({
        'projectId': projectSnapshot.id,
        'jwt': jwt,
        'content': projectContent,
      });

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
