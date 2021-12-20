import 'dart:collection';
import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:rootasjey/components/form_actions_inputs.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/main_app_bar.dart';
import 'package:rootasjey/state/user.dart';
import 'package:rootasjey/types/user_pp_path.dart';
import 'package:rootasjey/types/user_pp_url.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/crop_editor_helper.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:unicons/unicons.dart';

/// A widget to edit an image (crop, resize, flip, rotate).
class EditImagePage extends StatefulWidget {
  /// Image object. Should be defined is navigating from another page.
  /// It's null when reloading the page for example.
  final ImageProvider<Object> image;

  const EditImagePage({
    Key key,
    @required this.image,
  }) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  bool _isCropping = false;
  bool _isUpdating = false;

  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainAppBar(),
          header(),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    Widget child;

    if (_isCropping) {
      child = LoadingView(
        title: "image_cropping".tr(),
      );
    } else if (_isUpdating) {
      child = LoadingView(
        title: "image_update_cloud".tr(),
      );
    } else {
      child = idleView();
    }

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        child,
      ]),
    );
  }

  Widget idleView() {
    return Column(children: [
      ExtendedImage(
        width: 600.0,
        height: 400.0,
        image: widget.image,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: _editorKey,
        initEditorConfigHandler: (state) {
          return EditorConfig(
            maxScale: 8.0,
            cropRectPadding: const EdgeInsets.all(20.0),
            hitTestSize: 20.0,
          );
        },
      ),
      imageActions(),
      FormActionInputs(
        padding: const EdgeInsets.only(
          bottom: 300.0,
        ),
        cancelTextString: "cancel".tr(),
        onCancel: Beamer.of(context).beamBack,
        onValidate: () {
          _cropImage(useNativeLib: false);
        },
      ),
    ]);
  }

  Widget imageActions() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        children: [
          IconButton(
            icon: Icon(UniconsLine.crop_alt_rotate_left),
            onPressed: () {
              _editorKey.currentState.rotate(right: false);
            },
          ),
          IconButton(
            icon: Icon(UniconsLine.crop_alt_rotate_right),
            onPressed: () {
              _editorKey.currentState.rotate(right: true);
            },
          ),
          IconButton(
            icon: Icon(UniconsLine.flip_v),
            onPressed: () {
              _editorKey.currentState.flip();
            },
          ),
          IconButton(
            icon: Icon(UniconsLine.history),
            onPressed: () {
              _editorKey.currentState.reset();
            },
          ),
        ],
      ),
    );
  }

  Widget header() {
    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Opacity(
                      opacity: 0.8,
                      child: IconButton(
                        onPressed: Beamer.of(context).beamBack,
                        icon: Icon(UniconsLine.arrow_left),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: Text(
                          "edit".tr().toUpperCase(),
                          style: FontsUtils.mainStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          "pp".tr(),
                          style: FontsUtils.mainStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 400.0,
                        child: Opacity(
                          opacity: 0.5,
                          child: Text(
                            "pp_description".tr(),
                            style: FontsUtils.mainStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Future<void> _cropImage({bool useNativeLib}) async {
    setState(() => _isCropping = true);

    try {
      Uint8List fileData;

      if (useNativeLib) {
        fileData = await cropImageDataWithNativeLibrary(
          state: _editorKey.currentState,
        );
      } else {
        // Delay due to cropImageDataWithDartLibrary is time consuming on main thread
        // it will block showBusyingDialog
        // if you don't want to block ui, use compute/isolate,but it costs more time.
        // await Future.delayed(Duration(milliseconds: 200));

        // If you don't want to block ui, use compute/isolate,but it costs more time.
        fileData = await cropImageDataWithDartLibrary(
          state: _editorKey.currentState,
        );
      }

      uploadPicture(imageData: fileData);
    } catch (error) {
      appLogger.e(error);
    }
  }

  void uploadPicture({Uint8List imageData}) async {
    final User user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("You're not connected.");
    }

    setState(() => _isUpdating = true);

    final String ext = stateUser.userFirestore.pp.ext;

    try {
      final String imagePath = "images/users/${user.uid}/pp/edited.$ext";

      final UploadTask task = FirebaseStorage.instance.ref(imagePath).putData(
          imageData,
          SettableMetadata(
            contentType: mimeFromExtension(ext),
            customMetadata: {
              'extension': ext,
              'userId': user.uid,
            },
          ));

      final TaskSnapshot snapshot = await task;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        stateUser.userFirestore.urls.setUrl('image', downloadUrl);

        stateUser.userFirestore.pp.merge(
          path: UserPPPath(edited: imagePath),
          url: UserPPUrl(edited: downloadUrl),
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

      final HttpsCallableResult<dynamic> resp =
          await Cloud.fun('users-updateUser').call({
        'userId': uid,
        'updatePayload': stateUser.userFirestore.toJSON(),
      });

      final LinkedHashMap<dynamic, dynamic> hashMap =
          LinkedHashMap.from(resp.data);

      final Map<String, dynamic> data = Cloud.convertFromFun(hashMap);

      if (data != null) {
        Beamer.of(context).beamBack();
      }
    } catch (error) {
      appLogger.e(error);
    } finally {
      setState(() => _isUpdating = false);
    }
  }
}
