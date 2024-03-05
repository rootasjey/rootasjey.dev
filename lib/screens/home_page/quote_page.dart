import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/home_page/quote_text.dart';

class QuotePage extends StatelessWidget {
  const QuotePage({
    super.key,
    required this.quoteName,
    this.quoteAuthor = "",
    this.quoteReference = "",
    this.size = Size.zero,
  });

  /// Window's size.
  final Size size;

  /// Quote's content.
  final String quoteName;

  /// Quote's author.
  final String quoteAuthor;

  /// Quote's reference.
  final String quoteReference;

  @override
  Widget build(BuildContext context) {
    final bool useTinyText = Utils.measurements.isMobileSize(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 812.0),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuoteText(
                  quoteText: quoteName,
                  author: quoteAuthor,
                  reference: quoteReference,
                  textStyle: TextStyle(
                    fontSize: useTinyText ? 18.0 : 24.0,
                  ),
                  metaTextStyle: TextStyle(
                    fontSize: useTinyText ? 12.0 : 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
