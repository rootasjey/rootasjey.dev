import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utilities.dart';

class UploadPanelHeaderSubtitle extends StatelessWidget {
  const UploadPanelHeaderSubtitle({
    super.key,
    required this.percent,
    required this.abortedTaskCount,
    required this.successTaskCount,
    required this.runningTaskCount,
    required this.pausedTaskCount,
    required this.pendingTaskCount,
  });

  final int percent;
  final int abortedTaskCount;
  final int successTaskCount;
  final int runningTaskCount;
  final int pausedTaskCount;
  final int pendingTaskCount;

  @override
  Widget build(BuildContext context) {
    if (percent == 0 && pendingTaskCount > 0) {
      return const SizedBox(
        width: 200.0,
        child: LinearProgressIndicator(
          minHeight: 4.0,
        ),
      );
    }

    return Opacity(
      opacity: 0.6,
      child: Text(
        getWindowSubtitle(),
        style: Utilities.fonts.body(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String getWindowSubtitle() {
    if (pendingTaskCount == 0) {
      String text = "upload_count".plural(
        successTaskCount,
      );

      if (abortedTaskCount > 0) {
        text += " ";
        text += "upload_aborted_count".plural(
          abortedTaskCount,
        );
      }

      return text;
    }

    return "$percent %";
  }
}
