import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utilities.dart';

class UploadPanelHeaderTitle extends StatelessWidget {
  const UploadPanelHeaderTitle({
    super.key,
    required this.pendingTaskCount,
  });

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
