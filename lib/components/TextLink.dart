import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TextLink extends StatefulWidget {
  final Map<String, String> attributes;
  final dom.Element element;

  const TextLink({
    Key key,
    @required this.attributes,
    @required this.element,
  }) : super(key: key);

  @override
  _TextLinkState createState() => _TextLinkState();
}

class _TextLinkState extends State<TextLink> {
  double opacity = 0.6;
  Color backgroundColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.attributes['href'],
      textStyle: FontsUtils.mainStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: stateColors.background.withOpacity(0.7),
      ),
      child: InkWell(
        onTap: () {
          final String href = widget.attributes['href'];
          if (href == null || href.isEmpty) {
            return;
          }

          launch(widget.attributes['href']);
        },
        onHover: (isHit) {
          setState(() {
            backgroundColor = isHit ? stateColors.primary : Colors.transparent;
            opacity = isHit ? 1.0 : 0.6;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Opacity(
            opacity: opacity,
            child: Text(
              widget.element.innerHtml,
              style: TextStyle(
                fontSize: 22.0,
                backgroundColor: backgroundColor,
                decoration: TextDecoration.underline,
                decorationColor: stateColors.primary,
                decorationStyle: TextDecorationStyle.dotted,
                decorationThickness: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
