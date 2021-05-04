import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/components/form_actions_inputs.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/sheet_header.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/urls.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:unicons/unicons.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserFirestore _user = UserFirestore.empty();

  TextEditingController textInputController;

  String _selectedLink = '';

  Urls _tempUserUrls = Urls();

  @override
  initState() {
    super.initState();
    textInputController = TextEditingController();

    fetch();
  }

  @override
  void dispose() {
    textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(
            title: Opacity(
              opacity: 0.6,
              child: Text(
                "profile_my".tr(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: stateColors.foreground,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              body(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget addLinkButton() {
    return SizedBox(
      width: 54.0,
      height: 54.0,
      child: Card(
        child: Tooltip(
          message: "link_add".tr(),
          child: InkWell(
            onTap: showAddLink,
            child: Opacity(
              opacity: 0.6,
              child: Icon(
                UniconsLine.link_add,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget body() {
    final avatarUrl = _user.urls.image.isNotEmpty
        ? _user.urls.image
        : "https://img.icons8.com/plasticine/100/000000/flower.png";

    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 120.0),
        child: BetterAvatar(
          size: 160.0,
          image: NetworkImage(avatarUrl),
          colorFilter: ColorFilter.mode(
            Colors.grey,
            BlendMode.saturation,
          ),
          onTap: () {},
        ),
      ),
      username(),
      job(),
      // location(),
      // summary(),
      Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: [
            location(),
            summaryEditButton(),
            addLinkButton(),
          ],
        ),
      ),
      summary(),
    ]);
  }

  Widget job() {
    return InkWell(
      onTap: showEditJob,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Opacity(
          opacity: 0.6,
          child: Text(
            _user.job,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget location() {
    return Card(
      child: InkWell(
        onTap: showEditLocation,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Opacity(
            opacity: 0.6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(UniconsLine.location_point),
                ),
                Text(
                  _user.location.isEmpty
                      ? "edit_location".tr()
                      : _user.location,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget summary() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: InkWell(
        onTap: showEditSummary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: 0.6,
            child: Text(
              _user.summary,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget summaryEditButton() {
    return Card(
      child: InkWell(
        onTap: showEditSummary,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Opacity(
            opacity: 0.6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(UniconsLine.edit),
                ),
                Text("summary_edit".tr()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget username() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextButton(
        onPressed: () {
          context.router.push(
            DashboardSettingsDeepRoute(
              children: [
                AccountUpdateDeepRoute(
                  children: [UpdateUsernameRoute()],
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Text(
            _user.name,
            style: TextStyle(
              fontSize: 32.0,
            ),
          ),
        ),
      ),
    );
  }

  void fetch() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final HttpsCallableResult<dynamic> resp =
          await Cloud.fun('users-fetchUser').call({'userId': uid});

      final LinkedHashMap<dynamic, dynamic> hashMap =
          LinkedHashMap.from(resp.data);

      final Map<String, dynamic> data = Cloud.convertFromFun(hashMap);

      setState(() => _user = UserFirestore.fromJSON(data));
    } catch (error) {
      appLogger.e(error);
    }
  }

  void showAddLink() {
    textInputController.text = '';

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, childSetState) {
        return addLinkContainer(childSetState);
      }),
    );
  }

  Widget addLinkContainer(void Function(void Function()) childSetState) {
    _tempUserUrls = Urls.fromJSON(_user.urls.map);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              SheetHeader(
                title: "link".tr(),
                tooltip: "close".tr(),
                subtitle: "link_subtitle".tr(),
              ),
              Container(
                width: 600.0,
                padding: EdgeInsets.only(
                  top: 60.0,
                ),
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      controller: textInputController,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: "link_label_text".tr(),
                        icon: Icon(UniconsLine.link),
                      ),
                      onChanged: (_) {
                        childSetState(() {
                          _tempUserUrls.setUrl(
                            _selectedLink,
                            textInputController.text,
                          );
                        });
                      },
                      onSubmitted: (_) {
                        _user.urls.copyFrom(_tempUserUrls);
                        context.router.pop();
                        updateUser();
                      },
                    ),
                    if (textInputController.text.isNotEmpty)
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            left: 32.0,
                          ),
                          child: Opacity(
                            opacity: 0.6,
                            child: TextButton.icon(
                              onPressed: () {
                                childSetState(() {
                                  textInputController.clear();
                                });
                              },
                              icon: Icon(UniconsLine.times),
                              label: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text("clear".tr()),
                              ),
                              style: TextButton.styleFrom(
                                primary: stateColors.foreground,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          _selectedLink.isEmpty
                              ? "link_select_list".tr()
                              : "link_selected_edit".tr(args: [_selectedLink]),
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: _user.urls.profilesMap.entries.map((entry) {
                          return SizedBox(
                            width: 112.0,
                            child: Card(
                              color: _selectedLink == entry.key
                                  ? stateColors.primary
                                  : null,
                              child: InkWell(
                                onTap: () {
                                  childSetState(() {
                                    _selectedLink = entry.key;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Opacity(
                                      opacity: 0.6,
                                      child: Text(
                                        entry.key,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: FormActionInputs(
                          cancelTextString: "cancel".tr(),
                          saveTextString: "done".tr(),
                          onCancel: context.router.pop,
                          onValidate: () {
                            _user.urls.copyFrom(_tempUserUrls);
                            updateUser();
                          },
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

  void showEditJob() {
    textInputController.text = _user.job.isNotEmpty ? _user.job : '';

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, childSetState) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                SheetHeader(
                  title: "job".tr(),
                  tooltip: "close".tr(),
                  subtitle: "job_subtitle".tr(),
                ),
                Container(
                  width: 600.0,
                  padding: EdgeInsets.only(
                    top: 60.0,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        controller: textInputController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: "job_label_text".tr(),
                          icon: Icon(UniconsLine.suitcase),
                        ),
                        onChanged: (_) {
                          childSetState(() {});
                        },
                        onSubmitted: (_) {
                          childSetState(() {
                            _user.job = textInputController.text;
                          });

                          context.router.pop();
                          updateUser();
                        },
                      ),
                      if (textInputController.text.isNotEmpty)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 32.0,
                            ),
                            child: Opacity(
                              opacity: 0.6,
                              child: TextButton.icon(
                                onPressed: () {
                                  childSetState(() {
                                    textInputController.clear();
                                  });
                                },
                                icon: Icon(UniconsLine.times),
                                label: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text("clear".tr()),
                                ),
                                style: TextButton.styleFrom(
                                  primary: stateColors.foreground,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FormActionInputs(
                            cancelTextString: "cancel".tr(),
                            onCancel: context.router.pop,
                            onValidate: () {
                              setState(() {
                                _user.job = textInputController.text;
                              });

                              updateUser();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void showEditLocation() {
    textInputController.text = _user.location.isNotEmpty ? _user.location : '';

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, childSetState) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                SheetHeader(
                  title: "location".tr(),
                  tooltip: "close".tr(),
                  subtitle: "location_subtitle".tr(),
                ),
                Container(
                  width: 600.0,
                  padding: EdgeInsets.only(
                    top: 60.0,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        controller: textInputController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: "location_label_text".tr(),
                          icon: Icon(UniconsLine.location_pin_alt),
                        ),
                        onChanged: (_) {
                          childSetState(() {});
                        },
                        onSubmitted: (_) {
                          childSetState(() {
                            _user.location = textInputController.text;
                          });

                          context.router.pop();
                          updateUser();
                        },
                      ),
                      if (textInputController.text.isNotEmpty)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 32.0,
                            ),
                            child: Opacity(
                              opacity: 0.6,
                              child: TextButton.icon(
                                onPressed: () {
                                  childSetState(() {
                                    textInputController.clear();
                                  });
                                },
                                icon: Icon(UniconsLine.times),
                                label: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text("clear".tr()),
                                ),
                                style: TextButton.styleFrom(
                                  primary: stateColors.foreground,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FormActionInputs(
                            cancelTextString: "cancel".tr(),
                            onCancel: context.router.pop,
                            onValidate: () {
                              setState(() {
                                _user.location = textInputController.text;
                              });
                              updateUser();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void showEditSummary() {
    textInputController.text = _user.summary.isNotEmpty ? _user.summary : '';

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, childSetState) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                SheetHeader(
                  title: "summary".tr(),
                  tooltip: "close".tr(),
                  subtitle: "summary_subtitle".tr(),
                ),
                Container(
                  width: 600.0,
                  padding: EdgeInsets.only(
                    top: 60.0,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        autofocus: true,
                        maxLines: null,
                        controller: textInputController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: "summary_label_text".tr(),
                          icon: Icon(UniconsLine.text),
                        ),
                        onChanged: (newValue) {
                          childSetState(() {});
                        },
                        onSubmitted: (_) {
                          childSetState(() {
                            _user.summary = textInputController.text;
                          });

                          context.router.pop();
                        },
                      ),
                      if (textInputController.text.isNotEmpty)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 32.0,
                            ),
                            child: Opacity(
                              opacity: 0.6,
                              child: TextButton.icon(
                                onPressed: () {
                                  childSetState(() {
                                    textInputController.clear();
                                  });
                                },
                                icon: Icon(UniconsLine.times),
                                label: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text("clear".tr()),
                                ),
                                style: TextButton.styleFrom(
                                  primary: stateColors.foreground,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 40.0,
                        ),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: FormActionInputs(
                            cancelTextString: "cancel".tr(),
                            onCancel: context.router.pop,
                            onValidate: () {
                              setState(() {
                                _user.summary = textInputController.text;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void updateUser() async {
    try {
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      final HttpsCallableResult<dynamic> resp =
          await Cloud.fun('users-updateUser').call({
        'userId': uid,
        'updatePayload': _user.toJSON(),
      });

      final LinkedHashMap<dynamic, dynamic> hashMap =
          LinkedHashMap.from(resp.data);

      final Map<String, dynamic> data = Cloud.convertFromFun(hashMap);

      setState(() => _user = UserFirestore.fromJSON(data));
    } catch (error) {
      appLogger.e(error);
    }
  }
}
