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
import 'package:rootasjey/utils/texts.dart';
import 'package:supercharged/supercharged.dart';

class EditProject extends StatefulWidget {
  final String projectId;

  EditProject({
    this.projectId = '',
  });

  @override
  _EditProjectState createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  bool isLoading = false;
  bool isSaving = false;
  bool hasError = false;

  DocumentSnapshot projectSnapshot;

  final availableLang     = ['en', 'fr'];
  final clearFocusNode    = FocusNode();
  final projectFocusNode  = FocusNode();
  final contentController = TextEditingController();

  final titleFocusNode    = FocusNode();
  final titleController   = TextEditingController();

  final summaryFocusNode  = FocusNode();
  final summaryController = TextEditingController();

  final newPlatformController = TextEditingController();
  final newTagController = TextEditingController();

  var platforms = {
    'android'   : false,
    'androidtv' : false,
    'ios'       : false,
    'ipados'    : false,
    'linux'     : false,
    'macos'     : false,
    'web'       : false,
    'windows'   : false,
  };

  var tags = Map<String, bool>();

  static const PUBLISHED = 'published';
  static const DRAFT = 'draft';

  String publicationStatus = DRAFT;

  String title              = '';
  String content            = '';
  String summary            = '';
  String platformInputValue = '';
  String tagInputValue      = '';
  String lang               = 'en';
  String jwt                = '';

  Timer saveTitleTimer;
  Timer saveSummaryTimer;
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
            title: isSaving
              ? Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircularProgressIndicator(strokeWidth: 2.0,),
                  ),

                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      'Saving...',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: stateColors.foreground,
                      ),
                    ),
                  )
                ],
              )
              : Opacity(
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
                                title,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => FluroRouter.router.pop(context),
                                child: Text('CLOSE'),
                              ),
                            ],
                          );
                        }
                      );
                    },
                    child: Text(
                      title.isEmpty
                        ? 'Edit Project'
                        : title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: stateColors.foreground,
                      ),
                    ),
                  ),
                ),
          ),

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
              actionsInput(),
              titleInput(),
              summaryInput(),
              contentInput(),
              platformsSelection(),
              tagsSelection(),
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
                    "An error occurred. Maybe the project doesn't exist anymore or there's a network issue.",
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ),

              OutlineButton.icon(
                onPressed: () => FluroRouter.router.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.pink),
                label: Opacity(
                  opacity: 0.6,
                  child: Text(
                    'Navigate back',
                    style: TextStyle(
                        fontSize: 16.0,
                      ),
                  ),
                )
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
                'Loading...',
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
                  title = newValue;

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
                  fontWeight: FontWeight.w500,
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
          hintText: 'Project Summary...',
          icon: Icon(Icons.short_text),
          border: OutlineInputBorder(
            borderSide: BorderSide.none
          ),
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

          saveSummaryTimer = Timer(
            1.seconds,
            () => saveSummary()
          );
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
          hintText: "Project's story...",
          border: OutlineInputBorder(
            borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }

  Widget actionsInput() {
    return Container(
      height: 40.0,
      padding: const EdgeInsets.only(
        left: 120.0,
      ),
      child: ListView(
        // spacing: 20.0,
        // alignment: WrapAlignment.start,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          langSelect(),

          Padding(padding: const EdgeInsets.only(right: 20.0)),

          FlatButton.icon(
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
                'Clear content',
              ),
            )
          ),

          Padding(padding: const EdgeInsets.only(right: 20.0)),

          FlatButton.icon(
            focusNode: projectFocusNode,
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

          Padding(padding: const EdgeInsets.only(right: 20.0)),

          publishedDropDown(),
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
          )
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
              'PLATFORMS',
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
        return ChoiceChip(
          label: Text(
            getPlatformName(entry.key),
            style: TextStyle(
              color: entry.value
                ? Colors.white
                : TextStyle().color,
            ),
          ),
          selectedColor: stateColors.primary,
          selected: entry.value,
          onSelected: (isSelected) {
            platforms[entry.key] = isSelected;
            savePlatforms();
          },
        );
      }).toList()
    );
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
              controller: newPlatformController,
              decoration: InputDecoration(
                labelText: 'New platform...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                platformInputValue = value.toLowerCase();
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FlatButton.icon(
              onPressed: () {
                platforms[platformInputValue] = true;
                newPlatformController.clear();
                savePlatforms();
              },
              icon: Icon(Icons.add),
              label: Text('Add platform'),
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
              'TAGS',
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

  Widget tagsSelectionContent() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: tags.entries.map((entry) {
        return ChoiceChip(
          label: Text(
            '${entry.key.substring(0, 1).toUpperCase()}${entry.key.substring(1)}',
            style: TextStyle(
              color: entry.value
                ? Colors.white
                : TextStyle().color,
            ),
          ),
          selectedColor: stateColors.primary,
          selected: entry.value,
          onSelected: (isSelected) {
            tags[entry.key] = isSelected;
            saveTags();
          },
        );
      }).toList()
    );
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
              controller: newTagController,
              decoration: InputDecoration(
                labelText: 'New tag...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                tagInputValue = value.toLowerCase();
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FlatButton.icon(
              onPressed: () {
                tags[tagInputValue] = true;
                newTagController.clear();
                saveTags();
              },
              icon: Icon(Icons.add),
              label: Text('Add tag'),
            ),
          ),
        ],
      ),
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

  Future fetchMeta() async {
    try {
      projectSnapshot = await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .get();

      jwt = await FirebaseAuth.instance
        .currentUser
        .getIdToken();

      final data = projectSnapshot.data();
      final dataPlatforms = data['platforms'] as Map<String, dynamic>;
      final dataTags = data['tags'] as Map<String, dynamic>;

      setState(() {
        publicationStatus = data['published']
          ? PUBLISHED
          : DRAFT;

        title = data['title'];
        summary = data['summary'];

        dataPlatforms.forEach((key, value) {
          platforms[key] = value;
        });

        dataTags.forEach((key, value) {
          tags[key] = value;
        });

        titleController.text = title;
        summaryController.text = summary;
      });

    } catch(error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });

      debugPrint(error.toSring());

      showSnack(
        context: context,
        message: "There was an error while saving.\n${error.toString()}",
        type: SnackType.error,
      );
    }
  }

  Future fetchContent() async {
    try {
      final callable = CloudFunctions(
        app: Firebase.app(),
        region: 'europe-west3',
      ).getHttpsCallable(
        functionName: 'projects-fetch',
      );

      final response = await callable.call({
        'projectId': widget.projectId,
        'jwt': jwt,
      });

      setState(() {
        content = response.data['project'];
        contentController.text = content;
      });

    } catch(error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      debugPrint(error.toSring());

      showSnack(
        context: context,
        message: "There was an error while fetching the project.\n${error.toString()}",
        type: SnackType.error,
      );
    }
  }

  void initAndCheck() async {
    if (widget.projectId.isEmpty) {
      FluroRouter.router.navigateTo(context, RootRoute);
      return;
    }

    final result = await checkAuth();
    if (!result) { return; }

    setState(() => isLoading = true);

    await fetchMeta();
    await fetchContent();

    setState(() => isLoading = false);
  }

  void saveTitle() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot
        .reference
        .update({'title': title});

      setState(() => isSaving = false);

    } catch (error) {
      debugPrint(error.toString());
      setState(() => isSaving = false);
    }
  }

  void saveSummary() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot
        .reference
        .update({'summary': summary});

      setState(() => isSaving = false);

    } catch (error) {
      debugPrint(error.toString());
      setState(() => isSaving = false);
    }
  }

  void saveTags() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot
        .reference
        .update({'tags': tags});

      setState(() => isSaving = false);

    } catch (error) {
      debugPrint(error.toString());
      setState(() => isSaving = false);
    }
  }

  void savePlatforms() async {
    setState(() => isSaving = true);

    try {
      await projectSnapshot
        .reference
        .update({'platforms': platforms});

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
      ).getHttpsCallable(functionName: 'projects-save ');

      final resp = await callable.call({
        'projectId' : projectSnapshot.id,
        'jwt'       : jwt,
        'content'   : content,
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

  void updatePubStatus(String status) async {
    final prevValue = publicationStatus;

    setState(() {
      publicationStatus = status;
      isSaving = true;
    });

    try {
      await projectSnapshot
        .reference
        .update({'published': status == PUBLISHED});

      setState(() => isSaving = false);

    } catch (error) {
      debugPrint(error.toString());
      setState(() {
        publicationStatus = prevValue;
        isSaving = false;
      });
    }
  }
}
