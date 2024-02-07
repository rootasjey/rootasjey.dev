import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/dialogs/themed_dialog.dart';
import 'package:rootasjey/globals/utilities.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
    required this.descriptionValue,
    required this.titleValue,
    this.showCounter = false,
    this.focusNode,
    this.count = 1,
    this.onValidate,
    this.confirmButtonValue,
  });

  /// Show how many items are going to be deleted, if true.
  final bool showCounter;

  /// Used to request focus on mount.
  final FocusNode? focusNode;

  /// Callback fired when we confirm the deletion.
  final void Function()? onValidate;

  /// Number of items is going to be deleted, if true.
  final int count;

  /// Description string value.
  final String descriptionValue;

  /// Validation button's string value.
  final String? confirmButtonValue;

  /// Title string value.
  final String titleValue;

  @override
  Widget build(BuildContext context) {
    return ThemedDialog(
      focusNode: focusNode,
      title: Column(
        children: [
          Opacity(
            opacity: 0.8,
            child: Text(titleValue,
                style: Utilities.fonts.body(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                )),
          ),
          Container(
            width: 300.0,
            padding: const EdgeInsets.only(top: 8.0),
            child: Opacity(
              opacity: 0.4,
              child: Text(descriptionValue,
                  textAlign: TextAlign.center,
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (showCounter)
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Opacity(
                    opacity: 0.6,
                    child: Text(
                      "multi_items_selected".plural(
                        count,
                      ),
                      style: Utilities.fonts.body(
                        textStyle: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      textButtonValidation: confirmButtonValue ?? "delete".tr(),
      onCancel: Beamer.of(context).popRoute,
      onValidate: () {
        onValidate?.call();
        Beamer.of(context).popRoute();
      },
    );
  }
}
