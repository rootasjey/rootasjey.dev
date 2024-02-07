import 'dart:math';

import 'package:flutter/material.dart';

class ColorsConstants {
  /// All necessary colors for the app.
  ColorsConstants();

  final List<Color> palette = [
    Colors.blue,
    Colors.green,
    Colors.amber.shade700,
    Colors.deepPurple.shade200,
    Colors.pink,
  ];

  final List<Color> backgroundPalette = [
    Colors.blue.shade50,
    const Color.fromRGBO(253, 239, 245, 1),
    Colors.amber.shade50,
    Colors.deepPurple.shade50,
    Colors.lightGreen.shade50,
    Colors.pink.shade50,
  ];

  Color getFromTag(String tag) {
    switch (tag) {
      case "storage":
        return Colors.amber;
      case "functions":
        return Colors.pink;
      case "firestore":
        return Colors.green;
      case "web":
        return Colors.blue;
      case "flutter":
        return Colors.lightBlue;
      case "files":
        return Colors.cyan;
      default:
        return Colors.white;
    }
  }

  Color getRandomFromPalette() {
    return palette.elementAt(Random().nextInt(palette.length));
  }

  /// Color for statistics.
  final Color activity = Colors.red;

  final Color clairPink = const Color(0xFFf5eaf9);

  /// Color for books.
  final Color books = Colors.blue.shade700;

  /// Color for challenges.
  final Color challenges = Colors.amber;

  /// Color for contests.
  final Color contests = Colors.indigo;

  final Color dark = const Color(0xFF303030);

  final Color drafts = Colors.amber.shade600;

  final Color delete = Colors.pink;
  final Color error = Colors.pink;

  /// Color for email.
  final Color email = Colors.blue.shade300;

  /// Color for galleries.
  final Color galleries = Colors.green;

  final Color home = Colors.blue.shade300;

  /// Color for illustrations.
  final Color illustrations = const Color(0xFF796AD2);
  final Color lightBackground = const Color.fromRGBO(253, 239, 245, 1);
  final Color likes = Colors.pink;
  final Color licenses = Colors.amber.shade800;
  final Color location = Colors.green.shade300;

  final Color password = Colors.orange.shade300;

  /// Primary application's color.
  final Color primary = const Color(0xFF796AD2);

  /// Color for profile.
  final Color profile = Colors.indigo;

  /// Color for projects.
  final Color projects = Colors.amber;

  /// 3th color.
  final Color tertiary = Colors.amber;

  /// Color for review page.
  final Color review = Colors.teal.shade700;

  /// Color for profile page sections.
  final Color sections = Colors.green.shade700;

  /// Color for settings.
  final Color settings = Colors.teal;

  final Color bio = Colors.deepPurple.shade300;

  /// Secondary application's color.
  Color secondary = Colors.pink;

  final Color validation = Colors.green;
}
