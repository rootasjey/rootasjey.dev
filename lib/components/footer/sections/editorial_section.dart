import 'package:beamer/beamer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/footer/footer_link.dart';
import 'package:rootasjey/components/footer/footer_section.dart';
import 'package:rootasjey/router/locations/activities_location.dart';
import 'package:rootasjey/router/locations/posts_location.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/types/footer_link_data.dart';

class EditorialSection extends StatelessWidget {
  const EditorialSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FooterSection(
      titleValue: "editorial".tr().toUpperCase(),
      children: getItems(context).map(
        (item) {
          return FooterLink(
            label: item.label,
            onPressed: item.onPressed,
          );
        },
      ).toList(),
    );
  }

  List<FooterLinkData> getItems(BuildContext context) {
    return [
      FooterLinkData(
        label: "posts".tr(),
        onPressed: () => Beamer.of(context).beamToNamed(PostsLocation.route),
      ),
      FooterLinkData(
        label: "projects".tr(),
        onPressed: () => Beamer.of(context).beamToNamed(
          ProjectsLocation.route,
        ),
      ),
      FooterLinkData(
        label: "activity".tr(),
        onPressed: () => Beamer.of(context).beamToNamed(
          ActivitiesLocation.route,
        ),
      ),
    ];
  }
}
