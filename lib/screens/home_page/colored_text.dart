import "package:flutter/material.dart";
import "package:rootasjey/globals/utils.dart";

/// A component to display a text.
class ColoredText extends StatefulWidget {
  const ColoredText({
    super.key,
    // required this.quoteMenuProvider,
    required this.textValue,
    this.tiny = false,
    this.highlightColor,
    this.splashColor,
    this.textColor,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(4.0),
    this.onDoubleTap,
    this.onTap,
    this.textStyle,
    this.textHoverColor = Colors.transparent,
  });

  /// True if this is a mobile size.
  final bool tiny;

  /// Focus color.
  final Color? highlightColor;

  /// Splash color.
  final Color? splashColor;

  /// Text color.
  final Color? textColor;

  /// Text color on hover.
  final Color? textHoverColor;

  /// Space around this widget.
  final EdgeInsets margin;

  /// Space around quote's text.
  final EdgeInsets padding;

  /// Callback fired when this text is tapped.
  final void Function()? onTap;

  /// Callback fired when this text is double tapped.
  final void Function()? onDoubleTap;

  /// Context menu provider for the quote.
  // final FutureOr<Menu?> Function(MenuRequest menuRequest) quoteMenuProvider;

  final String textValue;

  /// Text style.
  final TextStyle? textStyle;

  @override
  State<ColoredText> createState() => _ColoredTextState();
}

class _ColoredTextState extends State<ColoredText> {
  /// Text shadow color.
  final Color _textShadowColor = Colors.transparent;

  Color? _textColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _textColor = widget.textColor;
  }

  @override
  Widget build(BuildContext context) {
    // final bool darkBrightness = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: widget.margin,
        child: InkWell(
          splashColor: widget.splashColor,
          hoverColor: Colors.transparent,
          highlightColor: widget.highlightColor,
          borderRadius: BorderRadius.circular(4.0),
          onTap: widget.onTap,
          onDoubleTap: widget.onDoubleTap,
          onHover: (bool isHover) {
            if (isHover) {
              setState(() => _textColor = widget.textHoverColor);
              // setState(() => _textShadowColor = _topicColor.color);
              return;
            }

            setState(() => _textColor = widget.textColor);
          },
          child: Padding(
            padding: widget.padding,
            child: Text(
              widget.textValue,
              textAlign: TextAlign.start,
              style: Utils.calligraphy
                  .body3(
                    textStyle: TextStyle(
                      fontSize: widget.tiny ? 24.0 : 42.0,
                      fontWeight: FontWeight.w200,
                      color: _textColor,
                      shadows: [
                        Shadow(
                          blurRadius: 0.0,
                          offset: const Offset(-1.0, 1.0),
                          color: _textShadowColor,
                        ),
                      ],
                    ),
                  )
                  .merge(widget.textStyle),
            ),
          ),
        ),
      ),
    );
  }
}
