import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/locations/search_location.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:unicons/unicons.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 8.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: IconButton(
          tooltip: "search".tr(),
          onPressed: () {
            Beamer.of(context).beamToNamed(SearchLocation.route);
          },
          color: stateColors.foreground,
          icon: Icon(UniconsLine.search),
        ),
      ),
    );
  }
}
