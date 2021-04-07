import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:html/dom.dart' as dom;
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownViewer extends StatefulWidget {
  final String data;
  final double width;

  const MarkdownViewer({
    Key key,
    @required this.data,
    this.width = 500.0,
  }) : super(key: key);

  @override
  _MarkdownViewerState createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  // CodeController _codeController;

  @override
  Widget build(BuildContext context) {
    return Html(
      key: widget.key,
      data: widget.data,
      customRender: {
        'a': (context, child, attributes, element) {
          return textLink(
            href: attributes['href'],
            child: child,
          );
        },
        'code': (context, child, attributes, element) {
          if (attributes.isEmpty) {
            return codeInline(element);
          }

          return codeBlock(attributes, element);
        },
        'img': (context, child, attributes, element) {
          final String attrW = attributes['width'];
          final String attrH = attributes['height'];

          double width = attrW != null ? double.tryParse(attrW) : 300.0;
          double height = attrH != null ? double.tryParse(attrH) : 300.0;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 18.0,
                  right: 8.0,
                ),
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
      style: getElementsCustomStyle(),
    );
  }

  Widget codeInline(dom.Element element) {
    return Material(
      borderRadius: BorderRadius.circular(4.0),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Clipboard.setData(ClipboardData(text: element.innerHtml));
          Snack.s(context: context, message: "copy_success".tr());
        },
        child: SyntaxView(
          code: element.innerHtml,
          syntax: Syntax.JAVASCRIPT,
          syntaxTheme: SyntaxTheme.vscodeDark(),
          fontSize: 12.0,
          withZoom: false,
          withLinesCount: false,
        ),
      ),
    );
  }

  Widget codeBlock(Map<String, String> attributes, dom.Element element) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: element.innerHtml));
            Snack.s(context: context, message: "copy_success".tr());
          },
          child: Text("copy".tr()),
        ),
        Material(
          borderRadius: BorderRadius.circular(4.0),
          clipBehavior: Clip.hardEdge,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black38,
            child: SyntaxView(
              code: element.innerHtml,
              syntax: getSyntax(attributes['class']),
              syntaxTheme: SyntaxTheme.vscodeDark(),
              fontSize: 12.0,
              withZoom: false,
              withLinesCount: true,
            ),
          ),
        ),
      ],
    );
  }

  Map<String, Style> getElementsCustomStyle() {
    return {
      'p': Style(
        width: widget.width,
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
        width: widget.width,
        fontSize: FontSize(60.0),
        fontWeight: FontWeight.w600,
        margin: EdgeInsets.only(
          top: 100.0,
          bottom: 60.0,
        ),
      ),
      'h2': Style(
        width: widget.width,
        fontSize: FontSize(40.0),
        fontWeight: FontWeight.w600,
        margin: EdgeInsets.only(
          top: 80.0,
        ),
      ),
      'h3': Style(
        fontSize: FontSize(30.0),
        fontWeight: FontWeight.w400,
        margin: const EdgeInsets.only(
          top: 80.0,
        ),
      ),
    };
  }

  Syntax getSyntax(String langClass) {
    switch (langClass) {
      case "language-csharp":
        return Syntax.CPP;
      default:
        return Syntax.JAVASCRIPT;
    }
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
