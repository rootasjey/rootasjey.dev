import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fonts utilities.
/// Make it easier to work with online Google fonts.
///
/// See https://github.com/material-foundation/google-fonts-flutter/issues/35
class FontsUtils {
  const FontsUtils();

  static String? fontFamily = GoogleFonts.poppins().fontFamily;

  TextStyle body({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    double? height,
    Color? color,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.montserrat(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  TextStyle body1({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    double? height,
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.montserrat(
      backgroundColor: backgroundColor,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  /// Return main text style for this app.
  TextStyle body2({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    double? height,
    Color? color,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.josefinSans(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }

  TextStyle body3({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    double? height,
    Color? backgroundColor,
    Color? color,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.lobster(
      backgroundColor: backgroundColor,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
    );
  }

  TextStyle body4({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    double? height,
    Color? backgroundColor,
    Color? color,
    TextDecoration? decoration,
    double? decorationThickness,
    TextDecorationStyle? decorationStyle,
    Color? decorationColor,
  }) {
    return GoogleFonts.firaCode(
      backgroundColor: backgroundColor,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
      decorationThickness: decorationThickness,
      decorationStyle: decorationStyle,
      decorationColor: decorationColor,
    );
  }

  /// Can be used for blog post body.
  TextStyle title3({
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16.0,
    double? height,
    Color? color,
    Color? backgroundColor,
    TextDecoration? decoration,
    TextDecorationStyle? decorationStyle,
    Color? decorationColor,
    double? decorationThickness,
  }) {
    return GoogleFonts.playfairDisplay(
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      decoration: decoration,
      decorationStyle: decorationStyle,
      decorationColor: decorationColor,
      decorationThickness: decorationThickness,
    );
  }
}
