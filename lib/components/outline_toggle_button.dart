import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';

class OutlineToggleButton extends StatelessWidget {
  @required final Widget child;
  @required final VoidCallback onPressed;
  final bool selected;

  OutlineToggleButton({
    this.child,
    this.onPressed,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return RaisedButton(
        onPressed: onPressed,
        color: stateColors.primary,
        textColor: Colors.white,
        child: child
      );
    }

    return OutlineButton(
      onPressed: onPressed,
      textColor: stateColors.primary,
      borderSide: BorderSide(
        color: stateColors.primary,
        width: 2.0,
      ),
      child: child,
    );
  }

  factory OutlineToggleButton.icon({
    @required Widget label,
    @required VoidCallback onPressed,
    bool selected,
    @required Widget icon,
  }) = _OutlineToogleButtonWithIcon;
}

class _OutlineToogleButtonWithIcon extends OutlineToggleButton with MaterialButtonWithIconMixin {
  _OutlineToogleButtonWithIcon({
    @required Widget icon,
    @required Widget label,
    @required VoidCallback onPressed,
    bool selected,
  }) : super(
    onPressed: onPressed,
    selected: selected,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon,
        const SizedBox(width: 8.0),
        label,
      ],
    ),
  );
}
