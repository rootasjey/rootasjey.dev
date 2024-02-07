import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class PageTitle extends StatelessWidget {
  final String textTitle;
  final bool isLoading;
  final MainAxisAlignment mainAxisAlignment;

  const PageTitle({
    super.key,
    required this.textTitle,
    this.isLoading = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                tooltip: "back".tr(),
                onPressed: Beamer.of(context).beamBack,
                icon: const Icon(TablerIcons.arrow_left),
              ),
            ),
            Text(
              textTitle,
              style: const TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 52.0, left: 22.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
