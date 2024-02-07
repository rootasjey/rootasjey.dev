import 'package:rootasjey/globals/utils/app_state/app_state.dart';
import 'package:rootasjey/globals/utils/calligraphy.dart';
import 'package:rootasjey/globals/utils/graphic.dart';
import 'package:rootasjey/globals/utils/lambda.dart';
import 'package:rootasjey/globals/utils/linguistic.dart';
import 'package:rootasjey/globals/utils/measurements.dart';
import 'package:rootasjey/globals/utils/passage.dart';
import 'package:rootasjey/globals/utils/search.dart';
import 'package:rootasjey/globals/utils/tictac.dart';
import 'package:rootasjey/globals/utils/vault.dart';

class Utils {
  /// Date and time interface.
  static const tictac = TicTac();

  /// Typography interface.
  static const calligraphy = Calligraphy();

  /// Everything about size interface.
  static const measurements = Measurements();

  /// Navigation interface.
  static const passage = Passage();

  /// Visual interface (e.g. animation).
  static const graphic = Graphic();

  /// Language interface.
  static const linguistic = Linguistic();

  /// Cloud functions interface.
  static const lambda = Lambda();

  /// Search interface.
  static final search = SearchApi();

  /// Application state interface.
  static final state = AppState();

  /// Local storage interface.
  static final vault = Vault();

  static String getStringWithUnit(int usedBytes) {
    if (usedBytes < 1000) {
      return "$usedBytes bytes";
    }

    if (usedBytes < 1000000) {
      return "${usedBytes / 1000} KB";
    }

    if (usedBytes < 1000000000) {
      return "${usedBytes / 1000000} MB";
    }

    if (usedBytes < 1000000000000) {
      return "${usedBytes / 1000000000} GB";
    }

    if (usedBytes < 1000000000000000) {
      return "${usedBytes / 1000000000000} TB";
    }

    return "${usedBytes / 1000000000000000} PB";
  }
}
