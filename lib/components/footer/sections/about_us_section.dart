import 'package:beamer/beamer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/footer/footer_link.dart';
import 'package:rootasjey/components/footer/footer_section.dart';
import 'package:rootasjey/router/locations/about_location.dart';
import 'package:rootasjey/router/locations/contact_location.dart';
import 'package:rootasjey/types/footer_link_data.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsSection extends StatelessWidget {
  const AboutUsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FooterSection(
      titleValue: "about".tr().toUpperCase(),
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
        label: "about_us".tr(),
        onPressed: () => Beamer.of(context).beamToNamed(AboutLocation.route),
      ),
      FooterLinkData(
        label: "contact_us".tr(),
        onPressed: () => Beamer.of(context).beamToNamed(ContactLocation.route),
      ),
      FooterLinkData(
        label: "GitHub",
        onPressed: () => launch('https://github.com/rootasjey/rootasjey.dev'),
      ),
    ];
  }
}
