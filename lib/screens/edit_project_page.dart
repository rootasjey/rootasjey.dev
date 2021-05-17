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
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:rootasjey/utils/texts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class EditProjectPage extends StatefulWidget {
  final String projectId;

  EditProjectPage({@required @PathParam() this.projectId});

  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasError = false;
  bool _isMetaVisible = false;

  DocumentSnapshot _projectSnapshot;

  final _clearFocusNode = FocusNode();
  final _projectFocusNode = FocusNode();
  final _contentController = TextEditingController();

  final _titleFocusNode = FocusNode();
  final _titleController = TextEditingController();

  final _summaryFocusNode = FocusNode();
  final _summaryController = TextEditingController();

  final _platformController = TextEditingController();
  final _tagController = TextEditingController();
  final _pLangController = TextEditingController();

  final _platforms = {
    'android': false,
    'androidtv': false,
    'ios': false,
    'ipados': false,
    'linux': false,
    'macos': false,
    'web': false,
    'windows': false,
  };

  final _programmingLanguages = Map<String, bool>();
  final _tags = Map<String, bool>();
  final _urls = Map<String, String>();

  static const PUBLISHED = 'published';
  static const DRAFT = 'draft';

  String _publicationStatus = DRAFT;

  String _title = '';
  String _content = '';
  String _summary = '';
  String _platformInputValue = '';
  String _pLangInputValue = '';
  String _tagInputValue = '';
  String _lang = 'en';
  String _jwt = '';
  String _urlName = '';
  String _urlValue = '';

  Timer _saveTitleTimer;
  Timer _saveSummaryTimer;
  Timer _saveContentTimer;

  @override
  void initState() {
    super.initState();
    fetch();
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
              padding: const EdgeInsets.only(right: 16.0),
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
              icon: Icon(
                UniconsLine.arrow_left,
                color: stateColors.foreground,
              ),
              onPressed: context.router.pop,
            ),
          if (_isSaving)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          Text(
            _title.isEmpty ? "project_edit".tr() : _title,
            style: TextStyle(
              color: stateColors.foreground,
            ),
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
        textTitle: "project_fetch_error".tr(),
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
              summaryInput(),
              contentInput(),
              buttonToggleMetaView(),
              if (_isMetaVisible)
                Column(
                  children: [
                    progLangsSelection(),
                    platformsSelection(),
                    tagsSelection(),
                    urlsSections(),
                  ],
                ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget buttonToggleMetaView() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 80.0,
          left: 120.0,
        ),
        child: ElevatedButton.icon(
          onPressed: () => setState(() => _isMetaVisible = !_isMetaVisible),
          icon: _isMetaVisible
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _isMetaVisible ? "meta_data_hide".tr() : "meta_data_show".tr(),
            ),
          ),
        ),
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
        focusNode: _projectFocusNode,
        controller: _contentController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (newValue) {
          _content = newValue;

          if (_saveContentTimer != null) {
            _saveContentTimer.cancel();
          }

          _saveContentTimer = Timer(1.seconds, () => saveContent());
        },
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          icon: Icon(Icons.edit),
          hintText: "project_story_dot".tr(),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget platformsSelection() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          platformsSelectionHeader(),
          platformsSelectionContent(),
          platformsSelectionInput(),
        ],
      ),
    );
  }

  Widget platformsSelectionHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.device_unknown),
            ),
            Text(
              "platforms".tr().toUpperCase(),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget platformsSelectionContent() {
    return Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: _platforms.entries.map((entry) {
          return InputChip(
            label: Text(
              getPlatformName(entry.key),
            ),
            labelStyle: TextStyle(
              color: entry.value ? Colors.white : stateColors.foreground,
            ),
            selectedColor: stateColors.primary,
            selected: entry.value,
            checkmarkColor: Colors.white,
            deleteIconColor:
                entry.value ? Colors.white : stateColors.foreground,
            onDeleted: () {
              _platforms.remove(entry.key);
              updatePlatforms();
            },
            onSelected: (isSelected) {
              _platforms[entry.key] = isSelected;
              updatePlatforms();
            },
          );
        }).toList());
  }

  Widget platformsSelectionInput() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50.0,
            width: 250.0,
            child: TextFormField(
              controller: _platformController,
              decoration: InputDecoration(
                labelText: "platform_new".tr(),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _platformInputValue = value.toLowerCase();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton.icon(
              onPressed: () {
                _platforms[_platformInputValue] = true;
                _platformController.clear();
                updatePlatforms();
              },
              icon: Icon(Icons.add),
              label: Text("platform_add".tr()),
            ),
          ),
        ],
      ),
    );
  }

  Widget progLangsSelection() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          progLangsSelectionHeader(),
          progLangsSelectionContent(),
          progLangsSelectionInput(),
        ],
      ),
    );
  }

  Widget progLangsSelectionHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.code),
            ),
            Text(
              "programming_languages".tr().toUpperCase(),
              style: FontsUtils.mainStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget progLangsSelectionContent() {
    return Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: _programmingLanguages.entries.map((entry) {
          return InputChip(
            label: Text(
              entry.key,
            ),
            onDeleted: () {
              _programmingLanguages.remove(entry.key);
              updateProgLanguages();
            },
          );
        }).toList());
  }

  Widget progLangsSelectionInput() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50.0,
            width: 300.0,
            child: TextFormField(
              controller: _pLangController,
              decoration: InputDecoration(
                labelText: "programming_language_new_dot".tr(),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _pLangInputValue = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton.icon(
              onPressed: () {
                _programmingLanguages[_pLangInputValue] = true;
                _pLangController.clear();
                updateProgLanguages();
              },
              icon: Icon(Icons.add),
              label: Text("add".tr()),
            ),
          ),
        ],
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
          saveContent();
        },
        icon: Opacity(opacity: 0.6, child: Icon(UniconsLine.save)),
        label: Opacity(opacity: 0.6, child: Text(saveStr)),
        style: OutlinedButton.styleFrom(primary: stateColors.foreground),
      ),
    );
  }

  Widget summaryInput() {
    return Container(
      width: 700.0,
      padding: const EdgeInsets.only(
        left: 0.0,
        top: 10.0,
      ),
      child: TextField(
        maxLines: 1,
        focusNode: _summaryFocusNode,
        controller: _summaryController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: "project_summary_dot".tr(),
          icon: Icon(Icons.short_text),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        style: TextStyle(
          fontSize: 20.0,
          color: stateColors.foreground.withOpacity(0.4),
        ),
        onChanged: (newValue) {
          _summary = newValue;

          if (_saveTitleTimer != null) {
            _saveSummaryTimer.cancel();
          }

          _saveSummaryTimer = Timer(1.seconds, () => updateSummary());
        },
      ),
    );
  }

  Widget tagsSelection() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tagsSelectionHeader(),
          tagsSelectionContent(),
          tagsSelectionInput(),
        ],
      ),
    );
  }

  Widget tagsSelectionHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.tag),
            ),
            Text(
              "tags".tr().toUpperCase(),
              style: FontsUtils.mainStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tagsSelectionContent() {
    return Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: _tags.entries.map((entry) {
          return InputChip(
            label: Text(
              '${entry.key.substring(0, 1).toUpperCase()}${entry.key.substring(1)}',
              style: TextStyle(
                color: entry.value ? Colors.white : stateColors.foreground,
              ),
            ),
            selectedColor: stateColors.primary,
            selected: entry.value,
            checkmarkColor: Colors.white,
            deleteIconColor:
                entry.value ? Colors.white : stateColors.foreground,
            onDeleted: () {
              _tags.remove(entry.key);
              updateTags();
            },
            onSelected: (isSelected) {
              _tags[entry.key] = isSelected;
              updateTags();
            },
          );
        }).toList());
  }

  Widget tagsSelectionInput() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50.0,
            width: 250.0,
            child: TextFormField(
              controller: _tagController,
              decoration: InputDecoration(
                labelText: "tag_new_dot".tr(),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _tagInputValue = value.toLowerCase();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton.icon(
              onPressed: () {
                _tags[_tagInputValue] = true;
                _tagController.clear();
                updateTags();
              },
              icon: Icon(Icons.add),
              label: Text("tag_add".tr()),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleInput() {
    return Container(
      width: 720.0,
      padding: const EdgeInsets.only(
        top: 60.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              onPressed: context.router.pop,
              icon: Icon(Icons.arrow_back),
            ),
          ),
          Expanded(
            child: Container(
              width: 670.0,
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
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "project_title_dot".tr(),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget urlsSections() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
          ),
          child: Opacity(
            opacity: 0.6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.link),
                ),
                Text(
                  "urls_ext".tr(),
                  style: FontsUtils.mainStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: _urls.entries.map((entry) {
            return InputChip(
              label: Text(entry.key),
              labelStyle: TextStyle(
                color: entry.value != null && entry.value.isNotEmpty
                    ? Colors.white
                    : stateColors.foreground,
              ),
              selectedColor: stateColors.primary,
              selected: entry.value?.isNotEmpty,
              checkmarkColor: Colors.white,
              deleteIconColor: entry.value.isNotEmpty
                  ? Colors.white
                  : stateColors.foreground,
              onDeleted: () {
                _urls.remove(entry.key);
                updateUrls();
              },
              onPressed: () {
                _urlName = entry.key;
                _urlValue = entry.value;

                showAddUrlSheet();
              },
            );
          }).toList(),
        ),
        TextButton.icon(
          onPressed: () {
            _urlName = '';
            _urlValue = '';

            showAddUrlSheet();
          },
          icon: Icon(Icons.add),
          label: Text("url_add".tr()),
        ),
      ]),
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
            ProjectsRouter(
              children: [
                ProjectPageRoute(
                  projectId: widget.projectId,
                ),
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

  void fetch() async {
    setState(() => _isLoading = true);

    await fetchMeta();
    await fetchContent();

    setState(() => _isLoading = false);
  }

  Future fetchMeta() async {
    try {
      _projectSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .get();

      _jwt = await FirebaseAuth.instance.currentUser.getIdToken();

      final Map<String, dynamic> data = _projectSnapshot.data();
      final Project project = Project.fromJSON(data);

      setState(() {
        _publicationStatus = project.published ? PUBLISHED : DRAFT;

        _title = project.title;
        _summary = project.summary;

        for (String platform in project.platforms) {
          _platforms[platform] = true;
        }

        for (String tag in project.tags) {
          _platforms[tag] = true;
        }

        for (String pLang in project.programmingLanguages) {
          _platforms[pLang] = true;
        }

        project.urls.map.forEach((key, value) {
          _urls[key] = value;
        });

        _titleController.text = _title;
        _summaryController.text = _summary;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      appLogger.e(error);

      Snack.e(
        context: context,
        message: "saving_error".tr(),
      );
    }
  }

  Future fetchContent() async {
    try {
      final response = await Cloud.fun('projects-fetch').call({
        'projectId': widget.projectId,
        'jwt': _jwt,
      });

      setState(() {
        _content = response.data['project'];
        _contentController.text = _content;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });

      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_fetch_error".tr(),
      );
    }
  }

  void saveContent() async {
    setState(() => _isSaving = true);

    try {
      final resp = await Cloud.fun('projects-save').call({
        'projectId': _projectSnapshot.id,
        'jwt': _jwt,
        'content': _content,
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

  void showAddUrlSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Container(
              width: 900.0,
              padding: EdgeInsets.only(
                top: 40.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    child: Text(
                      "url_add".tr().toUpperCase(),
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 40.0,
                    runSpacing: 20.0,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: 250.0,
                        child: TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: _urlName,
                          ),
                          onChanged: (value) {
                            _urlName = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 320.0,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'https://$_urlName...',
                          ),
                          keyboardType: TextInputType.url,
                          onChanged: (value) {
                            _urlValue = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            _urls[_urlName] = _urlValue;
                            updateUrls();
                            context.router.pop();
                          },
                          icon: Icon(Icons.check),
                          label: Text("url_add".tr()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void updateLang() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'lang': _lang});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }

  void updatePlatforms() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'platforms': _platforms});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }

  void updateProgLanguages() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference
          .update({'programmingLanguages': _programmingLanguages});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }

  void updateSummary() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'summary': _summary});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }

  void updateTags() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'tags': _tags});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }

  void updateTitle() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'title': _title});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => _isSaving = false);
    }
  }

  void updateUrls() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'urls': _urls});

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
      await _projectSnapshot.reference
          .update({'published': status == PUBLISHED});

      setState(() => _isSaving = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        _publicationStatus = prevValue;
        _isSaving = false;
      });
    }
  }
}
