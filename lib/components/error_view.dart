import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class ErrorView extends StatelessWidget {
  final String textTitle;
  final VoidCallback? onRefresh;

  const ErrorView({
    Key? key,
    this.textTitle = '',
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 200.0,
        left: 40.0,
        right: 40.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Opacity(
              opacity: 0.6,
              child: Icon(
                Icons.sentiment_neutral,
                color: Colors.pink,
                size: 80.0,
              ),
            ),
          ),
          Container(
            width: 600.0,
            padding: const EdgeInsets.only(
              bottom: 40.0,
            ),
            child: Opacity(
              opacity: 0.7,
              child: Text(
                textTitle,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: Icon(UniconsLine.refresh),
          ),
        ],
      ),
    );
  }
}
