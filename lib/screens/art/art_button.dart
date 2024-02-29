import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utils.dart';

class ArtButton extends StatefulWidget {
  const ArtButton({
    super.key,
    required this.textTitle,
    this.accentColor = Colors.blue,
    this.onPressed,
  });

  final Color accentColor;

  /// Callback fired when button is pressed.
  final void Function()? onPressed;

  /// Title of the button.
  final String textTitle;

  @override
  State<ArtButton> createState() => _ArtButtonState();
}

class _ArtButtonState extends State<ArtButton> {
  Color _shadowColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;

    return TextButton(
      onPressed: widget.onPressed,
      onHover: (bool isHit) {
        setState(() {
          _shadowColor = isHit ? widget.accentColor : Colors.transparent;
        });
      },
      style: TextButton.styleFrom(
        foregroundColor: widget.accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      child: Text(
        widget.textTitle,
        style: Utils.calligraphy.body(
          textStyle: TextStyle(
            fontSize: 64.0,
            fontWeight: FontWeight.w600,
            color: foregroundColor?.withOpacity(0.8),
            shadows: [
              Shadow(
                color: _shadowColor,
                offset: const Offset(-2, 2),
                blurRadius: 2.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
