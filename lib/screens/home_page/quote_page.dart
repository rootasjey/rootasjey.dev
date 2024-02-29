import 'package:flutter/material.dart';
import 'package:rootasjey/screens/home_page/quote_text.dart';

class QuotePage extends StatelessWidget {
  const QuotePage({
    super.key,
    this.size = Size.zero,
  });

  /// Window's size.
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 812.0),
          child: const FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuoteText(
                  quoteText: "Le bonheur ne reside pas au kilomètre final "
                      "qui n'existera jamais, mais au kilomètre zéro, "
                      "qui commence a chaque instant.",
                  author: "Shanti",
                  reference: "Kilomètre zero",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
