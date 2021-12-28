import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime_type/mime_type.dart';
import 'package:rootasjey/components/application_bar/main_app_bar.dart';
import 'package:rootasjey/components/page_title.dart';
import 'package:rootasjey/components/popup_progress_indicator.dart';
import 'package:rootasjey/router/locations/dashboard_location.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:rootasjey/screens/settings/account_settings.dart';
import 'package:rootasjey/screens/settings/app_settings.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/types/user/user_notifier.dart';
import 'package:rootasjey/types/user_firestore.dart';
import 'package:rootasjey/types/user_pp.dart';
import 'package:rootasjey/types/user_pp_path.dart';
import 'package:rootasjey/types/user_pp_url.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
  bool _isUpdating = false;

  ScrollController _pageScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final largeWidth = !Globals.utils.size.isMobileSize(context);
    final bool showBigTitle = largeWidth ? true : false;

    double paddingTop = 0.0;

    if (largeWidth) {
      paddingTop = widget.showAppBar ? 60.0 : 20.0;
    }

    ref.watch(Globals.state.user);

    final UserFirestore userFirestore = Globals.state.getUserFirestore();
    final UserNotifier userNotifier = ref.read(Globals.state.user.notifier);

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
                      if (showBigTitle)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: PageTitle(
                            textTitle: "settings".tr(),
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                      AccountSettings(
                        isAuthenticated: userNotifier.isAuthenticated,
                        profilePicture: profilePicture,
                        email: userFirestore.email,
                        username: userFirestore.name,
                        onGoToUpdateEmail: onGoToUpdateEmail,
                        onUploadProfilePicture: onUploadProfilePicture,
                        onTapProfilePicture: onTapProfilePicture,
                      ),
                      AppSettings(),
                    ]),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 100.0,
              right: 24.0,
              child: PopupProgressIndicator(
                show: _isUpdating,
                message: "user_updating".tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onGoToUpdateEmail() async {
    Beamer.of(context).beamToNamed(
      DashboardLocationContent.updateEmailRoute,
    );
  }

  void onTapProfilePicture() {
    final UserFirestore userFirestore = Globals.state.getUserFirestore();

    if (userFirestore.pp.url.edited.isEmpty) {
      return;
    }

    NavigationStateHelper.imageToEdit = ExtendedNetworkImageProvider(
      Globals.state.getUserFirestore().pp.url.original,
      cache: true,
      cacheRawData: true,
    );

    Beamer.of(context).beamToNamed(
      DashboardLocationContent.editProfilePictureRoute,
    );
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

    final ext = fileName.substring(fileName.lastIndexOf('.'));

    final metadata = SettableMetadata(
      contentType: mime(fileName),
      customMetadata: {
        'extension': ext,
        'userId': user.uid,
      },
    );

    setState(() => _isUpdating = true);

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
}
