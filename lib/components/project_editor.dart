import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rootasjey/components/lang_popup_menu_button.dart';
import 'package:rootasjey/components/main_app_bar.dart';
import 'package:rootasjey/components/pub_popup_menu_button.dart';
import 'package:rootasjey/components/sheet_header.dart';
import 'package:rootasjey/components/sliver_edge_padding.dart';
import 'package:rootasjey/components/sliver_error_view.dart';
import 'package:rootasjey/components/sliver_loading_view.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/flash_helper.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:rootasjey/utils/texts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class ProjectEditor extends StatefulWidget {
  final String projectId;

  const ProjectEditor({
    Key key,
    @required this.projectId,
  }) : super(key: key);
  @override
  _ProjectEditorState createState() => _ProjectEditorState();
}

class _ProjectEditorState extends State<ProjectEditor> {
  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasError = false;
  bool _isMetaVisible = false;

  DocumentSnapshot _projectSnapshot;

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
            metaDataButton(),
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
    if (context.router.root.stack.length < 1) {
      return Container(width: 0.0, height: 0.0);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: IconButton(
        tooltip: "back".tr(),
        onPressed: context.router.pop,
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
        title: "loading_project".tr(),
        padding: const EdgeInsets.only(top: 200.0),
      );
    }

    if (_hasError) {
      return SliverErrorView(
        textTitle: "project_fetch_error".tr(),
      );
    }

    return idleView();
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
    return SizedBox(
      width: 700.0,
      child: Opacity(
        opacity: 0.8,
        child: TextField(
          maxLines: null,
          autofocus: false,
          focusNode: _projectFocusNode,
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          style: FontsUtils.mainStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: "project_story_dot".tr(),
            border: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          onChanged: (newValue) {
            _content = newValue;

            _saveContentTimer?.cancel();
            _saveContentTimer = Timer(1.seconds, updateProjectContent);
          },
        ),
      ),
    );
  }

  Widget deleteButton() {
    return IconButton(
      tooltip: "project_delete".tr(),
      icon: Opacity(
        opacity: 0.6,
        child: Icon(UniconsLine.trash),
      ),
      onPressed: () {
        FlashHelper.deleteDialog(
          context,
          message: "project_delete_description".tr(),
          onConfirm: () async {
            final success = await deleteProject();

            if (success) {
              context.router.navigate(
                DashboardPageRoute(
                  children: [DashProjectsRouter()],
                ),
              );
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

  Widget headerTitle(String textValue) {
    return Opacity(
      opacity: 0.8,
      child: Text(
        textValue,
        style: FontsUtils.mainStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget headerDescription(String textValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 4.0,
        bottom: 8.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Text(
          textValue,
          style: FontsUtils.mainStyle(),
        ),
      ),
    );
  }

  Widget idleView() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
            bottom: 400.0,
          ),
          child: Column(
            children: [
              header(),
              summaryInput(),
              contentInput(),
              buttonToggleMetaView(),
            ],
          ),
        ),
      ]),
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

  Widget metaDataButton() {
    return IconButton(
      tooltip: "project_metadata_edit".tr(),
      onPressed: showMetaDataSheet,
      icon: Opacity(
        opacity: 0.6,
        child: Icon(UniconsLine.file_info_alt),
      ),
    );
  }

  Widget metaDataContainer(StateSetter sheetSetState) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SheetHeader(
                title: "project_metadata".tr(),
                tooltip: "close".tr(),
                subtitle: "project_metadata_description".tr(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    programmingSection(sheetSetState),
                    platformsSection(sheetSetState),
                    tagsSection(sheetSetState),
                    urlsSection(sheetSetState),
                    metaValidationButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget metaValidationButton() {
    return Container(
      width: 200.0,
      padding: const EdgeInsets.only(top: 70.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.black87,
        ),
        onPressed: context.router.pop,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Text("done".tr()),
        ),
      ),
    );
  }

  Widget platformsSection(StateSetter childSetState) {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          platformsHeader(),
          platformsContent(childSetState),
          platformsInput(childSetState),
        ],
      ),
    );
  }

  Widget platformsHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerTitle("platforms".tr()),
        headerDescription("platforms_description".tr()),
      ],
    );
  }

  Widget platformsContent(StateSetter childSetState) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: _platforms.entries.map((entry) {
            return InputChip(
              label: Opacity(
                opacity: 0.8,
                child: Text(getPlatformName(entry.key)),
              ),
              labelStyle: FontsUtils.mainStyle(fontWeight: FontWeight.w700),
              elevation: entry.value ? 2.0 : 0.0,
              selected: entry.value,
              deleteIconColor: entry.value
                  ? stateColors.secondary.withOpacity(0.8)
                  : Colors.black26,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              checkmarkColor: Colors.black26,
              onDeleted: () {
                removePlatformAndUpdate(childSetState, entry);
              },
              onSelected: (isSelected) {
                togglePlatformAndUpdate(
                  childSetState,
                  entry,
                  isSelected,
                );
              },
            );
          }).toList()),
    );
  }

  Widget platformsInput(StateSetter childSetState) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300.0,
            child: TextFormField(
              controller: _platformController,
              decoration: InputDecoration(
                labelText: "platform_new".tr(),
                border: UnderlineInputBorder(),
              ),
              onChanged: (value) {
                _platformInputValue = value.toLowerCase();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Opacity(
              opacity: 0.6,
              child: IconButton(
                tooltip: "platform_add".tr(),
                icon: Icon(UniconsLine.check),
                onPressed: () {
                  addPlatformAndUpdate(childSetState);
                },
              ),
            ),
          ),
        ],
      ),
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
                            "project_updating".tr(),
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

  Widget programmingSection(StateSetter childSetState) {
    return SizedBox(
      width: 600.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          programmnigHeader(),
          programmnigContent(childSetState),
          programmnigInput(childSetState),
        ],
      ),
    );
  }

  Widget programmnigHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerTitle("programming_languages".tr()),
        headerDescription("programming_languages_description".tr()),
      ],
    );
  }

  Widget programmnigContent(StateSetter childSetState) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: _programmingLanguages.entries.map((entry) {
          return InputChip(
            label: Opacity(
              opacity: 0.8,
              child: Text(
                entry.key,
                style: FontsUtils.mainStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            deleteIconColor: stateColors.secondary.withOpacity(0.8),
            labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            onDeleted: () {
              removeProLangAndUpdate(childSetState, entry.key);
            },
          );
        }).toList(),
      ),
    );
  }

  Widget programmnigInput(StateSetter childSetState) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300.0,
            child: TextFormField(
              controller: _pLangController,
              decoration: InputDecoration(
                labelText: "programming_language_new_dot".tr(),
                border: UnderlineInputBorder(),
                fillColor: Colors.white,
                focusColor: stateColors.clairPink,
              ),
              onChanged: (value) {
                _pLangInputValue = value;
              },
              onFieldSubmitted: (value) {
                addProLangAndUpdate(childSetState);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              tooltip: "add".tr(),
              icon: Opacity(
                opacity: 0.6,
                child: Icon(UniconsLine.check),
              ),
              onPressed: () {
                addProLangAndUpdate(childSetState);
              },
            ),
          ),
        ],
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
        updateProjectContent();
      },
    );
  }

  Widget summaryInput() {
    return SizedBox(
      width: 700.0,
      child: TextField(
        maxLines: null,
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

          _saveSummaryTimer?.cancel();
          _saveSummaryTimer = Timer(1.seconds, () => updateSummary());
        },
      ),
    );
  }

  Widget tagsSection(StateSetter childSetState) {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tagsHeader(),
          tagsContent(childSetState),
          tagsInput(childSetState),
        ],
      ),
    );
  }

  Widget tagsHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerTitle("tags".tr()),
        headerDescription("tags_description".tr()),
      ],
    );
  }

  Widget tagsContent(StateSetter sheetSetState) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: _tags.entries.map((entry) {
          return InputChip(
            label: Opacity(
              opacity: 0.8,
              child: Text(
                "${entry.key.substring(0, 1).toUpperCase()}"
                "${entry.key.substring(1)}",
              ),
            ),
            labelStyle: FontsUtils.mainStyle(
              fontWeight: FontWeight.w600,
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
            deleteIconColor: stateColors.secondary.withOpacity(0.8),
            onDeleted: () {
              removeTagAndUpdate(sheetSetState, entry);
            },
            onSelected: (isSelected) {},
          );
        }).toList(),
      ),
    );
  }

  Widget tagsInput(StateSetter sheetSetState) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 300.0,
            child: TextFormField(
                controller: _tagController,
                decoration: InputDecoration(
                  labelText: "tag_new_dot".tr(),
                  border: UnderlineInputBorder(),
                ),
                onChanged: (value) {
                  _tagInputValue = value.toLowerCase();
                },
                onFieldSubmitted: (value) {
                  addTagAndUpdate(sheetSetState);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              tooltip: "tag_add".tr(),
              icon: Opacity(
                opacity: 0.6,
                child: Icon(UniconsLine.check),
              ),
              onPressed: () {
                addTagAndUpdate(sheetSetState);
              },
            ),
          ),
        ],
      ),
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
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: "project_title_dot".tr(),
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

  Widget urlsContent(StateSetter sheetSetState) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: _urls.entries.map((entry) {
        return InputChip(
          label: Opacity(
            opacity: 0.8,
            child: Text(entry.key),
          ),
          labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          labelStyle: FontsUtils.mainStyle(
            fontWeight: FontWeight.w600,
          ),
          selected: entry.value.isNotEmpty,
          checkmarkColor: Colors.black26,
          deleteIconColor: entry.value.isNotEmpty
              ? stateColors.secondary.withOpacity(0.8)
              : Colors.black26,
          onDeleted: () {
            deleteUrlAndUpdate(sheetSetState, entry);
          },
          onPressed: () {
            sheetSetState(() {
              _urlName = entry.key;
              _urlValue = entry.value;
            });
          },
        );
      }).toList(),
    );
  }

  Widget urlsHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          headerTitle("urls_ext".tr()),
          headerDescription("urls_ext_description".tr()),
        ],
      ),
    );
  }

  Widget urlsSection(StateSetter sheetSetState) {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          urlsHeader(),
          urlsContent(sheetSetState),
          editLinkInput(sheetSetState),
        ],
      ),
    );
  }

  Widget editLinkInput(StateSetter sheetSetState) {
    return Padding(
      padding: const EdgeInsets.only(top: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 260.0,
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: _urlName.isNotEmpty ? _urlName : "url_name".tr(),
              ),
              onChanged: (value) {
                _urlName = value;
              },
              onFieldSubmitted: (value) {
                addNewUrlAndUpdate(sheetSetState);
              },
            ),
          ),
          Wrap(
            spacing: 24.0,
            runSpacing: 24.0,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(
                width: 260.0,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'https://$_urlName...',
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (value) {
                    _urlValue = value;
                  },
                ),
              ),
              IconButton(
                tooltip: "url_add".tr(),
                icon: Opacity(
                  opacity: 0.6,
                  child: Icon(UniconsLine.check),
                ),
                onPressed: () {
                  addNewUrlAndUpdate(sheetSetState);
                },
              ),
            ],
          ),
        ],
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
        child: Icon(UniconsLine.eye),
      ),
    );
  }

  void addPlatformAndUpdate(
    StateSetter childSetState,
  ) async {
    setState(() => _isSaving = true);

    childSetState(() {
      _platforms[_platformInputValue] = true;
      _platformController.clear();
    });

    try {
      await _projectSnapshot.reference.update({
        'platforms': _platforms,
      });
    } catch (error) {
      appLogger.e(error);

      childSetState(() {
        _platforms.remove(_platformInputValue);
      });

      Snack.e(
        context: context,
        message: "project_update_platforms_fail".tr(),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void addProLangAndUpdate(StateSetter childSetState) async {
    if (_pLangInputValue.isEmpty) {
      Snack.e(
        context: context,
        message: "input_empty_invalid".tr(),
      );

      return;
    }

    _programmingLanguages[_pLangInputValue] = true;
    _pLangController.clear();

    childSetState(() {});
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference
          .update({'programmingLanguages': _programmingLanguages});
    } catch (error) {
      _programmingLanguages.remove(_pLangInputValue);
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_update_prog_fail".tr(),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void addTagAndUpdate(StateSetter sheetSetState) async {
    if (_tagInputValue.isEmpty) {
      Snack.e(
        context: context,
        message: "input_empty_invalid".tr(),
      );

      return;
    }

    sheetSetState(() {
      _tags[_tagInputValue] = true;
      _tagController.clear();
      _isSaving = true;
    });

    try {
      await _projectSnapshot.reference.update({'tags': _tags});
    } catch (error) {
      appLogger.e(error);
      _tags.remove(_tagInputValue);

      Snack.e(
        context: context,
        message: "project_update_tags_fail".tr(),
      );
    } finally {
      sheetSetState(() => _isSaving = false);
    }
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
      data['id'] = _projectSnapshot.id;

      final Project project = Project.fromJSON(data);

      setState(() {
        _publicationStatus = project.published ? PUBLISHED : DRAFT;

        _title = project.title;
        _summary = project.summary;

        for (String platform in project.platforms) {
          _platforms[platform] = true;
        }

        for (String tag in project.tags) {
          _tags[tag] = true;
        }

        for (String pLang in project.programmingLanguages) {
          _programmingLanguages[pLang] = true;
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

  Future<bool> deleteProject() async {
    bool success = true;
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .delete();
    } catch (error) {
      success = false;
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_delete_failed".tr(),
      );
    } finally {
      setState(() => _isLoading = false);
      return success;
    }
  }

  void updateProjectContent() async {
    setState(() => _isSaving = true);

    try {
      final response = await Cloud.fun('projects-save').call({
        'projectId': _projectSnapshot.id,
        'jwt': _jwt,
        'content': _content,
      });

      bool success = response.data['success'];

      if (!success) {
        throw ErrorDescription(response.data['error']);
      }
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_update_content_fail".tr(),
      );
    } finally {
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
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_update_lang_fail".tr(),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void removePlatformAndUpdate(
    StateSetter sheetSetState,
    MapEntry<String, bool> entry,
  ) async {
    sheetSetState(() {
      _isSaving = true;
      _platforms.remove(entry.key);
    });

    try {
      await _projectSnapshot.reference.update({
        'platforms': _platforms,
      });
    } catch (error) {
      appLogger.e(error);
      _platforms.putIfAbsent(entry.key, () => entry.value);

      Snack.e(
        context: context,
        message: "project_update_platforms_fail".tr(),
      );
    } finally {
      sheetSetState(() => _isSaving = false);
    }
  }

  void removeProLangAndUpdate(StateSetter sheetSetState, String key) async {
    _programmingLanguages.remove(key);
    sheetSetState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference
          .update({'programmingLanguages': _programmingLanguages});
    } catch (error) {
      appLogger.e(error);
      _programmingLanguages.putIfAbsent(key, () => true);

      Snack.e(
        context: context,
        message: "project_update_prog_fail".tr(),
      );
    } finally {
      sheetSetState(() => _isSaving = false);
    }
  }

  void removeTagAndUpdate(
    StateSetter sheetSetState,
    MapEntry<String, bool> entry,
  ) async {
    sheetSetState(() {
      _tags.remove(entry.key);
      _isSaving = true;
    });

    try {
      await _projectSnapshot.reference.update({'tags': _tags});
    } catch (error) {
      appLogger.e(error);
      _tags.putIfAbsent(entry.key, () => entry.value);

      Snack.e(
        context: context,
        message: "project_update_tags_fail".tr(),
      );
    } finally {
      sheetSetState(() => _isSaving = false);
    }
  }

  void showMetaDataSheet() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, childSetState) {
          return metaDataContainer(childSetState);
        },
      ),
    );
  }

  void togglePlatformAndUpdate(
    StateSetter sheetSetState,
    MapEntry<String, bool> entry,
    bool isSelected,
  ) async {
    sheetSetState(() {
      _platforms[entry.key] = isSelected;
      _isSaving = true;
    });

    try {
      await _projectSnapshot.reference.update({
        'platforms': _platforms,
      });
    } catch (error) {
      appLogger.e(error);
      _platforms[entry.key] = !isSelected;

      Snack.e(
        context: context,
        message: "project_update_platforms_fail".tr(),
      );
    } finally {
      sheetSetState(() => _isSaving = false);
    }
  }

  void updateSummary() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'summary': _summary});
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "summary_update_fail".tr(),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void updateTitle() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'title': _title});
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_update_title_fail".tr(),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void addNewUrlAndUpdate(StateSetter sheetSetState) async {
    sheetSetState(() {
      _urls[_urlName] = _urlValue;
      _isSaving = true;
    });

    try {
      await _projectSnapshot.reference.update({'urls': _urls});
    } catch (error) {
      appLogger.e(error);

      _urls.remove(_urlName);

      Snack.e(
        context: context,
        message: "project_update_urls_fail".tr(),
      );
    } finally {
      sheetSetState(() => _isSaving = false);
    }
  }

  void deleteUrlAndUpdate(
    StateSetter sheetSetState,
    MapEntry<String, String> entry,
  ) async {
    sheetSetState(() {
      _urls.remove(entry.key);
      _isSaving = true;
    });

    try {
      await _projectSnapshot.reference.update({'urls': _urls});
    } catch (error) {
      appLogger.e(error);

      _urls.putIfAbsent(entry.key, () => entry.value);

      Snack.e(
        context: context,
        message: "project_update_urls_fail".tr(),
      );
    } finally {
      sheetSetState(() => _isSaving = false);
    }
  }

  void updateUrls() async {
    setState(() => _isSaving = true);

    try {
      await _projectSnapshot.reference.update({'urls': _urls});
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_update_urls_fail".tr(),
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
      await _projectSnapshot.reference
          .update({'published': status == PUBLISHED});
    } catch (error) {
      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_update_pub_fail".tr(),
      );

      _publicationStatus = prevValue;
    } finally {
      setState(() => _isSaving = false);
    }
  }
}
