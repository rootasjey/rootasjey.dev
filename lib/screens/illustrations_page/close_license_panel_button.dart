import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/globals/utils.dart';

class CloseLicensePanelButton extends StatelessWidget {
  const CloseLicensePanelButton({
    super.key,
    this.margin = EdgeInsets.zero,
    this.onToggleExpandLicensePanel,
  });

  /// Space around this widget.
  final EdgeInsets margin;

  /// Callback fired to close the license panel.
  final void Function()? onToggleExpandLicensePanel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin,
      child: Utils.graphic.tooltip(
        tooltipString: "close".tr(),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2.0,
          child: InkWell(
            onTap: onToggleExpandLicensePanel,
            borderRadius: BorderRadius.circular(24.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                // color: accentColor,
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  TablerIcons.x,
                  size: 12.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
