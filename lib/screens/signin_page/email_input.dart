import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/buttons/cancel_button.dart';
import 'package:rootasjey/globals/utils.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({
    super.key,
    required this.emailController,
    this.boxConstrains = const BoxConstraints(),
    this.accentColor = Colors.amber,
    this.margin = EdgeInsets.zero,
    this.emailFocusNode,
    this.onEmailChanged,
    this.cancelFocusNode,
    this.onTapCancelButtonName,
  });

  /// Constraints for the email input.
  final BoxConstraints boxConstrains;

  /// Accent color.
  final Color accentColor;

  /// Spacing outside of this widget.
  final EdgeInsets margin;

  /// Used to focus the email input.
  final FocusNode? emailFocusNode;

  /// Focus node for the cancel button.
  final FocusNode? cancelFocusNode;

  /// Callback fired when typed email changed.
  final void Function(String email)? onEmailChanged;

  /// Input controller for the name/email.
  final TextEditingController emailController;

  /// Callback fired to unfocus the email input.
  final void Function()? onTapCancelButtonName;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    const double borderWidth = 1.0;
    const double borderWidthFocusFactor = 1.4;
    const BorderRadius nameBorderRadius = BorderRadius.all(
      Radius.circular(24.0),
    );
    final Color nameBorderColor =
        Theme.of(context).dividerColor.withOpacity(0.1);

    return Padding(
      padding: margin,
      child: ConstrainedBox(
        constraints: boxConstrains,
        child: TextFormField(
          maxLines: 1,
          autofocus: false,
          focusNode: emailFocusNode,
          onChanged: onEmailChanged,
          controller: emailController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: Utils.calligraphy.title(
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              height: 1.0,
            ),
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: "steven@universe.galaxy",
            labelText: "email.name".tr(),
            labelStyle: Utils.calligraphy.body(
              textStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: foregroundColor?.withOpacity(0.6),
              ),
            ),
            suffixIcon: CancelButton(
              focusNode: cancelFocusNode,
              show: emailFocusNode?.hasFocus ?? false,
              textStyle: const TextStyle(fontSize: 14.0),
              onTapCancelButton: onTapCancelButtonName,
              buttonStyle: TextButton.styleFrom(
                shape: const StadiumBorder(),
              ),
            ),
            contentPadding: const EdgeInsets.all(12.0),
            hintMaxLines: null,
            border: OutlineInputBorder(
              borderRadius: nameBorderRadius,
              borderSide: BorderSide(
                width: borderWidth,
                color: nameBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: nameBorderRadius,
              borderSide: BorderSide(
                width: borderWidth,
                color: nameBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: nameBorderRadius,
              borderSide: BorderSide(
                width: borderWidth * borderWidthFocusFactor,
                color: accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
