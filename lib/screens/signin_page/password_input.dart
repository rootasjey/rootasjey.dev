import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/suffix_button.dart';
import 'package:rootasjey/globals/utils.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.nameController,
    required this.passwordController,
    this.boxConstrains = const BoxConstraints(),
    this.hidePassword = true,
    this.accentColor = Colors.amber,
    this.passwordFocusNode,
    this.onHidePasswordChanged,
    this.onPasswordChanged,
    this.onSubmit,
    this.cancelFocusNode,
    this.margin = EdgeInsets.zero,
  });

  /// Hide password input if true.
  final bool hidePassword;

  /// Constraints for the email input.
  final BoxConstraints boxConstrains;

  /// Accent color.
  final Color accentColor;

  /// Spacing outside of this widget.
  final EdgeInsets margin;

  /// Used to focus the password input.
  final FocusNode? passwordFocusNode;

  /// Focus node for the cancel button.
  final FocusNode? cancelFocusNode;

  /// Callback called when the user wants to hide/show password.
  final void Function(bool value)? onHidePasswordChanged;

  /// Callback fired when typed password changed.
  final void Function(String password)? onPasswordChanged;

  /// Callback fired when the user validate their information and want to signin.
  final void Function(String name, String password)? onSubmit;

  /// Input controller for the name/email.
  final TextEditingController nameController;

  /// Input controller for the password.
  final TextEditingController passwordController;

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
        child: TextField(
          autofocus: false,
          obscureText: hidePassword,
          focusNode: passwordFocusNode,
          onChanged: onPasswordChanged,
          controller: passwordController,
          textInputAction: TextInputAction.go,
          style: Utils.calligraphy.title(
            textStyle: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              height: 1.0,
            ),
          ),
          keyboardType: TextInputType.visiblePassword,
          onSubmitted: (String password) => onSubmit?.call(
            nameController.text,
            password,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: "•••••••••••",
            labelText: "password.name".tr(),
            labelStyle: Utils.calligraphy.body(
              textStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: foregroundColor?.withOpacity(0.6),
              ),
            ),
            contentPadding: const EdgeInsets.all(12.0),
            suffixIcon: SuffixButton(
              icon: Icon(hidePassword ? TablerIcons.eye : TablerIcons.eye_off),
              tooltipString:
                  hidePassword ? "password.show".tr() : "password.hide".tr(),
              onPressed: () => onHidePasswordChanged?.call(!hidePassword),
            ),
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
