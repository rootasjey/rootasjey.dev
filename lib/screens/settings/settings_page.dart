import 'dart:async';
import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime_type/mime_type.dart';
import 'package:rootasjey/components/application_bar/main_app_bar.dart';
import 'package:rootasjey/components/page_title.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:rootasjey/screens/settings/account_settings.dart';
import 'package:rootasjey/screens/settings/app_settings.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/types/user_pp.dart';
import 'package:rootasjey/types/user_pp_path.dart';
import 'package:rootasjey/types/user_pp_url.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/brightness.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/app_storage.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final bool showAppBar;

  const SettingsPage({
    Key? key,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isThemeAuto = true;
  bool _isUpdating = false;

  Brightness _brightness = Brightness.dark;

  Timer? nameTimer;
  Timer? quotidiansNotifTimer;

  ScrollController _pageScrollController = ScrollController();

  @override
  initState() {
    super.initState();
    initBrightness();
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = 0.0;
    bool showBigTitle = false;

    if (MediaQuery.of(context).size.width > Constants.maxMobileWidth) {
      paddingTop = widget.showAppBar ? 60.0 : 20.0;
      showBigTitle = true;
    }

    ref.watch(Globals.state.user);

    final userNotifier = ref.read(Globals.state.user.notifier);
    final isAuthenticated = userNotifier.isAuthenticated;

    final userFirestore = Globals.state.getUserFirestore();
    final String profilePicture = userNotifier.getPPUrl(
      orElse: "https://img.icons8.com/plasticine/100/000000/flower.png",
    );

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        child: Stack(
          children: [
            CustomScrollView(
              controller: _pageScrollController,
              slivers: <Widget>[
                if (widget.showAppBar) MainAppBar(),
                SliverPadding(
                  padding: EdgeInsets.only(
                    top: paddingTop,
                    bottom: 300.0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (showBigTitle) header(),
                      AccountSettings(
                        isAuthenticated: isAuthenticated,
                        profilePicture: profilePicture,
                        email: userFirestore.email,
                        username: userFirestore.name,
                        onGoToUpdateEmail: () async {
                          Beamer.of(context).beamToNamed(
                            DashboardLocationContent.updateEmailRoute,
                          );
                        },
                        onUploadProfilePicture: onUploadProfilePicture,
                        onTapProfilePicture: () {
                          if (userFirestore.pp.url.edited.isEmpty) {
                            return;
                          }

                          NavigationStateHelper.imageToEdit =
                              ExtendedNetworkImageProvider(
                            Globals.state.getUserFirestore().pp.url.original,
                            cache: true,
                            cacheRawData: true,
                          );

                          Beamer.of(context).beamToNamed(
                            DashboardLocationContent.editProfilePictureRoute,
                          );
                        },
                      ),
                      AppSettings(
                        brightness: _brightness,
                        onChangeBrightness: (newValue) {
                          _brightness =
                              newValue ? Brightness.light : Brightness.dark;

                          BrightnessUtils.setBrightness(context, _brightness);
                          setState(() {});
                        },
                        onChangeThemeAuto: (newValue) {
                          setState(() => _isThemeAuto = newValue);

                          if (newValue) {
                            BrightnessUtils.setAutoBrightness(context);
                            return;
                          }

                          _brightness = appStorage.getBrightness();
                          BrightnessUtils.setBrightness(context, _brightness);
                        },
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            popupProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: PageTitle(
        textTitle: "settings".tr(),
        mainAxisAlignment: MainAxisAlignment.center,
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

  void initBrightness() {
    final autoBrightness = appStorage.getAutoBrightness();
    _isThemeAuto = autoBrightness;

    if (!autoBrightness) {
      _brightness = appStorage.getBrightness();
    } else {
      Brightness brightness = Brightness.light;
      final now = DateTime.now();

      if (now.hour < 6 || now.hour > 17) {
        brightness = Brightness.dark;
      }

      _brightness = brightness;
    }
  }

  String themeDescription() {
    return _isThemeAuto
        ? "theme_auto_description".tr()
        : "theme_manual_description".tr();
  }

  void updateUser() async {
    setState(() => _isUpdating = true);

    try {
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      await Cloud.fun('users-updateUser').call({
        'userId': uid,
        'updatePayload': Globals.state.getUserFirestore().toJSON(),
      });

      setState(() => _isUpdating = false);
    } catch (error) {
      setState(() => _isUpdating = false);
      appLogger.e(error);
    }
  }

  void onUploadProfilePicture() async {
    FilePickerCross choosenFile = await FilePickerCross.importFromStorage(
      type: FileTypeCross.image,
      fileExtension: 'jpg,jpeg,png,gif',
    );

    if (choosenFile.length >= 5 * 1024 * 1024) {
      Snack.e(
        context: context,
        message: "image_size_exceeded".tr(),
      );

      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("user_not_connected".tr());
    }

    final fileName = choosenFile.fileName;
    if (fileName == null) {
      return;
    }

    setState(() => _isUpdating = true);

    final ext = fileName.substring(fileName.lastIndexOf('.'));

    final metadata = SettableMetadata(
      contentType: mime(fileName),
      customMetadata: {
        'extension': ext,
        'userId': user.uid,
      },
    );

    try {
      final response = await Cloud.fun('users-clearProfilePicture').call();
      final bool success = response.data['success'];

      if (!success) {
        throw "Error while calling cloud function.";
      }

      final imagePath = "images/users/${user.uid}/pp/original$ext";

      final task = FirebaseStorage.instance
          .ref(imagePath)
          .putData(choosenFile.toUint8List(), metadata);

      final snapshot = await task;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      final userFirestore = Globals.state.getUserFirestore();

      setState(() {
        userFirestore.urls.setUrl('image', downloadUrl);
        userFirestore.pp.update(
          UserPP(
            ext: ext.replaceFirst('.', ''),
            size: choosenFile.length,
            updatedAt: DateTime.now(),
            path: UserPPPath(original: imagePath),
            url: UserPPUrl(original: downloadUrl),
          ),
        );

        _isUpdating = false;
      });

      updateUser();
    } catch (error) {
      appLogger.e(error);
      setState(() => _isUpdating = false);
    }
  }
}
