import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/language.dart';

class LangPopupMenuButton extends StatelessWidget {
  final String lang;
  final Function(String) onLangChanged;
  final double opacity;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double elevation;

  const LangPopupMenuButton({
    Key key,
    @required this.lang,
    @required this.onLangChanged,
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
        elevation: elevation,
        borderRadius: BorderRadius.circular(4.0),
        child: Opacity(
          opacity: opacity,
          child: PopupMenuButton<String>(
            tooltip: "Change language",
            child: Padding(
              padding: padding,
              child: Text(
                lang.toUpperCase(),
                style: TextStyle(
                  color: stateColors.foreground,
                  fontSize: 16.0,
                ),
              ),
            ),
            onSelected: onLangChanged,
            itemBuilder: (context) => Language.available()
                .map(
                  (value) => PopupMenuItem(
                    value: value,
                    child: Text(value.toUpperCase()),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
