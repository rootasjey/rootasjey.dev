import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/app_icon.dart';
import 'package:rootasjey/state/colors.dart';

class SimpleAppBar extends StatefulWidget {
  final String textTitle;

  const SimpleAppBar({
    Key key,
    @required this.textTitle,
  }) : super(key: key);

  @override
  _SimpleAppBarState createState() => _SimpleAppBarState();
}

class _SimpleAppBarState extends State<SimpleAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: stateColors.appBackground.withOpacity(1.0),
      title: Row(
        children: [
          AppIcon(
            padding: const EdgeInsets.only(
              left: 80.0,
              right: 40.0,
            ),
            onTap: () => context.router.pop(),
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              widget.textTitle,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: stateColors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
