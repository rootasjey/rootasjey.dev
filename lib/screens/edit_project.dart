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

  final availableLang = ['en', 'fr'];
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
          homeAppBar(),
          body(),
        ],
      ),
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
              actionsheader(),
              titleInput(),
              summaryInput(),
              contentInput(),
              buttonToggleMetaView(),
              if (isMetaVisible)
                Column(
                  children: [
                    pLangsSelection(),
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
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 80.0,
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => setState(() => isMetaVisible = !isMetaVisible),
            icon: isMetaVisible
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
            label: Text(
              isMetaVisible ? "hide_meta_data".tr() : "meta_data_show".tr(),
            ),
          ),
        ],
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

  Widget homeAppBar() {
    if (isSaving) {
      return HomeAppBar(
        title: Wrap(
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
                "saving".tr(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: stateColors.foreground,
                ),
              ),
            )
          ],
        ),
      );
    }

    return HomeAppBar(
      title: Opacity(
        opacity: 0.6,
        child: TextButton(
          onPressed: showAppBarDialog,
          child: Text(
            title.isEmpty ? "project_edit".tr() : title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: stateColors.foreground,
            ),
          ),
        ),
      ),
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

                  saveTitleTimer = Timer(1.seconds, () => saveTitle());
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

          saveSummaryTimer = Timer(1.seconds, () => saveSummary());
        },
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

  Widget actionsheader() {
    return Center(
      child: Container(
        height: 40.0,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            langSelect(),
            Padding(padding: const EdgeInsets.only(right: 20.0)),
            TextButton.icon(
                focusNode: clearFocusNode,
                onPressed: () {
                  content = '';
                  contentController.clear();
                  projectFocusNode.requestFocus();
                },
                icon: Opacity(opacity: 0.6, child: Icon(Icons.clear)),
                label: Opacity(
                  opacity: 0.6,
                  child: Text(
                    "clear_content".tr(),
                  ),
                )),
            Padding(padding: const EdgeInsets.only(right: 20.0)),
            TextButton.icon(
                focusNode: projectFocusNode,
                onPressed: () {
                  saveTitle();
                  saveContent();
                },
                icon: Opacity(opacity: 0.6, child: Icon(Icons.save)),
                label: Opacity(opacity: 0.6, child: Text("save_draft".tr()))),
            Padding(padding: const EdgeInsets.only(right: 20.0)),
            publishedDropDown(),
          ],
        ),
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

  Widget publishedDropDown() {
    return DropdownButton(
      value: publicationStatus,
      underline: Container(),
      onChanged: (value) => updatePubStatus(value),
      items: [DRAFT, PUBLISHED].map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            value.toUpperCase(),
          ),
        );
      }).toList(),
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
              savePlatforms();
            },
            onSelected: (isSelected) {
              platforms[entry.key] = isSelected;
              savePlatforms();
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
                savePlatforms();
              },
              icon: Icon(Icons.add),
              label: Text("platform_add".tr()),
            ),
          ),
        ],
      ),
    );
  }

  Widget pLangsSelection() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 100.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pLangsSelectionHeader(),
          pLangsSelectionContent(),
          pLangsSelectionInput(),
        ],
      ),
    );
  }

  Widget pLangsSelectionHeader() {
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

  Widget pLangsSelectionContent() {
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
              savePLanguages();
            },
          );
        }).toList());
  }

  Widget pLangsSelectionInput() {
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
                savePLanguages();
              },
              icon: Icon(Icons.add),
              label: Text("add".tr()),
            ),
          ),
        ],
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
              saveTags();
            },
            onSelected: (isSelected) {
              tags[entry.key] = isSelected;
              saveTags();
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
                saveTags();
              },
              icon: Icon(Icons.add),
              label: Text("tag_add".tr()),
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
                saveUrls();
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

  Future fetchMeta() async {
    try {
      projectSnapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(widget.projectId)
          .get();

      jwt = await FirebaseAuth.instance.currentUser.getIdToken();

      final data = projectSnapshot.data();
      final dataPlatforms = data['platforms'] as Map<String, dynamic>;
      final dataTags = data['tags'] as Map<String, dynamic>;
      final dataUrls = data['urls'] as Map<String, dynamic>;
      final dataLanguages =
          data['programmingLanguages'] as Map<String, dynamic>;

      setState(() {
        publicationStatus = data['published'] ? PUBLISHED : DRAFT;

        title = data['title'];
        summary = data['summary'];

        dataPlatforms?.forEach((key, value) {
          platforms[key] = value;
        });

        dataTags?.forEach((key, value) {
          tags[key] = value;
        });

        dataUrls?.forEach((key, value) {
          urls[key] = value;
        });

        dataLanguages?.forEach((key, value) {
          programmingLanguages[key] = value;
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

  void savePLanguages() async {
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

  void savePlatforms() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'platforms': platforms});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void saveSummary() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'summary': summary});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void saveTags() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'tags': tags});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void saveTitle() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'title': title});

      setState(() => isSaving = false);
    } catch (error) {
      appLogger.e(error);
      setState(() => isSaving = false);
    }
  }

  void saveUrls() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot.reference.update({'urls': urls});

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
                            saveUrls();
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

  void showAppBarDialog() {
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
              title,
            ),
          ),
          actions: [
            TextButton(
              onPressed: context.router.pop,
              child: Text("close".tr().toUpperCase()),
            ),
          ],
        );
      },
    );
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
