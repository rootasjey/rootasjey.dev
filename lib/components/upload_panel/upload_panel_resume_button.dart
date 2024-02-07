import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/utils.dart';

class UploadPanelResumeButton extends StatelessWidget {
  const UploadPanelResumeButton({
    super.key,
    required this.hide,
  });

  final bool hide;

  @override
  Widget build(BuildContext context) {
    if (hide) {
      return Container();
    }

    return CircleButton(
      onTap: () {
        Utils.state.illustrations.resumeAll();
      },
      radius: 16.0,
      tooltip: "resume".tr(),
      backgroundColor: Colors.white,
      icon: const Icon(
        TablerIcons.player_play,
        size: 16.0,
        color: Colors.black87,
      ),
    );
  }
}
