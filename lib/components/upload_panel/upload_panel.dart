import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/upload_panel/upload_panel_body.dart';
import 'package:rootasjey/components/upload_panel/upload_panel_header.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/custom_upload_task.dart';

class UploadPanel extends ConsumerStatefulWidget {
  const UploadPanel({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _UploadWindowState();
}

class _UploadWindowState extends ConsumerState<UploadPanel> {
  /// Grow the upload panel to a maxium size if true.
  /// Otherwise minimize the window.
  bool _expanded = false;

  /// Upload's panel current width.
  double _width = 260.0;

  /// Upload's panel current height.
  double _height = 100.0;

  /// Upload's panel initial width.
  final double _initialWidth = 260.0;

  /// Upload's panel initial height.
  final double _initialHeight = 100.0;

  /// Upload's panel maximum possible width.
  final double _maxWidth = 360.0;

  /// Upload's panel maximum possible height.
  final double _maxHeight = 300.0;

  /// Page scroll controller
  final ScrollController _pageScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final bool showUploadWindow = ref.watch(AppState.showUploadWindowProvider);

    if (!showUploadWindow) {
      return Container();
    }

    final List<CustomUploadTask> uploadTaskList = ref.watch(
      AppState.uploadTaskListProvider,
    );

    final taskListNotifier = AppState.uploadTaskListProvider.notifier;
    final int abortedTaskCount = ref.read(taskListNotifier).abortedTaskCount;
    final int successTaskCount = ref.read(taskListNotifier).successTaskCount;
    final int runningTaskCount = ref.read(taskListNotifier).runningTaskCount;
    final int pausedTaskCount = ref.read(taskListNotifier).pausedTaskCount;
    final int pendingTaskCount = ref.read(taskListNotifier).pendingTaskCount;

    final int percent = ref.watch(AppState.uploadPercentageProvider);

    final Size windowSize = MediaQuery.of(context).size;
    final bool isMobileSize =
        windowSize.width < Utilities.size.mobileWidthTreshold;

    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Card(
      margin: EdgeInsets.zero,
      elevation: isMobileSize ? 0.0 : 4.0,
      color: backgroundColor,
      child: AnimatedContainer(
        width: isMobileSize ? windowSize.width : _width,
        height: _height,
        duration: const Duration(milliseconds: 150),
        child: InkWell(
          onTap: isMobileSize
              ? () => onShowBottomSheet(uploadTaskList)
              : onToggleExpanded,
          child: SingleChildScrollView(
            controller: _pageScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UploadPanelHeader(
                  pendingTaskCount: pendingTaskCount,
                  runningTaskCount: runningTaskCount,
                  successTaskCount: successTaskCount,
                  abortedTaskCount: abortedTaskCount,
                  pausedTaskCount: pausedTaskCount,
                  percent: percent,
                ),
                if (!isMobileSize)
                  UploadPanelBody(
                    backgroundColor: backgroundColor,
                    expanded: _expanded,
                    onToggleExpanded: onToggleExpanded,
                    uploadTaskList: uploadTaskList,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onShowBottomSheet(List<CustomUploadTask> uploadTaskList) {
    final bool isMobileSize = Utilities.size.isMobileSize(context);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    Utilities.ui.showAdaptiveDialog(
      context,
      isMobileSize: isMobileSize,
      builder: (BuildContext context) {
        return Material(
          child: UploadPanelBody(
            backgroundColor: backgroundColor,
            expanded: true,
            isMobileSize: isMobileSize,
            onToggleExpanded: onToggleExpanded,
            uploadTaskList: uploadTaskList,
          ),
        );
      },
    );
  }

  void onToggleExpanded() {
    if (_expanded) {
      setState(() {
        _width = _initialWidth;
        _height = _initialHeight;
        _expanded = false;
      });
      return;
    }

    setState(() {
      _width = _maxWidth;
      _height = _maxHeight;
      _expanded = true;
    });
  }
}
