import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/fonts.dart';

class PubPopupMenuButton extends StatelessWidget {
  final String status;
  final Function(String) onStatusChanged;
  final double opacity;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double elevation;

  const PubPopupMenuButton({
    Key key,
    @required this.status,
    @required this.onStatusChanged,
    this.elevation = 0.0,
    this.opacity = 1.0,
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        elevation: elevation,
        color: stateColors.lightBackground,
        borderRadius: BorderRadius.circular(4.0),
        child: Opacity(
          opacity: opacity,
          child: PopupMenuButton<String>(
            tooltip: "publication_change_status".tr(),
            child: Padding(
              padding: padding,
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  status.tr().toUpperCase(),
                  style: FontsUtils.mainStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            onSelected: onStatusChanged,
            itemBuilder: (context) => ["draft", "published"]
                .map(
                  (value) => PopupMenuItem(
                    value: value,
                    child: Text(value.tr()),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
