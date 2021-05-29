import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:unicons/unicons.dart';

class DatesHeader extends StatelessWidget {
  final String createdAt;
  final String updatedAt;
  final EdgeInsets padding;

  const DatesHeader({
    Key key,
    @required this.createdAt,
    this.padding = const EdgeInsets.only(top: 4.0),
    @required this.updatedAt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Wrap(
        spacing: 12.0,
        children: [
          Opacity(
            opacity: 0.7,
            child: Icon(UniconsLine.clock),
          ),
          Opacity(
            opacity: 0.5,
            child: Text(
              "created:",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Text(
              createdAt,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(
            height: 24.0,
            child: VerticalDivider(
              thickness: 2.0,
              color: stateColors.primary,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Text(
              "updated:",
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Text(
              updatedAt,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
