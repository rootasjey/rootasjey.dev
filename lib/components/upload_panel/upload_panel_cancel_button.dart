import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:unicons/unicons.dart';

class UploadPanelCancelButton extends ConsumerWidget {
  const UploadPanelCancelButton({
    Key? key,
    required this.pendingTaskCount,
    this.margin = const EdgeInsets.only(left: 8.0),
  }) : super(key: key);

  final int pendingTaskCount;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: margin,
      child: CircleButton(
        onTap: () {
          ref.read(AppState.uploadTaskListProvider.notifier).cancelAll();
          ref.read(AppState.uploadBytesTransferredProvider.notifier).clear();
        },
        tooltip: pendingTaskCount == 0 ? "close".tr() : "cancel".tr(),
        radius: 16.0,
        backgroundColor: Colors.white,
        icon: const Icon(
          UniconsLine.times,
          size: 16.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
