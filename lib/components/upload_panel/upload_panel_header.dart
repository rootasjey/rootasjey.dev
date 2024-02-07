import 'package:flutter/material.dart';
import 'package:rootasjey/components/upload_panel/upload_panel_header_buttons.dart';
import 'package:rootasjey/components/upload_panel/upload_panel_header_subtitle.dart';
import 'package:rootasjey/components/upload_panel/upload_panel_header_title.dart';

/// Header of `UploadPanel`.
class UploadPanelHeader extends StatelessWidget {
  const UploadPanelHeader({
    super.key,
    required this.abortedTaskCount,
    required this.pausedTaskCount,
    required this.pendingTaskCount,
    required this.percent,
    required this.runningTaskCount,
    required this.successTaskCount,
  });

  final int abortedTaskCount;
  final int pausedTaskCount;
  final int pendingTaskCount;
  final int percent;
  final int runningTaskCount;
  final int successTaskCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UploadPanelHeaderTitle(
                  pendingTaskCount: pendingTaskCount,
                ),
                UploadPanelHeaderSubtitle(
                  abortedTaskCount: abortedTaskCount,
                  pausedTaskCount: pausedTaskCount,
                  pendingTaskCount: pendingTaskCount,
                  percent: percent,
                  runningTaskCount: runningTaskCount,
                  successTaskCount: successTaskCount,
                ),
              ],
            ),
          ),
          UploadPanelHeaderButtons(
            runningTaskCount: runningTaskCount,
            pausedTaskCount: pausedTaskCount,
            pendingTaskCount: pendingTaskCount,
          ),
        ],
      ),
    );
  }
}
