import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownViewer extends StatelessWidget {
  final String data;
  final double width;

  const MarkdownViewer({
    Key key,
    @required this.data,
    this.width = 500.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      key: key,
      data: data,
      customRender: {
        'a': (context, child, attributes, element) {
          return textLink(
            href: attributes['href'],
            child: child,
          );
        },
        'img': (context, child, attributes, element) {
          double width = double.tryParse(attributes['width']);
          double height = double.tryParse(attributes['height']);

          if (width == null) {
            width = height ?? 300.0;
          }

          if (height == null) {
            height = width ?? 300.0;
          }

          return imageViewer(
            context: context.buildContext,
            src: attributes['src'],
            alt: attributes['alt'],
            width: width,
            height: height,
          );
        },
        'li': (context, child, attributes, element) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipOval(
                  child: Container(
                    width: 10.0,
                    height: 10.0,
                    color: stateColors.foreground.withOpacity(0.8),
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          );
        },
      },
      style: {
        'p': Style(
          width: width,
          fontSize: FontSize(24.0),
          fontWeight: FontWeight.w200,
          lineHeight: LineHeight.number(1.5),
          margin: EdgeInsets.only(
            top: 40.0,
            bottom: 20.0,
          ),
        ),
        'ul': Style(
          fontSize: FontSize(22.0),
          fontWeight: FontWeight.w300,
          lineHeight: LineHeight.number(1.6),
        ),
        'img': Style(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 40.0,
            bottom: 20.0,
          ),
        ),
        'h1': Style(
          width: width,
          fontSize: FontSize(60.0),
          fontWeight: FontWeight.w600,
          margin: EdgeInsets.only(
            top: 100.0,
            bottom: 60.0,
          ),
        ),
        'h2': Style(
          width: width,
          fontSize: FontSize(40.0),
          fontWeight: FontWeight.w600,
          margin: EdgeInsets.only(
            top: 80.0,
            bottom: 40.0,
          ),
        ),
        'h3': Style(
          fontSize: FontSize(30.0),
          fontWeight: FontWeight.w400,
        ),
      },
    );
  }

  Widget imageViewer({
    @required BuildContext context,
    @required String src,
    @required String alt,
    @required double width,
    @required double height,
  }) {
    return Column(
      children: [
        SizedBox(
          height: height > 500.0 ? 500.0 : height,
          child: Ink.image(
            image: NetworkImage(src),
            width: width,
            height: height,
            fit: BoxFit.scaleDown,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      children: [
                        Image.network(src),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
        if (alt != null && alt.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: TextButton(
              onPressed: () => launch(src),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  alt,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget textLink({@required String href, @required Widget child}) {
    return SizedBox(
      height: 40.0,
      child: InkWell(
        onTap: href != null && href.isNotEmpty ? () => launch(href) : null,
        child: child,
      ),
    );
  }
}
