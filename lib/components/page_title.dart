import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String textTitle;
  final bool isLoading;

  const PageTitle({
    Key key,
    @required this.textTitle,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: context.router.pop,
            icon: Icon(Icons.arrow_back),
          ),
        ),
        Text(
          textTitle,
          style: TextStyle(
            fontSize: 70.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 22.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
