import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/upload_panel/upload_card_item.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/custom_upload_task.dart';

/// Body of `UploadPanel`.
class UploadPanelBody extends StatelessWidget {
  const UploadPanelBody({
    super.key,
    required this.expanded,
    required this.uploadTaskList,
    this.onToggleExpanded,
    this.isMobileSize = false,
    this.backgroundColor = Colors.black,
  });

  /// The panel has its maximum size if true. Otherwise the window is minized.
  final bool expanded;

  /// If true, this widget adapts its layout to small screens.
  final bool isMobileSize;

  /// This widget's backgroud color.
  final Color backgroundColor;

  /// List of upload tasks.
  final List<CustomUploadTask> uploadTaskList;

  /// Callback event to expand or minimize upload panel.
  final void Function()? onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 12.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CircleButton(
                margin: const EdgeInsets.only(left: 12.0),
                onTap: () => Navigator.of(context).pop(),
                icon: const Icon(TablerIcons.x),
                tooltip: "close".tr(),
              ),
              Text(
                "downloads".tr(),
                style: Utilities.fonts.body(
                  textStyle: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1.5,
            color: Colors.black12,
            height: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: uploadTaskList.map((CustomUploadTask customUploadTask) {
              return UploadCardItem(
                backgroundColor: backgroundColor,
                customUploadTask: customUploadTask,
                alternativeTheme: isMobileSize,
                onTap: () {},
                onCancel: () {
                  final int bytesTransferred =
                      customUploadTask.task?.snapshot.bytesTransferred ?? 0;

                  Utils.state.illustrations.uploadBytesTransferred
                      .updateValue((value) => value - bytesTransferred);
                  Utils.state.illustrations.cancel(customUploadTask);
                },
                onDone: () {
                  Utils.state.illustrations.removeDone(customUploadTask);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
