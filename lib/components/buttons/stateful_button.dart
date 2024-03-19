import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class StatefulButton extends StatefulWidget {
  const StatefulButton({
    super.key,
    required this.icondData,
    this.selected = false,
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.urlString = "",
    this.tooltip = "",
    this.selectedColor,
  });

  /// Whether the button is selected.
  final bool selected;

  /// The color of the button when selected.
  final Color? selectedColor;

  /// Spacing outside of this widget.
  final EdgeInsets margin;

  /// Called when the button is pressed.
  final void Function()? onTap;

  /// The icon data.
  final IconData icondData;

  /// The tooltip.
  final String tooltip;

  /// The url.
  final String urlString;

  @override
  State<StatefulButton> createState() => _StatefulButtonState();
}

class _StatefulButtonState extends State<StatefulButton> {
  double _shakeAnimationTarget = 0.0;

  Color _selectedColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _selectedColor =
        widget.selectedColor ?? Constants.colors.getRandomBackground();

    // if (widget.selected) {
    //   _selectedColor = widget.selectedColor ?? Colors.transparent;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final Color foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final Color selectedForeground =
        _selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final Color iconColor =
        widget.selected ? selectedForeground : foregroundColor;

    return Utils.graphic.tooltip(
      tooltipString: widget.tooltip,
      child: Padding(
        padding: widget.margin,
        child: InkWell(
          borderRadius: BorderRadius.circular(32.0),
          onTap: widget.onTap ?? () => launchUrl(Uri.parse(widget.urlString)),
          onHover: (bool isHit) {
            setState(() {
              _shakeAnimationTarget = isHit ? 1.0 : 0.0;
            });
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              color: widget.selected ? _selectedColor : null,
            ),
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              widget.icondData,
              size: 18.0,
              color: iconColor.withOpacity(0.6),
            ).animate(target: _shakeAnimationTarget).shake(),
          ),
        ),
      ),
    );
  }
}
