import 'package:flutter/material.dart';
import 'package:markdown_viewer/markdown_viewer.dart';

class LineReturnSyntax extends MdInlineSyntax {
  LineReturnSyntax() : super(RegExp("\\[line_break]"));

  @override
  MdInlineObject? parse(MdInlineParser parser, Match match) {
    final markers = [parser.consume()];
    final content = parser.consumeBy(match[0]!.length - 1);
    final children = content.map((e) => MdText.fromSpan(e)).toList();

    return MdInlineElement(
      "line_break",
      markers: markers,
      // children: content.map((e) => MdText.fromSpan(e)).toList(),
      children: [MdText.fromString(" ")],
      start: markers.first.start,
      end: children.last.end,
    );
  }
}

class LineReturnBuilder extends MarkdownElementBuilder {
  LineReturnBuilder()
      : super(
          textStyle: const TextStyle(
            color: Colors.green,
            decoration: TextDecoration.underline,
          ),
        );

  @override
  bool isBlock(element) => true;

  @override
  List<String> matchTypes = <String>["line_break"];
}
