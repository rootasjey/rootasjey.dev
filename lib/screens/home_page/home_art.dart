import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/locations/art_location.dart';
import 'package:rootasjey/screens/home_page/colored_text.dart';

class HomeArt extends StatelessWidget {
  /// Home art section.
  const HomeArt({
    super.key,
    this.margin = EdgeInsets.zero,
    this.onTapTitle,
  });

  /// Space around this widget.
  final EdgeInsetsGeometry margin;

  /// Callback fired when title is tapped.
  final void Function()? onTapTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Wrap(
        spacing: 12.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          TextButton(
            onPressed: onTapTitle,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.orange.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            child: Text(
              "ART",
              style: Utils.calligraphy.body3(
                textStyle: const TextStyle(
                  fontSize: 42.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
          ColoredText(
            onTap: () => context.beamToNamed(ArtLocation.illustrationsRoute),
            textHoverColor: Constants.colors.art,
            textValue: "Illustrations •",
          ),
          ColoredText(
            onTap: () => context.beamToNamed(ArtLocation.videoMontagesRoute),
            textHoverColor: Constants.colors.videoMontage,
            textValue: "Video montages •",
          ),
          ColoredText(
            onTap: () => context.beamToNamed(ArtLocation.terrariumsRoute),
            textHoverColor: Constants.colors.terrarium,
            textValue: "Terrariums •",
          ),
        ],
      ),
    );
  }
}
