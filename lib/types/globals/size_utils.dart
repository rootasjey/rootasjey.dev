import 'package:flutter/widgets.dart';
import 'package:rootasjey/utils/constants.dart';

class SizeUtils {
  /// Return true if the app's window is equal or less than the maximum
  /// mobile width.
  bool isMobileSize(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    return pageWidth <= Constants.maxMobileWidth;
  }
}
