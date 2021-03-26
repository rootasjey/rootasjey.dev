import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fonts utilities.
/// Make it easier to work with online Google fonts.
///
/// See https://github.com/material-foundation/google-fonts-flutter/issues/35
class FontsUtils {
  /// Return main text style for this app.
  static TextStyle mainStyle({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    double height,
    Color color,
  }) {
    if (color == null) {
      return GoogleFonts.raleway(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
      );
    }

    return GoogleFonts.raleway(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }

  /// Return main text style for this app.
  static TextStyle boldTitleStyle() {
    return GoogleFonts.raleway(
      fontSize: 80.0,
      fontWeight: FontWeight.w700,
    );
  }
}
