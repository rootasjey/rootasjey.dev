import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/lang_popup_menu_button.dart';
import 'package:rootasjey/components/application_bar/main_app_bar.dart';
import 'package:rootasjey/components/pub_popup_menu_button.dart';
import 'package:rootasjey/components/sliver_edge_padding.dart';
import 'package:rootasjey/components/sliver_error_view.dart';
import 'package:rootasjey/components/sliver_loading_view.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/flash_helper.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class PostEditor extends StatefulWidget {
  final String postId;

  const PostEditor({
    Key key,
    @required this.postId,
  }) : super(key: key);

  @override
  _PostEditorState createState() => _PostEditorState();
}

class _PostEditorState extends State<PostEditor> {
  bool _isLoading = false;
  bool _isDeleting = false;
  bool _isSaving = false;
  bool _hasError = false;

  DocumentSnapshot _postSnapshot;

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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverEdgePadding(),
              MainAppBar(),
              body(),
            ],
          ),
          popupProgressIndicator(),
        ],
      ),
    );
  }

  Widget actionsRow() {
    return Column(
      children: [
        SizedBox(
          width: 700.0,
          child: Divider(thickness: 1, height: 24.0),
        ),
        Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          children: [
            backButton(),
            langButton(),
            pubPopupMenuButton(),
            vDivider(),
            saveButton(),
            if (_publicationStatus == PUBLISHED) viewOnlineButton(),
            deleteButton(),
          ],
        ),
        SizedBox(
          width: 700.0,
          child: Divider(thickness: 1, height: 24.0),
        ),
      ],
    );
  }

  Widget backButton() {
    if (Beamer.of(context).beamingHistory.isEmpty) {
      return Container(width: 0.0, height: 0.0);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: IconButton(
        tooltip: "back".tr(),
        onPressed: Beamer.of(context).beamBack,
        icon: Opacity(
          opacity: 0.6,
          child: Icon(UniconsLine.arrow_left),
        ),
      ),
    );
  }

  Widget body() {
    if (_isLoading) {
      return SliverLoadingView(
        title: "loading_post".tr(),
        padding: const EdgeInsets.only(top: 200.0),
      );
    }

    if (_hasError) {
      return SliverErrorView(
        textTitle: "post_loading_error".tr(),
      );
    }

    return idleView();
  }

  Widget contentInput() {
    return SizedBox(
      width: 700.0,
      child: Opacity(
        opacity: 0.8,
        child: TextField(
          maxLines: null,
          autofocus: false,
          focusNode: _postFocusNode,
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: FontsUtils.mainStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "once_upon_a_time".tr(),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          onChanged: (newValue) {
            _postContent = newValue;

            if (_saveContentTimer != null) {
              _saveContentTimer.cancel();
            }

            _saveContentTimer = Timer(1.seconds, () => updateContent());
          },
        ),
      ),
    );
  }

  Widget deleteButton() {
    return IconButton(
      tooltip: "post_delete".tr(),
      icon: Opacity(
        opacity: 0.6,
        child: Icon(UniconsLine.trash),
      ),
      onPressed: () {
        FlashHelper.deleteDialog(
          context,
          message: "post_delete_description".tr(),
          onConfirm: () async {
            final success = await deletePost();

            if (success) {
              Beamer.of(context)
                  .beamToNamed(DashboardLocationContent.postsRoute);
            }
          },
        );
      },
    );
  }

  Widget header() {
    return Column(
      children: [
        actionsRow(),
        titleInput(),
      ],
    );
  }

  Widget idleView() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        top: 40.0,
        bottom: 400.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Column(
            children: [
              header(),
              contentInput(),
            ],
          ),
        ]),
      ),
    );
  }

  Widget langButton() {
    return LangPopupMenuButton(
      lang: _lang,
      opacity: 0.6,
      color: stateColors.lightBackground,
      onLangChanged: (newLang) {
        setState(() {
          _lang = newLang;
        });

        updateLang();
      },
    );
  }

  Widget popupProgressIndicator() {
    if (!_isSaving) {
      return Container();
    }

    return Positioned(
      top: 100.0,
      right: 24.0,
      child: SizedBox(
        width: 240.0,
        child: Card(
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 4.0,
                child: LinearProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      UniconsLine.circle,
                      color: stateColors.secondary,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Opacity(
                          opacity: 0.6,
                          child: Text(
                            "post_updating".tr(),
                            style: FontsUtils.mainStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pubPopupMenuButton() {
    return PubPopupMenuButton(
      status: _publicationStatus,
      onStatusChanged: (newStatus) {
        setState(() {
          _publicationStatus = newStatus;
        });

        updatePubStatus(newStatus);
      },
    );
  }

  Widget saveButton() {
    final saveStr =
        _publicationStatus == DRAFT ? "save_draft".tr() : "save".tr();

    return IconButton(
      tooltip: saveStr,
      icon: Opacity(
        opacity: 0.6,
        child: Icon(UniconsLine.save),
      ),
      onPressed: () {
        updateTitle();
        updateContent();
      },
    );
  }

  Widget titleInput() {
    return Container(
      width: 700.0,
      padding: const EdgeInsets.only(
        top: 60.0,
      ),
      child: TextField(
        maxLines: null,
        autofocus: true,
        focusNode: _titleFocusNode,
        controller: _titleController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        style: FontsUtils.mainStyle(
          fontSize: 42.0,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: "post_title_dot".tr(),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        onChanged: (newValue) {
          _title = newValue;

          if (_saveTitleTimer != null) {
            _saveTitleTimer.cancel();
          }

          _saveTitleTimer = Timer(1.seconds, () => updateTitle());
        },
      ),
    );
  }

  Widget vDivider() {
    return SizedBox(
      height: 40.0,
      child: VerticalDivider(
        thickness: 1.0,
        width: 24.0,
      ),
    );
  }

  Widget viewOnlineButton() {
    return IconButton(
      tooltip: "view_online".tr(),
      onPressed: () {
        Beamer.of(context).beamToNamed(
          '${PostsLocation.route}/${widget.postId}',
          data: {'postId', widget.postId},
        );
      },
      icon: Opacity(
        opacity: 0.6,
        child: Icon(UniconsLine.eye),
      ),
    );
  }

  Future<bool> deletePost() async {
    if (_isDeleting || _isLoading || _isSaving) {
      return false;
    }

    bool success = true;
    _isDeleting = true;

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .delete();
    } catch (error) {
      success = false;
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_delete_failed".tr(),
      );
    } finally {
      _isLoading = false;
      _isDeleting = false;

      return success;
    }
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
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_update_content_fail".tr(),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void updateLang() async {
    setState(() => _isSaving = true);

    try {
      await _postSnapshot.reference.update({'lang': _lang});
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_update_lang_fail".tr(),
      );
    } finally {
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
    } catch (error) {
      appLogger.e(error);

      _publicationStatus = prevValue;

      Snack.e(
        context: context,
        message: "post_update_pub_fail".tr(),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void updateTitle() async {
    try {
      await _postSnapshot.reference.update({'title': _title});
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "post_update_title_fail".tr(),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }
}
