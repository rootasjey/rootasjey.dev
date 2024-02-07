import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/globals/utils.dart';

class UploadPanelPauseButton extends StatelessWidget {
  const UploadPanelPauseButton({
    super.key,
    required this.hide,
    this.margin = const EdgeInsets.only(),
  });

  final bool hide;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    if (hide) {
      return Container();
    }

    return CircleButton(
      onTap: () {
        Utils.state.illustrations.pauseAll();
      },
      radius: 16.0,
      tooltip: "pause".tr(),
      backgroundColor: Colors.white,
      icon: const Icon(
        TablerIcons.player_pause,
        size: 16.0,
        color: Colors.black87,
      ),
    );
  }
}
