import 'package:beamer/beamer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/avatar/better_avatar.dart';
import 'package:rootasjey/components/landing/hero/left_side/social_networks.dart';
import 'package:rootasjey/router/locations/about_me_location.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/utils/fonts.dart';

class SocialHero extends StatelessWidget {
  const SocialHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ),
            child: Hero(
              tag: 'pp',
              child: BetterAvatar(
                size: 70.0,
                elevation: 0.0,
                image: AssetImage(
                  'assets/images/jeje.jpg',
                ),
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation,
                ),
                onTap: () => Beamer.of(context).beamToNamed(
                  AboutMeLocation.route,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "rootasjey",
                        style: FontsUtils.mainStyle(
                          color: Globals.constants.colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Opacity(
                        opacity: 0.6,
                        child: Text(
                          "short_bio".tr(),
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SocialNetworks(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
