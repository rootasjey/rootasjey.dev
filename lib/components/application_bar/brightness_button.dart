import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/app_storage.dart';
import 'package:rootasjey/utils/brightness.dart';
import 'package:unicons/unicons.dart';

/// Button contrloing dark/light theme.
class BrightnessButton extends StatelessWidget {
  const BrightnessButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconBrightness = UniconsLine.brightness;
    final autoBrightness = appStorage.getAutoBrightness();

    if (!autoBrightness) {
      final currentBrightness = appStorage.getBrightness();

      iconBrightness = currentBrightness == Brightness.dark
          ? UniconsLine.adjust_half
          : UniconsLine.bright;
    }

    return PopupMenuButton<String>(
      icon: Icon(
        iconBrightness,
        color: stateColors.foreground.withOpacity(0.6),
      ),
      tooltip: "brightness".tr(),
      onSelected: (value) {
        if (value == 'auto') {
          BrightnessUtils.setAutoBrightness(context);
          return;
        }

        final brightness = value == 'dark' ? Brightness.dark : Brightness.light;

        BrightnessUtils.setBrightness(context, brightness);
      },
      itemBuilder: (context) {
        final autoBrightness = appStorage.getAutoBrightness();
        final brightness = autoBrightness ? null : appStorage.getBrightness();

        final primary = stateColors.primary;
        final basic = stateColors.foreground;

        return [
          PopupMenuItem(
            value: 'auto',
            child: ListTile(
              leading: Icon(UniconsLine.brightness),
              title: Text(
                "brightness_auto".tr(),
                style: TextStyle(
                  color: autoBrightness ? primary : basic,
                ),
              ),
              trailing: autoBrightness
                  ? Icon(
                      UniconsLine.check,
                      color: primary,
                    )
                  : null,
            ),
          ),
          PopupMenuItem(
            value: 'dark',
            child: ListTile(
              leading: Icon(UniconsLine.adjust_half),
              title: Text(
                "dark".tr(),
                style: TextStyle(
                  color: brightness == Brightness.dark ? primary : basic,
                ),
              ),
              trailing: brightness == Brightness.dark
                  ? Icon(
                      UniconsLine.check,
                      color: primary,
                    )
                  : null,
            ),
          ),
          PopupMenuItem(
            value: 'light',
            child: ListTile(
              leading: Icon(UniconsLine.bright),
              title: Text(
                "light".tr(),
                style: TextStyle(
                  color: brightness == Brightness.light ? primary : basic,
                ),
              ),
              trailing: brightness == Brightness.light
                  ? Icon(
                      UniconsLine.check,
                      color: primary,
                    )
                  : null,
            ),
          ),
        ];
      },
    );
  }
}
