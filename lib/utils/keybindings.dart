import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supercharged/supercharged.dart';

/// Utility for keyboard events.
class KeyBindings {
  /// Total page's height to limit max scroll down.
  double? _pageHeight;

  /// Value to scroll on move up or down.
  final _incrOffset = 80.0;

  /// Page scroll controller to move up or down inside the widget.
  ScrollController? _scrollController;

  /// Initialize fields with non-null values.
  /// Can be called in WidgetsBinding.instance.addPostFrameCallback(...)
  /// inside a widget initState(...).
  void init({
    required ScrollController scrollController,
    required double pageHeight,
  }) {
    _scrollController = scrollController;
    _pageHeight = pageHeight;
  }

  /// Return next down offset to scroll.
  double? _getOffsetDown({bool altPressed = false}) {
    double factor = altPressed ? 3 : 1;

    final offset = _scrollController!.offset + _incrOffset < _pageHeight!
        ? _scrollController!.offset + (_incrOffset * factor)
        : _pageHeight;

    return offset;
  }

  /// Return next up offset to scroll.
  double _getOffsetUp({bool altPressed = false}) {
    double factor = altPressed ? 3 : 1;

    final offset = _scrollController!.offset - _incrOffset > 90.0
        ? _scrollController!.offset - (_incrOffset * factor)
        : 0.0;

    return offset;
  }

  /// Watch keys events & react to them with scroll movement or page navigations.
  void onKey(RawKeyEvent keyEvent, BuildContext context) {
    final String errorMessage = "Have you called the init() method beforehand?";

    assert(_scrollController != null, errorMessage);
    assert(_pageHeight != null, errorMessage);

    // ?NOTE: Keys combinations must stay on top
    // or other matching key events will override it.

    // home
    if (keyEvent.isMetaPressed &&
        keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      _scrollController!.animateTo(
        0,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // end
    if (keyEvent.isMetaPressed &&
        keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      _scrollController!.animateTo(
        _pageHeight!,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // up + alt
    if (keyEvent.isAltPressed &&
        keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      _scrollController!.animateTo(
        _getOffsetUp(altPressed: true),
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // down + alt
    if (keyEvent.isAltPressed &&
        keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      _scrollController!.animateTo(
        _getOffsetDown(altPressed: true)!,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // up
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      _scrollController!.animateTo(
        _getOffsetUp(),
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // down
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      _scrollController!.animateTo(
        _getOffsetDown()!,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // space
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.space)) {
      _scrollController!.animateTo(
        _getOffsetDown(altPressed: true)!,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // backspace
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.backspace)) {
      if (Beamer.of(context).beamingHistory.isEmpty) {
        return;
      }

      Beamer.of(context).beamBack();
      return;
    }

    // home
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.home)) {
      _scrollController!.animateTo(
        0,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }

    // end
    if (keyEvent.isKeyPressed(LogicalKeyboardKey.end)) {
      _scrollController!.animateTo(
        _pageHeight!,
        duration: 100.milliseconds,
        curve: Curves.ease,
      );

      return;
    }
  }

  void updatePageHeight(double pageHeight) {
    _pageHeight = pageHeight;
  }
}
