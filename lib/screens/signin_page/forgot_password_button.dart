import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utils.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    super.key,
    this.isMobileSize = false,
    this.accentColor = Colors.amber,
    this.margin = EdgeInsets.zero,
    this.onTap,
  });

  /// Adapt user interface to mobile size if true.
  final bool isMobileSize;

  /// Accent color.
  final Color accentColor;

  /// Spacing around this widget.
  final EdgeInsets margin;

  /// Callback fired to the forgot password page.
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    return Padding(
      padding: margin,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
        ),
        onPressed: onTap,
        child: Opacity(
          opacity: 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "password.forgot".tr(),
                  style: Utils.calligraphy.code(
                    textStyle: TextStyle(
                      color: Colors.transparent,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w200,
                      decoration: TextDecoration.underline,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, -5),
                          color: foregroundColor ?? Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
