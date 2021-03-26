import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class EditPost extends StatefulWidget {
  final String postId;

  EditPost({@required @PathParam() this.postId});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  bool isLoading = false;
  bool isSaving = false;
  bool hasError = false;

  DocumentSnapshot postSnapshot;

  final availableLang = ['en', 'fr'];
  final clearFocusNode = FocusNode();
  final postFocusNode = FocusNode();
  final contentController = TextEditingController();
  final titleFocusNode = FocusNode();
  final titleController = TextEditingController();

  String postTitle = '';
  String postContent = '';
  String lang = 'en';
  String jwt = '';

  Timer saveTitleTimer;
  Timer saveContentTimer;

  @override
  void initState() {
    super.initState();
    fechtData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          appBar(),
          body(),
        ],
      ),
    );
  }

  Widget appBar() {
    Widget title;

    if (isSaving) {
      title = Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              "saving_dot".tr(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: stateColors.foreground,
              ),
            ),
          )
        ],
      );
    } else {
      title = Opacity(
        opacity: 0.6,
        child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.only(
                      top: 40.0,
                      left: 30.0,
                      right: 30.0,
                    ),
                    content: SizedBox(
                      width: 400.0,
                      child: Text(
                        postTitle,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: context.router.pop,
                        child: Text("close".tr().toUpperCase()),
                      ),
                    ],
                  );
                });
          },
          child: Text(
            (postTitle.isEmpty ? "post_edit".tr() : postTitle),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: stateColors.foreground,
            ),
          ),
        ),
      );
    }

    return HomeAppBar(
      title: title,
    );
  }

  Widget body() {
    if (isLoading) {
      return loadingView();
    }

    if (hasError) {
      return errorView();
    }

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
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

  Widget errorView() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(
            top: 200.0,
            left: 40.0,
            right: 40.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Opacity(
                  opacity: 0.6,
                  child: Icon(
                    Icons.sentiment_neutral,
                    color: Colors.pink,
                    size: 80.0,
                  ),
                ),
              ),
              Container(
                width: 600.0,
                padding: const EdgeInsets.only(
                  bottom: 40.0,
                ),
                child: Opacity(
                  opacity: 0.7,
                  child: Text(
                    "post_loading_error".tr(),
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: context.router.pop,
                icon: Icon(UniconsLine.arrow_left, color: Colors.pink),
                label: Opacity(
                  opacity: 0.6,
                  child: Text(
                    "back".tr(),
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget loadingView() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(
            top: 200.0,
            left: 40.0,
            right: 40.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 40.0,
                ),
                child: CircularProgressIndicator(),
              ),
              Text(
                "loading".tr(),
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
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
              onPressed: context.router.pop,
              icon: Icon(UniconsLine.arrow_left),
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
                  postTitle = newValue;

                  if (saveTitleTimer != null) {
                    saveTitleTimer.cancel();
                  }

                  saveTitleTimer = Timer(1.seconds, () => saveTitle());
                },
                style: TextStyle(
                  fontSize: 42.0,
                ),
                decoration: InputDecoration(
                  hintText: "post_title_dot".tr(),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
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
        focusNode: postFocusNode,
        controller: contentController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (newValue) {
          postContent = newValue;

          if (saveContentTimer != null) {
            saveContentTimer.cancel();
          }

          saveContentTimer = Timer(1.seconds, () => saveContent());
        },
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          icon: Icon(Icons.edit),
          hintText: "once_upon_a_time".tr(),
          border: OutlineInputBorder(borderSide: BorderSide.none),
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
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
          ),
          TextButton.icon(
              focusNode: clearFocusNode,
              onPressed: () {
                postContent = '';
                contentController.clear();
                postFocusNode.requestFocus();
              },
              icon: Opacity(opacity: 0.6, child: Icon(Icons.clear)),
              label: Opacity(
                opacity: 0.6,
                child: Text("clear_content".tr()),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
          ),
          TextButton.icon(
            focusNode: postFocusNode,
            onPressed: () {
              saveTitle();
              saveContent();
            },
            icon: Opacity(
              opacity: 0.6,
              child: Icon(
                UniconsLine.save,
              ),
            ),
            label: Opacity(
              opacity: 0.6,
              child: Text("save_draft".tr()),
            ),
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
      items: availableLang.map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value.toUpperCase()),
        );
      }).toList(),
    );
  }

  Future fetchContent() async {
    try {
      final response = await Cloud.fun('posts-fetch').call({
        'postId': widget.postId,
        'jwt': jwt,
      });

      setState(() {
        postContent = response.data['post'];
        contentController.text = postContent;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_fetch_error".tr(),
      );
    }
  }

  void fechtData() async {
    setState(() => isLoading = true);

    await fetchMeta();
    await fetchContent();

    setState(() => isLoading = false);
  }

  Future fetchMeta() async {
    try {
      postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      jwt = await FirebaseAuth.instance.currentUser.getIdToken();

      setState(() {
        postTitle = postSnapshot.data()['title'];
        titleController.text = postTitle;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });

      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_save_error".tr(),
      );
    }
  }

  void saveTitle() async {
    try {
      await postSnapshot.reference.update({'title': postTitle});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void saveContent() async {
    setState(() => isSaving = true);

    try {
      final resp = await Cloud.fun('posts-save').call({
        'postId': postSnapshot.id,
        'jwt': jwt,
        'content': postContent,
      });

      bool success = resp.data['success'];

      if (!success) {
        throw ErrorDescription(resp.data['error']);
      }

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }
}
