import 'dart:collection';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:rootasjey/components/form_actions_inputs.dart';
import 'package:rootasjey/components/loading_view.dart';
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

  final GlobalKey<ExtendedImageEditorState> _editorKey =
      GlobalKey<ExtendedImageEditorState>();

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isCropping) {
      return LoadingView(
        title: "Cropping your image...",
      );
    }

    if (_isUpdating) {
      return LoadingView(
        title: "Updating your image to the cloud...",
      );
    }

    return idleView();
  }

  Widget idleView() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              Column(
                children: [
                  title(),
                  ExtendedImage(
                    width: 600.0,
                    height: 500.0,
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
                    cancelTextString: "Cancel",
                    onCancel: context.router.pop,
                    onValidate: () {
                      _cropImage(useNativeLib: false);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget imageActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 20.0,
        children: [
          IconButton(
            onPressed: () {
              _editorKey.currentState.rotate(right: false);
            },
            icon: Icon(UniconsLine.crop_alt_rotate_left),
          ),
          IconButton(
            onPressed: () {
              _editorKey.currentState.rotate(right: true);
            },
            icon: Icon(UniconsLine.crop_alt_rotate_right),
          ),
          IconButton(
            onPressed: () {
              _editorKey.currentState.flip();
            },
            icon: Icon(UniconsLine.flip_v),
          ),
          IconButton(
            onPressed: () {
              _editorKey.currentState.reset();
            },
            icon: Icon(UniconsLine.history),
          ),
        ],
      ),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Text(
        "Crop, resize, rotate, flip your profile picture",
        style: FontsUtils.mainStyle(
          fontSize: 24.0,
        ),
      ),
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
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("You're not connected.");
    }

    setState(() => _isUpdating = true);

    final ext = stateUser.userFirestore.pp.ext;

    try {
      final imagePath = "images/users/${user.uid}/pp/edited.$ext";

      final task = FirebaseStorage.instance.ref(imagePath).putData(
          imageData,
          SettableMetadata(
            contentType: mimeFromExtension(ext),
            customMetadata: {
              'extension': ext,
              'userId': user.uid,
            },
          ));

      final snapshot = await task;
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
        context.router.pop();
      }
    } catch (error) {
      appLogger.e(error);
    } finally {
      setState(() => _isUpdating = false);
    }
  }
}
