import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utilities.dart';

class UploadPanelHeaderTitle extends StatelessWidget {
  const UploadPanelHeaderTitle({
    Key? key,
    required this.pendingTaskCount,
  }) : super(key: key);

  final int pendingTaskCount;

  @override
  Widget build(BuildContext context) {
    final String textValue = pendingTaskCount > 0
        ? "uploading_files".plural(
            pendingTaskCount,
          )
        : "all_done".tr();

    return Text(
      textValue,
      style: Utilities.fonts.body(
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
