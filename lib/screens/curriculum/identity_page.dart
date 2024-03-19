import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/curriculum/skill_item.dart';
import 'package:rootasjey/types/skill.dart';
import 'package:url_launcher/url_launcher.dart';

class IdentityPage extends StatelessWidget {
  const IdentityPage({
    super.key,
    required this.skills,
    this.isMobileSize = false,
    this.accentColor = Colors.blue,
    this.onTapAvatar,
  });

  /// Adapt UI to mobile size if true.
  final bool isMobileSize;

  /// Accent color.
  final Color accentColor;

  /// Called when the user taps on the avatar.
  final void Function()? onTapAvatar;

  /// List of skills to display.
  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BetterAvatar(
            size: 36.0,
            margin: const EdgeInsets.only(bottom: 12.0),
            borderSide: BorderSide(
              color: accentColor,
              width: 3.0,
            ),
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.saturation,
            ),
            image: const AssetImage(
              "assets/images/jeje.jpg",
            ),
            onTap: onTapAvatar,
          ),
          Text(
            "Jeremie CORPINOT",
            style: Utils.calligraphy.title(
              textStyle: TextStyle(
                fontSize: isMobileSize ? 24.0 : 42.0,
                fontWeight: FontWeight.w600,
                height: 1.0,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
            ),
          ),
          Text(
            "I do mainly work with Flutter and web development.",
            style: Utils.calligraphy.body(
              textStyle: TextStyle(
                fontSize: 14.0,
                color: foregroundColor?.withOpacity(0.6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 24.0,
              bottom: 6.0,
            ),
            child: InkWell(
              onTap: () {
                launchUrl(
                  Uri.parse(
                    "https://goo.gl/maps/Kz8roDPe8brvLpDJ7",
                  ),
                );
              },
              child: Opacity(
                opacity: 0.6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        right: 12.0,
                      ),
                      child: Icon(
                        TablerIcons.location,
                        size: 16.0,
                      ),
                    ),
                    Text(
                      "Yvelines, France",
                      style: Utils.calligraphy.body(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                launchUrl(
                  Uri.parse(
                    "mailto:jerem.freelance@codingbox.fr",
                  ),
                );
              },
              child: Opacity(
                opacity: 0.6,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: Icon(
                        TablerIcons.mail,
                        size: 16.0,
                      ),
                    ),
                    Text(
                      "jerem.freelance@codingbox.fr",
                      style: Utils.calligraphy.body(
                        textStyle: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Wrap(
              spacing: 6.0,
              children: skills.map((Skill skill) {
                return SkillItem(
                  label: skill.label,
                  assetPath: skill.assetPath,
                  iconData: skill.iconData,
                  url: skill.url,
                  blend: skill.blend,
                );
              }).toList(),
            ),
          )
        ]
            .animate(interval: const Duration(milliseconds: 50))
            .fadeIn(
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
            )
            .slideY(
              begin: 2.0,
              end: 0.0,
            ),
      ),
    );
  }
}
