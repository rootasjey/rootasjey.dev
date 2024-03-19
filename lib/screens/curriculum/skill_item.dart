import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SkillItem extends StatelessWidget {
  const SkillItem({
    super.key,
    required this.label,
    this.url,
    this.assetPath,
    this.iconData,
    this.blend = false,
  });

  /// Blend with foreground color if true.
  final bool blend;

  /// Icon of the skill.
  final IconData? iconData;

  /// Label of the skill.
  final String label;

  /// Official website.
  final String? url;

  /// Asset of image skill.
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Utils.graphic.tooltip(
      tooltipString: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        key: Key(label),
        onTap: () {
          if (url?.isEmpty ?? false) {
            return;
          }

          launchUrl(Uri.parse(url ?? ""));
        },
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                if (assetPath?.isNotEmpty ?? false)
                  Image.asset(
                    assetPath ?? "",
                    width: 16.0,
                    height: 16.0,
                    color: blend ? foregroundColor : null,
                  ),
                if (iconData != null) Icon(iconData, size: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
