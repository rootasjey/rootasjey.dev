import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:rootasjey/router/locations/cv_location.dart';
import 'package:rootasjey/types/user/user_social_networks_data.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialNetworks extends StatelessWidget {
  const SocialNetworks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...getNetworks().map(
          (network) {
            return IconButton(
              tooltip: network.tooltip,
              icon: Icon(network.iconData),
              onPressed: () => launch(network.uri),
            );
          },
        ).toList(),
        IconButton(
          tooltip: "CV",
          icon: Icon(UniconsLine.file_exclamation),
          onPressed: () => Beamer.of(context).beamToNamed(CVLocation.route),
        ),
      ],
    );
  }

  List<UserSocialNetworksData> getNetworks() {
    return [
      UserSocialNetworksData(
        tooltip: "GitHub",
        iconData: LineAwesomeIcons.github,
        uri: 'https://github.com/rootasjey',
      ),
      UserSocialNetworksData(
        tooltip: "Twitter",
        iconData: LineAwesomeIcons.twitter,
        uri: 'https://twitter.com/rootasjey',
      ),
      UserSocialNetworksData(
        tooltip: "Instagram",
        iconData: LineAwesomeIcons.instagram,
        uri: 'https://instagram.com/rootasjey',
      ),
      UserSocialNetworksData(
        tooltip: "Medium",
        iconData: LineAwesomeIcons.medium,
        uri: 'https://medium.com/@rootasjey',
      ),
      UserSocialNetworksData(
        tooltip: "Hashnode",
        iconData: LineAwesomeIcons.hashtag,
        uri: 'https://hashnode.com/@rootasjey',
      ),
    ];
  }
}
