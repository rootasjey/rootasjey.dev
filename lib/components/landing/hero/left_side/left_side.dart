import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/landing/hero/left_side/social_hero.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/utils/fonts.dart';

class LeftSide extends StatelessWidget {
  const LeftSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 50.0,
                child: Divider(
                  thickness: 2.0,
                ),
              ),
              Opacity(
                opacity: 0.6,
                child: Text(
                  "Fullstack Web & Mobile",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          Text(
            "flutter_developer".tr(),
            style: FontsUtils.mainStyle(
              fontSize: Globals.utils.size.isMobileSize(context) ? 60.0 : 100.0,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(
            width: 500.0,
            child: Opacity(
              opacity: 0.8,
              child: Text.rich(
                TextSpan(
                  style: FontsUtils.mainStyle(),
                  text: "flutter_developer_description".tr(),
                  children: [
                    TextSpan(
                      text: "flutter_developer_description_options".tr(),
                      style: FontsUtils.mainStyle(
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SocialHero(),
        ],
      ),
    );
  }
}
