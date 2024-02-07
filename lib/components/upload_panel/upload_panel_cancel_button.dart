import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/utils.dart';

class UploadPanelCancelButton extends StatelessWidget {
  const UploadPanelCancelButton({
    super.key,
    required this.pendingTaskCount,
    this.margin = const EdgeInsets.only(left: 8.0),
  });

  final int pendingTaskCount;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: CircleButton(
        onTap: () {
          Utils.state.illustrations.cancelAll();
          Utils.state.illustrations.uploadBytesTransferred.set(0);
        },
        tooltip: pendingTaskCount == 0 ? "close".tr() : "cancel".tr(),
        radius: 16.0,
        backgroundColor: Colors.white,
        icon: const Icon(
          TablerIcons.x,
          size: 16.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
