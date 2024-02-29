import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/home_page/colored_text.dart';
import 'package:rootasjey/screens/home_page/dot_separator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave_shape_package/wave_shape_package.dart';

class HomeSocialLinks extends StatelessWidget {
  const HomeSocialLinks({
    super.key,
    this.margin = EdgeInsets.zero,
    this.isDark = false,
  });

  /// True if the app is in dark mode.
  final bool isDark;

  /// Space around this widget.
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    final TextStyle linkStyle = Utils.calligraphy.body4(
      textStyle: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
      ),
    );

    return SliverToBoxAdapter(
      child: CustomPaint(
        painter: CosWaveTopSide3(
          waveColor3: isDark
              ? Constants.colors.darkBackground
              : Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        child: Padding(
          padding: margin,
          child: Column(
            children: [
              const Text(
                "My social presence",
                style: TextStyle(),
              ),
              const DotSeparator(
                margin: EdgeInsets.symmetric(vertical: 12.0),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ColoredText(
                    onTap: () {
                      launchUrl(Uri.parse("https://github.com/rootasjey"));
                    },
                    tiny: true,
                    textValue: "GitHub",
                    textHoverColor: Colors.grey.shade700,
                    textStyle: linkStyle,
                  ),
                  Icon(
                    TablerIcons.point,
                    color: foregroundColor?.withOpacity(0.6),
                  ),
                  ColoredText(
                    onTap: () {
                      launchUrl(
                        Uri.parse("https://www.instagram.com/rootasjey/"),
                      );
                    },
                    tiny: true,
                    textValue: "Instagram",
                    textHoverColor: Colors.pink,
                    textStyle: linkStyle,
                  ),
                  Icon(
                    TablerIcons.point,
                    color: foregroundColor?.withOpacity(0.6),
                  ),
                  ColoredText(
                    onTap: () {
                      launchUrl(
                        Uri.parse("https://www.threads.net/@rootasjey"),
                      );
                    },
                    tiny: true,
                    textValue: "threads",
                    textHoverColor: Colors.grey.shade200,
                    textStyle: linkStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
