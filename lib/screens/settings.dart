import 'dart:async';

import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rootasjey/components/fade_in_x.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/page_app_bar.dart';
import 'package:rootasjey/router/app_router.gr.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/utils/app_storage.dart';
import 'package:rootasjey/utils/brightness.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/language.dart';
import 'package:supercharged/supercharged.dart';
import 'package:unicons/unicons.dart';

class Settings extends StatefulWidget {
  final bool showAppBar;

  const Settings({
    Key key,
    @PathParam() this.showAppBar = true,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isLoadingLang = false;
  bool isLoadingAvatarUrl = false;
  bool isNameAvailable = false;
  bool isThemeAuto = true;
  bool notificationsON = false;

  Brightness brightness;
  Brightness currentBrightness;

  double beginY = 20.0;

  String avatarUrl = '';
  String imageUrl = '';
  String notifLang = 'en';
  String selectedLang = 'English';

  Timer nameTimer;
  Timer quotidiansNotifTimer;

  ScrollController _pageScrollController = ScrollController();

  @override
  initState() {
    super.initState();
    initBrightness();

    setState(() {
      selectedLang = Language.frontend(stateUser.lang);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        child: CustomScrollView(
          controller: _pageScrollController,
          slivers: <Widget>[
            if (widget.showAppBar) appBar(),
            body(),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    final width = MediaQuery.of(context).size.width;

    if (width < Constants.maxMobileWidth) {
      return PageAppBar(
        textTitle: "settings".tr(),
        textSubTitle: "You can change your preferences here",
        titlePadding: const EdgeInsets.only(top: 16.0),
      );
    }

    return HomeAppBar(
      title: Text("Settings".tr()),
      automaticallyImplyLeading: true,
    );
  }

  Widget accountSettings() {
    return Observer(
      builder: (_) {
        final isUserConnected = stateUser.isUserConnected;

        if (isUserConnected) {
          return Column(
            children: [
              FadeInY(
                delay: 0.milliseconds,
                beginY: 50.0,
                child: avatar(isUserConnected),
              ),
              accountActions(isUserConnected),
              FadeInY(
                delay: 100.milliseconds,
                beginY: 50.0,
                child: updateUsernameButton(isUserConnected),
              ),
              Padding(padding: const EdgeInsets.only(top: 20.0)),
              FadeInY(
                delay: 200.milliseconds,
                beginY: 50.0,
                child: emailButton(),
              ),
              Divider(
                thickness: 1.0,
                height: 50.0,
              ),
            ],
          );
        }

        return Column(
          children: [
            // SizedBox(
            //   width: 450.0,
            //   child: FadeInY(
            //     delay: 1.0,
            //     beginY: beginY,
            //     child: langSelect(),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  Widget accountActions(bool isUserConnected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Wrap(
        spacing: 15.0,
        children: <Widget>[
          FadeInX(
            delay: 0.milliseconds,
            beginX: 50.0,
            child: updatePasswordButton(),
          ),
          FadeInX(
            delay: 100.milliseconds,
            beginX: 50.0,
            child: deleteAccountButton(),
          )
        ],
      ),
    );
  }

  Widget appSettings() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          themeSwitcher(),
          Padding(
              padding: const EdgeInsets.only(
            bottom: 100.0,
          )),
        ],
      ),
    );
  }

  Widget avatar(bool isUserConnected) {
    // if (isLoadingImageURL) {
    //   return Padding(
    //     padding: const EdgeInsets.only(
    //       bottom: 30.0,
    //     ),
    //     child: Material(
    //       elevation: 4.0,
    //       shape: CircleBorder(),
    //       clipBehavior: Clip.hardEdge,
    //       child: InkWell(
    //         child: Padding(
    //           padding: const EdgeInsets.all(40.0),
    //           child: CircularProgressIndicator(),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 30.0,
      ),
      child: Material(
        elevation: 4.0,
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Icon(
              UniconsLine.user_circle,
              color: stateColors.primary,
              size: 64.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget body() {
    double paddingTop = 0.0;
    bool showBigTitle = false;

    if (MediaQuery.of(context).size.width > 700.0) {
      paddingTop = widget.showAppBar ? 100.0 : 20.0;
      showBigTitle = true;
    }

    return SliverPadding(
      padding: EdgeInsets.only(top: paddingTop),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (showBigTitle) header(),
          accountSettings(),
          appSettings(),
        ]),
      ),
    );
  }

  Widget deleteAccountButton() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 90.0,
          height: 90.0,
          child: Card(
            elevation: 4.0,
            child: InkWell(
              onTap: () => context.router.push(
                DeleteAccountRoute(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(Icons.delete_outline),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: .8,
          child: Text(
            "account_delete".tr(),
            style: FontsUtils.mainStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        )
      ],
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (context.router.root.stack.length > 1)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                onPressed: context.router.pop,
                icon: Icon(Icons.arrow_back),
              ),
            ),
          Text(
            "settings".tr(),
            style: FontsUtils.boldTitleStyle(),
          ),
        ],
      ),
    );
  }

  Widget emailButton() {
    return TextButton(
      onPressed: () async {
        context.router.push(
          AccountUpdateDeepRoute(
            children: [UpdateEmailRoute()],
          ),
        );
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text(
                  "email".tr(),
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                    ),
                    child: Text(
                      stateUser.email,
                      style: TextStyle(
                        color: stateColors.primary,
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Container(
        width: 250.0,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.alternate_email),
                ),
                Opacity(
                  opacity: .7,
                  child: Text(
                    'Email',
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(
                    stateUser.email,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ppCard({String imageName}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 90.0,
      child: Material(
        elevation: 3.0,
        color: stateColors.softBackground,
        shape: avatarUrl.replaceFirst('local:', '') == imageName
            ? CircleBorder(
                side: BorderSide(
                width: 2.0,
                color: stateColors.primary,
              ))
            : CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            updateImageUrl(imageName: imageName);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
                'assets/images/$imageName-${stateColors.iconExt}.png'),
          ),
        ),
      ),
    );
  }

  Widget updateUsernameButton(bool isUserConnected) {
    return TextButton(
      onPressed: () {
        context.router.push(
          AccountUpdateDeepRoute(
            children: [UpdateUsernameRoute()],
          ),
        );
      },
      child: Container(
        width: 250.0,
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(Icons.person_outline),
                ),
                Opacity(
                  opacity: .7,
                  child: Text("username".tr()),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(
                    stateUser.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget langSelect() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ListTile(
        leading: Icon(Icons.language),
        subtitle: Text("language_app_select".tr()),
        title: DropdownButton<String>(
          elevation: 3,
          value: selectedLang,
          isDense: true,
          icon: Container(),
          underline: Container(),
          style: TextStyle(
            color: stateColors.foreground,
            fontFamily: GoogleFonts.raleway().fontFamily,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (String newValue) {
            setState(() {
              selectedLang = newValue;
            });

            updateLang();
          },
          items: ['English', 'Français'].map((String value) {
            return DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                ));
          }).toList(),
        ),
      ),
    );
  }

  Widget themeSwitcher() {
    return Container(
      width: 400.0,
      padding: EdgeInsets.only(
        bottom: 60.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeInY(
            delay: 0.milliseconds,
            beginY: 10.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "theme".tr(),
                    style: FontsUtils.mainStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: stateColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FadeInY(
            delay: 100.milliseconds,
            beginY: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  themeDescription(),
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          FadeInY(
            delay: 200.milliseconds,
            beginY: 10.0,
            child: SwitchListTile(
              title: Text("theme_automatic".tr()),
              secondary: const Icon(Icons.autorenew),
              value: isThemeAuto,
              onChanged: (newValue) {
                setState(() => isThemeAuto = newValue);

                if (newValue) {
                  BrightnessUtils.setAutoBrightness(context);
                  return;
                }

                currentBrightness = appStorage.getBrightness();
                BrightnessUtils.setBrightness(context, currentBrightness);
              },
            ),
          ),
          if (!isThemeAuto)
            FadeInY(
              delay: 0.milliseconds,
              beginY: 10.0,
              child: SwitchListTile(
                title: Text("light".tr()),
                secondary: const Icon(Icons.lightbulb_outline),
                value: currentBrightness == Brightness.light,
                onChanged: (newValue) {
                  currentBrightness =
                      newValue ? Brightness.light : Brightness.dark;

                  BrightnessUtils.setBrightness(context, currentBrightness);
                  setState(() {});
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget updatePasswordButton() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 90.0,
          height: 90.0,
          child: Card(
            elevation: 4.0,
            child: InkWell(
              onTap: () {
                context.router.push(
                  AccountUpdateDeepRoute(
                    children: [UpdatePasswordRoute()],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(Icons.lock),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.8,
          child: Text(
            "password_update".tr(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  AlertDialog showAvatarDialog() {
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "cancel".tr().toUpperCase(),
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
      title: Text(
        "profile_picture_choose".tr(),
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Divider(
              thickness: 2.0,
            ),
            SizedBox(
              height: 150.0,
              width: width > 400.0 ? 400.0 : width,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: <Widget>[
                  FadeInX(
                    child: ppCard(
                      imageName: 'boy',
                    ),
                    delay: 100.milliseconds,
                    beginX: 50.0,
                  ),
                  FadeInX(
                    child: ppCard(imageName: 'employee'),
                    delay: 200.milliseconds,
                    beginX: 50.0,
                  ),
                  FadeInX(
                    child: ppCard(imageName: 'lady'),
                    delay: 300.milliseconds,
                    beginX: 50.0,
                  ),
                  FadeInX(
                    child: ppCard(
                      imageName: 'user',
                    ),
                    delay: 400.milliseconds,
                    beginX: 50.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initBrightness() {
    final autoBrightness = appStorage.getAutoBrightness();
    isThemeAuto = autoBrightness;

    if (!autoBrightness) {
      currentBrightness = appStorage.getBrightness();
    } else {
      Brightness brightness = Brightness.light;
      final now = DateTime.now();

      if (now.hour < 6 || now.hour > 17) {
        brightness = Brightness.dark;
      }

      currentBrightness = brightness;
    }
  }

  String themeDescription() {
    return isThemeAuto
        ? "theme_auto_description".tr()
        : "theme_manual_description".tr();
  }

  void updateImageUrl({String imageName}) async {
    setState(() => isLoadingAvatarUrl = true);

    try {
      final userAuth = stateUser.userAuth;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth.uid)
          .update({
        'urls.image': 'local:$imageName',
      });

      setState(() {
        avatarUrl = 'local:$imageName';
        isLoadingAvatarUrl = false;
      });

      Snack.s(
        context: context,
        message: "profile_update_success".tr(),
      );
    } catch (error) {
      appLogger.e(error);

      setState(() => isLoadingAvatarUrl = false);

      Snack.e(
        context: context,
        message: "profile_update_error".tr(),
      );
    }
  }

  void updateLang() async {
    setState(() {
      isLoadingLang = true;
    });

    final lang = Language.backend(selectedLang);

    Language.setLang(lang);

    setState(() {
      isLoadingLang = false;
    });

    Snack.s(
      context: context,
      message: 'Your language has been successfully updated.',
    );
  }
}
