import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/lang_popup_menu_button.dart';
import 'package:rootasjey/components/pub_popup_menu_button.dart';
import 'package:rootasjey/components/sliver_error_view.dart';
import 'package:rootasjey/components/sliver_loading_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post.dart';
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
  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasError = false;

  DocumentSnapshot _postSnapshot;

  final _clearFocusNode = FocusNode();
  final _postFocusNode = FocusNode();
  final _contentController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _titleController = TextEditingController();

  static const PUBLISHED = 'published';
  static const DRAFT = 'draft';

  String _publicationStatus = DRAFT;

  String _title = '';
  String _postContent = '';
  String _lang = 'en';
  String _jwt = '';

  Timer _saveTitleTimer;
  Timer _saveContentTimer;

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
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      collapsedHeight: 80.0,
      backgroundColor: stateColors.appBackground.withOpacity(1.0),
      expandedHeight: 120.0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: appBarTitle(),
      bottom: appBarBottom(),
    );
  }

  Widget appBarBottom() {
    return PreferredSize(
      preferredSize: Size.fromHeight(20.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 28.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: LangPopupMenuButton(
                lang: _lang,
                onLangChanged: (newLang) {
                  setState(() {
                    _lang = newLang;
                  });

                  updateLang();
                },
              ),
            ),
            viewOnlineButton(),
            saveButton(),
            PubPopupMenuButton(
              status: _publicationStatus,
              onStatusChanged: (newStatus) {
                setState(() {
                  _publicationStatus = newStatus;
                });

                updatePubStatus(newStatus);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget appBarTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (context.router.root.stack.length > 1)
            IconButton(
              icon: Icon(UniconsLine.arrow_left),
              onPressed: () {
                context.router.pop();
              },
            ),
          if (_isSaving)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          Text(
            _title.isEmpty ? "post_edit".tr() : _title,
          ),
        ],
      ),
    );
  }

  Widget body() {
    if (_isLoading) {
      return SliverLoadingView(
        title: "loading_project".tr(),
        padding: const EdgeInsets.only(top: 200.0),
      );
    }

    if (_hasError) {
      return SliverErrorView(
        textTitle: "post_loading_error".tr(),
      );
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
              titleInput(),
              contentInput(),
            ],
          ),
        ),
      ]),
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
        focusNode: _postFocusNode,
        controller: _contentController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (newValue) {
          _postContent = newValue;

          if (_saveContentTimer != null) {
            _saveContentTimer.cancel();
          }

          _saveContentTimer = Timer(1.seconds, () => updateContent());
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

  Widget saveButton() {
    final saveStr =
        _publicationStatus == DRAFT ? "save_draft".tr() : "save".tr();

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: OutlinedButton.icon(
        onPressed: () {
          updateTitle();
          updateContent();
        },
        icon: Opacity(opacity: 0.6, child: Icon(UniconsLine.save)),
        label: Opacity(opacity: 0.6, child: Text(saveStr)),
        style: OutlinedButton.styleFrom(primary: stateColors.foreground),
      ),
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
                focusNode: _titleFocusNode,
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (newValue) {
                  _title = newValue;

                  if (_saveTitleTimer != null) {
                    _saveTitleTimer.cancel();
                  }

                  _saveTitleTimer = Timer(1.seconds, () => updateTitle());
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

  Widget viewOnlineButton() {
    if (_publicationStatus != PUBLISHED) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          primary: stateColors.foreground,
        ),
        focusNode: _clearFocusNode,
        onPressed: () {
          context.router.root.push(
            PostsDeepRoute(
              children: [
                PostPageRoute(postId: widget.postId),
              ],
            ),
          );
        },
        icon: Opacity(
          opacity: 0.6,
          child: Icon(
            UniconsLine.eye,
          ),
        ),
        label: Opacity(
          opacity: 0.6,
          child: Text(
            "view_online".tr(),
          ),
        ),
      ),
    );
  }

  Future fetchContent() async {
    try {
      final response = await Cloud.fun('posts-fetch').call({
        'postId': widget.postId,
        'jwt': _jwt,
      });

      setState(() {
        _postContent = response.data['post'];
        _contentController.text = _postContent;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_fetch_error".tr(),
      );
    }
  }

  void fechtData() async {
    setState(() => _isLoading = true);

    await fetchMeta();
    await fetchContent();

    setState(() => _isLoading = false);
  }

  Future fetchMeta() async {
    try {
      _postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      _jwt = await FirebaseAuth.instance.currentUser.getIdToken();

      final Map<String, dynamic> data = _postSnapshot.data();
      final Post post = Post.fromJSON(data);

      setState(() {
        _title = post.title;
        _titleController.text = _title;
        _lang = post.lang;
        _publicationStatus = post.published ? PUBLISHED : DRAFT;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_save_error".tr(),
      );
    }
  }

  void updateContent() async {
    setState(() => _isSaving = true);

    try {
      final resp = await Cloud.fun('posts-save').call({
        'postId': _postSnapshot.id,
        'jwt': _jwt,
        'content': _postContent,
      });

      bool success = resp.data['success'];

      if (!success) {
        throw ErrorDescription(resp.data['error']);
      }

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }

  void updateLang() async {
    setState(() => _isSaving = true);

    try {
      await _postSnapshot.reference.update({'lang': _lang});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }

  void updatePubStatus(String status) async {
    final prevValue = _publicationStatus;

    setState(() {
      _publicationStatus = status;
      _isSaving = true;
    });

    try {
      await _postSnapshot.reference.update({'published': status == PUBLISHED});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _publicationStatus = prevValue;
        _isSaving = false;
      });
    }
  }

  void updateTitle() async {
    try {
      await _postSnapshot.reference.update({'title': _title});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }
}
