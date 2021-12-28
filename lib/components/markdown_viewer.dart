import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:rootasjey/components/text_link.dart';
import 'package:rootasjey/components/image_viewer.dart';
import 'package:rootasjey/utils/snack.dart';

class MarkdownViewer extends StatefulWidget {
  final String data;
  final double width;

  const MarkdownViewer({
    Key? key,
    required this.data,
    this.width = 500.0,
  }) : super(key: key);

  @override
  _MarkdownViewerState createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  @override
  Widget build(BuildContext context) {
    return Html(
      key: widget.key,
      data: widget.data,
      customRender: {
        'a': (RenderContext context, Widget child) {
          final element = context.tree.element;
          final attributes = context.tree.element!.attributes;

          return TextLink(
            attributes: {
              'href': attributes['href'],
            },
            element: element,
          );
        },
        'code': (RenderContext context, Widget child) {
          final element = context.tree.element;
          final attributes = context.tree.element!.attributes;

          if (attributes.isEmpty) {
            return codeInline(element!);
          }

          return codeBlock(attributes, element!);
        },
        'img': (RenderContext context, Widget child) {
          final element = context.tree.element;
          final attributes = context.tree.element!.attributes;

          return ImageViewer(
            attributes: {
              'src': attributes['src'],
              'alt': attributes['alt'],
              'width': attributes['width'],
              'height': attributes['height'],
            },
            element: element,
          );
        },
        'li': (_, Widget child) {
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
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withOpacity(0.8),
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

  Widget codeBlock(Map<Object, String> attributes, dom.Element element) {
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
            color: Color.fromRGBO(30, 30, 30, 1.0),
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
        color: Colors.black.withOpacity(0.7),
        fontSize: FontSize(20.0),
        lineHeight: LineHeight.number(1.5),
        margin: EdgeInsets.only(
          top: 40.0,
          bottom: 20.0,
        ),
      ),
      'ul': Style(
        color: Colors.black.withOpacity(0.7),
        fontSize: FontSize(20.0),
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
        fontFamily: GoogleFonts.nunito(fontWeight: FontWeight.w800).fontFamily,
        fontSize: FontSize(60.0),
        margin: EdgeInsets.only(
          top: 100.0,
          bottom: 40.0,
        ),
      ),
      'h2': Style(
        width: widget.width,
        fontFamily: GoogleFonts.nunito(fontWeight: FontWeight.w700).fontFamily,
        fontSize: FontSize(40.0),
        margin: EdgeInsets.only(
          top: 90.0,
        ),
      ),
      'h3': Style(
        fontFamily: GoogleFonts.nunito(fontWeight: FontWeight.w700).fontFamily,
        fontSize: FontSize(30.0),
        lineHeight: LineHeight.number(0.7),
        margin: const EdgeInsets.only(
          top: 80.0,
        ),
      ),
    };
  }

  Syntax getSyntax(String? langClass) {
    switch (langClass) {
      case "language-csharp":
        return Syntax.CPP;
      default:
        return Syntax.JAVASCRIPT;
    }
  }
}
