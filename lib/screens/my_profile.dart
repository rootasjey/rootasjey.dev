import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool _isUpdating = false;

  UserFirestore _user = UserFirestore.empty();

  TextEditingController _textInputController;

  String _selectedLink = '';

  Urls _tempUserUrls = Urls();

  @override
  initState() {
    super.initState();
    _textInputController = TextEditingController();

    fetch();
  }

  @override
  void dispose() {
    _textInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
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
          popupProgressIndicator(),
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

  Widget availableLinks() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: _user.urls.getAvailableLinks().entries.map((entry) {
          return SizedBox(
            width: 50.0,
            height: 50.0,
            child: Tooltip(
              message: entry.key,
              child: InkWell(
                onTap: () => launch(entry.value),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.6,
                      child: getPicLink(entry.key),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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
      availableLinks(),
      Padding(
        padding: const EdgeInsets.only(
          top: 40.0,
        ),
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
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(
        top: 40.0,
        bottom: 300.0,
      ),
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
    _textInputController.text =
        _selectedLink.isEmpty ? '' : _user.urls.map[_selectedLink];

    _tempUserUrls = Urls.fromJSON(_user.urls.map);

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, childSetState) {
        return addLinkContainer(childSetState);
      }),
    );
  }

  Widget addLinkContainer(void Function(void Function()) childSetState) {
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
                    inputLink(childSetState),
                    clearInputButton(childSetState),
                    pageLinkDescription(),
                    gridLinks(childSetState),
                    FormActionInputs(
                      padding: const EdgeInsets.only(
                        top: 40.0,
                        bottom: 200.0,
                      ),
                      cancelTextString: "cancel".tr(),
                      saveTextString: "done".tr(),
                      onCancel: context.router.pop,
                      onValidate: () {
                        appLogger.d(_tempUserUrls.twitter);
                        setState(() {
                          _user.urls.copyFrom(_tempUserUrls);
                        });

                        updateUser();
                      },
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

  Widget clearInputButton(void Function(void Function() p1) childSetState) {
    if (_textInputController.text.isEmpty) {
      return Container(height: 36.0);
    }

    return Align(
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
                _textInputController.clear();
                _tempUserUrls.setUrl(_selectedLink, '');
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
    );
  }

  Widget inputLink(void Function(void Function()) childSetState) {
    return TextField(
      autofocus: true,
      controller: _textInputController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: "link_label_text".tr(),
        icon: Icon(UniconsLine.link),
      ),
      onChanged: (_) {
        childSetState(() {
          _tempUserUrls.setUrl(
            _selectedLink,
            _textInputController.text,
          );
        });
      },
      onSubmitted: (_) {
        setState(() {
          _user.urls.copyFrom(_tempUserUrls);
        });

        context.router.pop();
        updateUser();
      },
    );
  }

  Widget gridLinks(void Function(void Function()) childSetState) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: _user.urls.profilesMap.entries.map((entry) {
          return SizedBox(
            width: 80.0,
            height: 80.0,
            child: Card(
              elevation: _user.urls.profilesMap[entry.key].isEmpty ? 0.0 : 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: BorderSide(
                  width: 2.0,
                  color: _selectedLink == entry.key
                      ? stateColors.primary
                      : Colors.transparent,
                ),
              ),
              child: Tooltip(
                message: entry.key,
                child: InkWell(
                  onTap: () {
                    childSetState(() {
                      _selectedLink = entry.key;
                      _textInputController.text = _user.urls.map[entry.key];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.6,
                        child: getPicLink(entry.key),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget getPicLink(String key) {
    switch (key) {
      case 'artbooking':
        return Image.asset(
          "assets/images/artbooking.png",
          width: 40.0,
          height: 40.0,
        );
      case 'behance':
        return FaIcon(FontAwesomeIcons.behance);
      case 'dribbble':
        return Icon(UniconsLine.dribbble);
      case 'facebook':
        return Icon(UniconsLine.facebook);
      case 'github':
        return Icon(UniconsLine.github);
      case 'gitlab':
        return FaIcon(FontAwesomeIcons.gitlab);
      case 'instagram':
        return Icon(UniconsLine.instagram);
      case 'linkedin':
        return Icon(UniconsLine.linkedin);
      case 'other':
        return Icon(UniconsLine.question);
      case 'tiktok':
        return FaIcon(FontAwesomeIcons.tiktok);
      case 'twitch':
        return FaIcon(FontAwesomeIcons.twitch);
      case 'twitter':
        return Icon(UniconsLine.twitter);
      case 'website':
        return Icon(UniconsLine.globe);
      case 'wikipedia':
        return FaIcon(FontAwesomeIcons.wikipediaW);
      case 'youtube':
        return Icon(UniconsLine.youtube);
      default:
        return Icon(UniconsLine.globe);
    }
  }

  Widget pageLinkDescription() {
    return Padding(
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
    );
  }

  Widget popupProgressIndicator() {
    if (!_isUpdating) {
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
                            "user_updating".tr(),
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

  void showEditJob() {
    _textInputController.text = _user.job.isNotEmpty ? _user.job : '';

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
                        controller: _textInputController,
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
                            _user.job = _textInputController.text;
                          });

                          context.router.pop();
                          updateUser();
                        },
                      ),
                      if (_textInputController.text.isNotEmpty)
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
                                    _textInputController.clear();
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
                                _user.job = _textInputController.text;
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
    _textInputController.text = _user.location.isNotEmpty ? _user.location : '';

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
                        controller: _textInputController,
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
                            _user.location = _textInputController.text;
                          });

                          context.router.pop();
                          updateUser();
                        },
                      ),
                      if (_textInputController.text.isNotEmpty)
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
                                    _textInputController.clear();
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
                                _user.location = _textInputController.text;
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
    _textInputController.text = _user.summary.isNotEmpty ? _user.summary : '';

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
                        controller: _textInputController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText: "summary_label_text".tr(),
                          icon: Icon(UniconsLine.text),
                        ),
                        onChanged: (newValue) {
                          childSetState(() {});
                        },
                        onSubmitted: (_) {
                          setState(() {
                            _user.summary = _textInputController.text;
                          });

                          context.router.pop();
                          updateUser();
                        },
                      ),
                      if (_textInputController.text.isNotEmpty)
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
                                    _textInputController.clear();
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
                                _user.summary = _textInputController.text;
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

  void updateUser() async {
    setState(() => _isUpdating = true);

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

      setState(() => _isUpdating = false);
    } catch (error) {
      setState(() => _isUpdating = false);
      appLogger.e(error);
    }
  }
}
