import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

/// A chip showing a plus sign ("+") on initial state,
/// and showing a close sign ("x") othewise.
/// Tapping toggles between plus and close state.
class OpenCloseChip extends StatefulWidget {
  const OpenCloseChip({
    super.key,
    this.onTap,
  });

  final void Function()? onTap;

  @override
  State<OpenCloseChip> createState() => _OpenCloseChipState();
}

class _OpenCloseChipState extends State<OpenCloseChip> with AnimationMixin {
  late Animation<double> angle;
  final Duration _duration = const Duration(milliseconds: 250);
  String _tooltip = "tags_add_show".tr();

  @override
  void initState() {
    super.initState();
    // The AnimationController instance `controller` is already wired up.
    // Just connect with it with the tweens.
    angle = Tween(begin: 0.0, end: ((pi / 4) * 3)).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      tooltip: _tooltip,
      label: Transform.rotate(
        angle: angle.value,
        child: const Text("+"),
      ),
      onPressed: () {
        widget.onTap?.call();

        if (angle.isCompleted) {
          controller.playReverse(duration: _duration);
          _tooltip = "tags_add_show".tr();
          return;
        }

        controller.play(duration: _duration);
        _tooltip = "tags_add_hide".tr();
      },
    );
  }
}
