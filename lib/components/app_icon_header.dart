import 'package:flutter/material.dart';
import 'package:rootasjey/components/footer/footer.dart';
import 'package:rootasjey/screens/home_page.dart';
import 'package:rootasjey/types/globals/globals.dart';

class AppIconHeader extends StatefulWidget {
  final Function? onTap;
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
  Color? _foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Material(
        shape: RoundedRectangleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap as void Function()? ??
              () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ),
                  ),
          onLongPress: () => showFooter(),
          onHover: (isHover) {
            final colors = Globals.constants.colors;

            setState(() {
              _foregroundColor = isHover
                  ? colors.primary
                  : Theme.of(context).textTheme.bodyText1?.color;
            });
          },
          child: Text(
            '>r.',
            style: TextStyle(
              fontSize: 30.0,
              color: _foregroundColor,
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
        return Footer(
          closeModalOnNav: true,
        );
      },
    );
  }
}
