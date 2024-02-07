import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_toggle_item.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';

class LangPopupMenuButton extends StatelessWidget {
  const LangPopupMenuButton({
    super.key,
    required this.lang,
    required this.onLangChanged,
    this.elevation = 0.0,
    this.opacity = 1.0,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(8.0),
    this.outlined = false,
    this.asIconButton = false,
  });

  /// If true, show this PopupMenuButton button as an IconButton.
  final bool asIconButton;

  /// If true, the button will be outlined. It will show a text button otherwise.
  final bool outlined;

  /// Current selected language.
  final String lang;

  /// Called when language has changed.
  final Function(String newLanguage) onLangChanged;

  /// Widget's opacity.
  final double opacity;

  /// Widget's margin.
  final EdgeInsets margin;

  /// Widget's padding.
  final EdgeInsets padding;

  /// Widget's elevation.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    Widget? child;

    if (!asIconButton) {
      child = outlined ? outlinedButton(context) : textButton(context);
    }

    return Padding(
      padding: margin,
      child: Material(
        color: Colors.transparent,
        elevation: elevation,
        borderRadius: BorderRadius.circular(6.0),
        clipBehavior: Clip.hardEdge,
        child: Opacity(
          opacity: opacity,
          child: PopupMenuButton<String>(
            tooltip: "language_change".tr(),
            onSelected: onLangChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            itemBuilder: (BuildContext tcontext) {
              int index = 0;

              return Utilities.lang.available().map(
                (final String languageCode) {
                  index++;

                  final bool selected =
                      context.locale.languageCode == languageCode;

                  final Color? color = selected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.6);

                  return PopupMenuToggleItem<String>(
                    delay: Duration(milliseconds: 25 * index),
                    textLabel: Utilities.lang.toFullString(languageCode),
                    newValue: languageCode,
                    selected: selected,
                    foregroundColor: color,
                  );
                },
              ).toList();
            },
            icon: asIconButton
                ? const Icon(
                    TablerIcons.language,
                    // color: Theme.of(context).textTheme.bodyMedium?.color,
                    color: Colors.black,
                  )
                : null,
            child: child,
          ),
        ),
      ),
    );
  }

  Icon? getTrailing(bool selected) {
    final primary = Constants.colors.primary;

    if (selected) {
      return Icon(
        TablerIcons.check,
        color: primary,
      );
    }

    return null;
  }

  Widget outlinedButton(BuildContext context) {
    final Color baseColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4) ??
            Colors.black;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 6.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(
          color: baseColor.withOpacity(0.3),
          width: 2.0,
        ),
      ),
      child: Text(
        Utilities.lang.toFullString(lang),
        style: Utilities.fonts.body(
          textStyle: TextStyle(
            color: baseColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget textButton(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        lang.toUpperCase(),
        style: Utilities.fonts.body(
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
