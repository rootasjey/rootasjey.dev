import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/animated_app_icon.dart';

class SliverLoadingView extends StatelessWidget {
  final String title;
  final EdgeInsets padding;

  SliverLoadingView({
    this.title = '',
    this.padding = const EdgeInsets.only(
      top: 260.0,
      left: 24.0,
      right: 24.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    String loadingText = title.isNotEmpty ? title : "loading".tr();

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedAppIcon(
                textTitle: loadingText,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
