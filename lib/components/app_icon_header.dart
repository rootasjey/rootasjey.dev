import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/router/route_names.dart';
import 'package:rootasjey/router/router.dart';
import 'package:rootasjey/state/colors.dart';

class AppIconHeader extends StatefulWidget {
  final Function onTap;
  final EdgeInsetsGeometry padding;
  final double size;

  AppIconHeader({
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 80.0),
    this.size = 60.0,
  });

  @override
  _AppIconHeaderState createState() => _AppIconHeaderState();
}

class _AppIconHeaderState extends State<AppIconHeader> {
  Color foreground;
  ReactionDisposer colorDisposer;

  @override
  initState() {
    super.initState();

    colorDisposer = autorun((reaction) {
      setState(() => foreground = stateColors.foreground);
    });
  }

  @override
  void dispose() {
    if (colorDisposer != null) {
      colorDisposer();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Material(
        shape: RoundedRectangleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap
            ?? () => FluroRouter.router.navigateTo(context, RootRoute),
          onLongPress: () => showFooter(),
          onHover: (isHover) {
            isHover
              ? setState(() => foreground = stateColors.primary)
              : setState(() => foreground = stateColors.foreground);
          },
          child: Text(
            '>r.',
            style: TextStyle(
              fontSize: 30.0,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }

  void showFooter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Footer(closeModalOnNav: true,);
      },
    );
  }
}
