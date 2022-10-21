import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/app_state.dart';
import 'package:unicons/unicons.dart';

class UploadPanelPauseButton extends ConsumerWidget {
  const UploadPanelPauseButton({
    Key? key,
    required this.hide,
    this.margin = const EdgeInsets.only(),
  }) : super(key: key);

  final bool hide;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (hide) {
      return Container();
    }

    return CircleButton(
      onTap: () {
        ref.read(AppState.uploadTaskListProvider.notifier).pauseAll();
      },
      radius: 16.0,
      tooltip: "pause".tr(),
      backgroundColor: Colors.white,
      icon: const Icon(
        UniconsLine.pause,
        size: 16.0,
        color: Colors.black87,
      ),
    );
  }
}
