import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/lang_popup_menu_button.dart';
import 'package:rootasjey/components/pub_popup_menu_button.dart';
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

class EditProject extends StatefulWidget {
  final String projectId;

  EditProject({@required @PathParam() this.projectId});

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  bool isLoading = false;
  bool isSaving = false;
  bool hasError = false;
  bool isMetaVisible = false;

  DocumentSnapshot projectSnapshot;

  final clearFocusNode = FocusNode();
  final projectFocusNode = FocusNode();
  final contentController = TextEditingController();

  final titleFocusNode = FocusNode();
  final titleController = TextEditingController();

  final summaryFocusNode = FocusNode();
  final summaryController = TextEditingController();

  final platformController = TextEditingController();
  final tagController = TextEditingController();
  final pLangController = TextEditingController();

  final platforms = {
    'android': false,
    'androidtv': false,
    'ios': false,
    'ipados': false,
    'linux': false,
    'macos': false,
    'web': false,
    'windows': false,
  };

  final programmingLanguages = Map<String, bool>();
  final tags = Map<String, bool>();
  final urls = Map<String, String>();

  static const PUBLISHED = 'published';
  static const DRAFT = 'draft';

  String publicationStatus = DRAFT;

  String title = '';
  String content = '';
  String summary = '';
  String platformInputValue = '';
  String pLangInputValue = '';
  String tagInputValue = '';
  String lang = 'en';
  String jwt = '';
  String urlName = '';
  String urlValue = '';

  Timer saveTitleTimer;
  Timer saveSummaryTimer;
  Timer saveContentTimer;

  @override
  void initState() {
    super.initState();
    fetchData();
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
            LangPopupMenuButton(
              lang: lang,
              onLangChanged: (newLang) {
                setState(() {
                  lang = newLang;
                });
              },
            ),
            viewOnlineButton(),
            saveButton(),
            PubPopupMenuButton(
              status: publicationStatus,
              onStatusChanged: (newStatus) {
                setState(() {
                  publicationStatus = newStatus;
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
          if (isSaving)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          Text(
            title.isEmpty ? "project_edit".tr() : title,
          ),
        ],
      ),
    );
  }

  Widget body() {
    if (isLoading) {
      return SliverLoadingView(
        title: "loading_project".tr(),
        padding: const EdgeInsets.only(top: 200.0),
      );
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
              titleInput(),
              summaryInput(),
              contentInput(),
              buttonToggleMetaView(),
              if (isMetaVisible)
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
          onPressed: () => setState(() => isMetaVisible = !isMetaVisible),
          icon: isMetaVisible
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isMetaVisible ? "meta_data_hide".tr() : "meta_data_show".tr(),
            ),
          ),
        ),
      ),
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
                    "project_fetch_error".tr(),
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
                  )),
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
        focusNode: projectFocusNode,
        controller: contentController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (newValue) {
          content = newValue;

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
        children: platforms.entries.map((entry) {
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
              platforms.remove(entry.key);
              updatePlatforms();
            },
            onSelected: (isSelected) {
              platforms[entry.key] = isSelected;
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
              controller: platformController,
              decoration: InputDecoration(
                labelText: "platform_new".tr(),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                platformInputValue = value.toLowerCase();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton.icon(
              onPressed: () {
                platforms[platformInputValue] = true;
                platformController.clear();
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
        children: programmingLanguages.entries.map((entry) {
          return InputChip(
            label: Text(
              entry.key,
            ),
            onDeleted: () {
              programmingLanguages.remove(entry.key);
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
              controller: pLangController,
              decoration: InputDecoration(
                labelText: "programming_language_new_dot".tr(),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                pLangInputValue = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton.icon(
              onPressed: () {
                programmingLanguages[pLangInputValue] = true;
                pLangController.clear();
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
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: OutlinedButton.icon(
        onPressed: () {
          updateTitle();
          saveContent();
        },
        icon: Opacity(opacity: 0.6, child: Icon(Icons.save)),
        label: Opacity(opacity: 0.6, child: Text("save_draft".tr())),
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
        focusNode: summaryFocusNode,
        controller: summaryController,
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
          summary = newValue;

          if (saveTitleTimer != null) {
            saveSummaryTimer.cancel();
          }

          saveSummaryTimer = Timer(1.seconds, () => updateSummary());
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
        children: tags.entries.map((entry) {
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
              tags.remove(entry.key);
              updateTags();
            },
            onSelected: (isSelected) {
              tags[entry.key] = isSelected;
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
              controller: tagController,
              decoration: InputDecoration(
                labelText: "tag_new_dot".tr(),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                tagInputValue = value.toLowerCase();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton.icon(
              onPressed: () {
                tags[tagInputValue] = true;
                tagController.clear();
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
                focusNode: titleFocusNode,
                controller: titleController,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (newValue) {
                  title = newValue;

                  if (saveTitleTimer != null) {
                    saveTitleTimer.cancel();
                  }

                  saveTitleTimer = Timer(1.seconds, () => updateTitle());
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
          children: urls.entries.map((entry) {
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
                urls.remove(entry.key);
                updateUrls();
              },
              onPressed: () {
                urlName = entry.key;
                urlValue = entry.value;

                showAddUrlSheet();
              },
            );
          }).toList(),
        ),
        TextButton.icon(
          onPressed: () {
            urlName = '';
            urlValue = '';

            showAddUrlSheet();
          },
          icon: Icon(Icons.add),
          label: Text("url_add".tr()),
        ),
      ]),
    );
  }

  Widget viewOnlineButton() {
    if (publicationStatus != PUBLISHED) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          primary: stateColors.foreground,
        ),
        focusNode: clearFocusNode,
        onPressed: () {
          context.router.root.push(
            ProjectsDeepRoute(
              children: [
                ProjectPageRoute(projectId: widget.projectId),
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

  Future fetchMeta() async {
    try {
      projectSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .get();

      jwt = await FirebaseAuth.instance.currentUser.getIdToken();

      final Map<String, dynamic> data = projectSnapshot.data();
      final Project project = Project.fromJSON(data);

      setState(() {
        publicationStatus = project.published ? PUBLISHED : DRAFT;

        title = project.title;
        summary = project.summary;

        for (String platform in project.platforms) {
          platforms[platform] = true;
        }

        for (String tag in project.tags) {
          platforms[tag] = true;
        }

        for (String pLang in project.programmingLanguages) {
          platforms[pLang] = true;
        }

        project.urls.map.forEach((key, value) {
          urls[key] = value;
        });

        titleController.text = title;
        summaryController.text = summary;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
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
        'jwt': jwt,
      });

      setState(() {
        content = response.data['project'];
        contentController.text = content;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });

      appLogger.e(error);

      Snack.e(
        context: context,
        message: "project_fetch_error".tr(),
      );
    }
  }

  void fetchData() async {
    setState(() => isLoading = true);

    await fetchMeta();
    await fetchContent();

    setState(() => isLoading = false);
  }

  void saveContent() async {
    setState(() => isSaving = true);

    try {
      final resp = await Cloud.fun('projects-save').call({
        'projectId': projectSnapshot.id,
        'jwt': jwt,
        'content': content,
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
                            labelText: urlName,
                          ),
                          onChanged: (value) {
                            urlName = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 320.0,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'https://$urlName...',
                          ),
                          keyboardType: TextInputType.url,
                          onChanged: (value) {
                            urlValue = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            urls[urlName] = urlValue;
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

  void updatePlatforms() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'platforms': platforms});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void updateSummary() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'summary': summary});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void updateProgLanguages() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference
          .update({'programmingLanguages': programmingLanguages});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void updateTags() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'tags': tags});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void updateTitle() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'title': title});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void updateUrls() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'urls': urls});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void updatePubStatus(String status) async {
    final prevValue = publicationStatus;

    setState(() {
      publicationStatus = status;
      isSaving = true;
    });

    try {
      await projectSnapshot.reference
          .update({'published': status == PUBLISHED});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);

      setState(() {
        publicationStatus = prevValue;
        isSaving = false;
      });
    }
  }
}
