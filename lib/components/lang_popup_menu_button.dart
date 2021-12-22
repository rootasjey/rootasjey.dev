import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/language.dart';

class LangPopupMenuButton extends StatelessWidget {
  final String lang;
  final Function(String) onLangChanged;
  final double opacity;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double elevation;
  final Color color;

  const LangPopupMenuButton({
    Key key,
    @required this.lang,
    @required this.onLangChanged,
    this.color,
    this.elevation = 0.0,
    this.opacity = 1.0,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        color: color ?? Colors.transparent,
        elevation: elevation,
        borderRadius: BorderRadius.circular(4.0),
        child: Opacity(
          opacity: opacity,
          child: PopupMenuButton<String>(
            tooltip: "language_change".tr(),
            child: Padding(
              padding: padding,
              child: Text(
                lang.toUpperCase(),
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: stateColors.foreground,
                ),
              ),
            ),
            onSelected: onLangChanged,
            itemBuilder: (context) => Language.available()
                .map(
                  (value) => PopupMenuItem(
                    value: value,
                    child: Text(Language.frontend(value)),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
