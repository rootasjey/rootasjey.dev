import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/globals/utils.dart';

class IllustrationsPageFab extends StatelessWidget {
  const IllustrationsPageFab({
    super.key,
    this.isVisible = false,
    this.pickFiles,
  });

  /// Display this widget if true.
  final bool isVisible;

  /// Callback fired when the user clicks on the fab.
  final void Function()? pickFiles;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(right: 24.0, bottom: 24.0),
      child: Utils.graphic.tooltip(
        tooltipString: "upload".tr(),
        child: FloatingActionButton(
          onPressed: pickFiles,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: const BorderSide(
              color: Colors.white,
              width: 1.6,
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          child: const Icon(TablerIcons.upload),
        ),
      ),
    );
  }
}
