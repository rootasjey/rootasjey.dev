import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utilities.dart';

class DarkOutlinedButton extends StatelessWidget {
  const DarkOutlinedButton({
    super.key,
    required this.child,
    this.accentColor,
    this.margin = EdgeInsets.zero,
    this.onPressed,
    this.selected = false,
  });

  /// This button will be highlited with `accentColor` if this is true.
  final bool selected;

  /// Button's main color (borders, text when selected).
  final Color? accentColor;

  final EdgeInsets margin;

  /// Callback fired when this button is pressed.
  final void Function()? onPressed;

  /// Child widget of this button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color localAccentColor =
        accentColor != null ? accentColor! : primaryColor;
    final Color baseColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6) ??
            Colors.black;

    return Padding(
      padding: margin,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor:
              selected ? localAccentColor : baseColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          side: selected
              ? BorderSide(
                  color: localAccentColor,
                  width: 2.0,
                )
              : null,
          textStyle: Utilities.fonts.body(
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 6.0,
          ),
          child: child,
        ),
      ),
    );
  }
}
