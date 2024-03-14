import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/snap_bounce_scroll_physics.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/home_page/quote_page.dart';
import 'package:rootasjey/screens/home_page/home_page.dart';
import 'package:rootasjey/screens/home_page/menu_categories_page.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page.dart';
import 'package:rootasjey/screens/projects_page/projects_page.dart';
import 'package:rootasjey/screens/undefined_page.dart';
import 'package:rootasjey/screens/video_montage/video_montages_page.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class TwoDimensionalGridContainer extends StatefulWidget {
  const TwoDimensionalGridContainer({super.key});

  @override
  State<TwoDimensionalGridContainer> createState() =>
      _TwoDimensionalGridContainerState();
}

class _TwoDimensionalGridContainerState
    extends State<TwoDimensionalGridContainer> with UiLoggy {
  bool _reverseArrowDown = false;
  bool _reverseArrowRight = false;

  /// Background color.
  Color _backgroundColor = Colors.blue.shade50;

  /// Current column index in the grid (according to the scroll controllers x•y).
  int _currentColumn = 0;

  /// Current row index in the grid (according to the scroll controllers x•y).
  int _currentRow = 0;

  /// Initial horizontal page index in the [_grid] to display.
  static const int _hStartPage = 1;

  /// Initial vertical page index in the [_grid] to display.
  static const int _vStartPage = 1;

  /// Grid of widgets to display.
  final List<List<Widget?>> _grid = [
    [
      const QuotePage(
        quoteName: "Le bonheur ne reside pas au kilomètre final "
            "qui n'existera jamais, mais au kilomètre zéro, "
            "qui commence a chaque instant.",
        quoteAuthor: "Shanti",
        quoteReference: "Kilomètre zero",
      ),
      const IllustrationsPage(
        onGoToHomePage: onGoToHomePage,
      ),
      const UndefinedPage(),
      const UndefinedPage(),
    ],
    [
      const MenuCategoriesPage(),
      const HomePage(
        onGoToPage: onGoToPage,
      ),
      const VideoMontagesPage(),
      const UndefinedPage(),
    ],
    [
      const UndefinedPage(),
      const ProjectsPage(),
      const UndefinedPage(),
      const UndefinedPage(),
    ],
  ];

  /// Horizontal scroll controller.
  static final ScrollController _hScrollController = ScrollController();

  /// Vertical scroll controller.
  static final ScrollController _vScrollController = ScrollController();

  /// Previous window's size (used to compare to the current window's size).
  /// Used to rebuild the UI when the window's size changes.
  Size _previousSize = Size.zero;

  /// Window's size.
  static Size _windowSize = Size.zero;

  /// Timer used to delay new column affectation.
  /// (New column index is calculated on every scroll position,
  /// so the affection would trigger ~60 fram per second).
  Timer? _setColTimer;

  /// Timer used to delay new row affectation.
  /// (New row index is calculated on every scroll position,
  /// so the affection would trigger ~60 fram per second).
  Timer? _setRowTimer;

  @override
  void initState() {
    super.initState();
    _backgroundColor = Constants.colors.getRandomLight();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _hScrollController.jumpTo(
        _hStartPage * _windowSize.width,
      );

      _currentColumn = _hStartPage;
      _currentRow = _vStartPage;
      _vScrollController.jumpTo(_vStartPage * _windowSize.height);
      _hScrollController.addListener(onHorizontalScroll);
      _vScrollController.addListener(onVerticalScroll);
    });
  }

  @override
  void dispose() {
    _hScrollController.dispose();
    _vScrollController.dispose();
    _setColTimer?.cancel();
    _setRowTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _windowSize = MediaQuery.of(context).size;
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    if (_previousSize == Size.zero) {
      _previousSize = _windowSize;
    } else if (_windowSize != _previousSize) {
      _previousSize = _windowSize;
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _vScrollController.jumpTo(_currentRow * _windowSize.height);
          _hScrollController.jumpTo(_currentColumn * _windowSize.width);
        });
      });
      return LoadingView.scaffold(
        message: "Rebuilding complex UI...",
      );
    }

    _reverseArrowDown = _currentRow >= _grid.length - 1;
    _reverseArrowRight = _currentColumn >= _grid[_currentRow].length - 1;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          TableView.builder(
            columnCount: _grid.elementAt(0).length,
            rowCount: _grid.length,
            horizontalDetails: ScrollableDetails.horizontal(
              controller: _hScrollController,
              physics: SnapBounceScrollPhysics(
                itemWidth: _windowSize.width,
                parent: const BouncingScrollPhysics(),
              ),
            ),
            verticalDetails: ScrollableDetails.vertical(
              controller: _vScrollController,
              physics: SnapBounceScrollPhysics(
                itemWidth: _windowSize.height,
                parent: const BouncingScrollPhysics(),
              ),
            ),
            columnBuilder: (int column) {
              return const TableSpan(
                extent: FractionalTableSpanExtent(1.0),
              );
            },
            rowBuilder: (int row) {
              return const TableSpan(
                extent: FractionalTableSpanExtent(1.0),
              );
            },
            cellBuilder: (BuildContext context, TableVicinity vicinity) {
              final Widget? page = _grid[vicinity.row][vicinity.column];

              if (page == null) {
                return const TableViewCell(
                  child: UndefinedPage(),
                );
              }

              return TableViewCell(
                child: page,
              );
            },
          ),
          Positioned(
            bottom: 24.0,
            right: 8.0,
            child: Utils.graphic.tooltip(
              tooltipString: _reverseArrowDown ? "go.up".tr() : "go.down".tr(),
              child: IconButton(
                onPressed: _reverseArrowDown ? onTapArrowUp : onTapArrowDown,
                color: foregroundColor?.withOpacity(0.6),
                icon: _reverseArrowDown
                    ? const Icon(TablerIcons.arrow_up)
                    : const Icon(TablerIcons.arrow_down),
              ),
            ),
          ),
          Positioned(
            bottom: 8.0,
            right: 24.0,
            child: Utils.graphic.tooltip(
              tooltipString:
                  _reverseArrowRight ? "go.left".tr() : "go.right".tr(),
              child: IconButton(
                onPressed:
                    _reverseArrowRight ? onTapArrowLeft : onTapArrowRight,
                color: foregroundColor?.withOpacity(0.6),
                icon: _reverseArrowRight
                    ? const Icon(TablerIcons.arrow_left)
                    : const Icon(TablerIcons.arrow_right),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Callback to go to home page.
  static void onGoToHomePage() {
    _hScrollController.animateTo(
      _hStartPage * _windowSize.width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
    _vScrollController.animateTo(
      _vStartPage * _windowSize.height,
      duration: const Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
  }

  /// Callback to go to a specific page.
  static void onGoToPage(String pageName) {
    switch (pageName) {
      case "illustrations-page":
        _vScrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate,
        );
        break;
      case "home-page":
        break;
      case "projects-page":
        break;
      case "video-montages-page":
        _hScrollController.animateTo(
          2 * _windowSize.width,
          duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate,
        );
        break;
    }
  }

  /// Callback called when the user scrolls horizontally.
  void onHorizontalScroll() {
    final int newColIndex = (_hScrollController.offset / _windowSize.width)
        .round()
        .clamp(0, _grid[0].length - 1);
    setDelayedColumn(newColIndex);
  }

  /// Callback called when the user taps on the arrow down.
  void onTapArrowDown() async {
    final int newRowIndex = _currentRow + 1;
    if (newRowIndex >= _grid.length) {
      return;
    }

    await _vScrollController.animateTo(
      newRowIndex * _windowSize.width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
  }

  /// Callback called when the user taps on the arrow up.
  void onTapArrowUp() {
    final int newRowIndex = _currentRow - 1;
    if (newRowIndex < 0) {
      return;
    }

    _vScrollController.animateTo(
      newRowIndex * _windowSize.width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
  }

  /// Callback called when the user taps on the arrow left.
  void onTapArrowLeft() {
    final int newColIndex = _currentColumn - 1;
    if (newColIndex < 0) {
      return;
    }

    _hScrollController.animateTo(
      newColIndex * _windowSize.width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
  }

  /// Callback called when the user taps on the arrow right.
  void onTapArrowRight() {
    final int newColIndex = _currentColumn + 1;
    if (newColIndex >= _grid[_currentRow].length) {
      return;
    }

    _hScrollController.animateTo(
      newColIndex * _windowSize.width,
      duration: const Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
  }

  /// Callback called when the user scrolls vertically.
  void onVerticalScroll() {
    final int newRowIndex = (_vScrollController.offset / _windowSize.height)
        .round()
        .clamp(0, _grid.length - 1);
    setDelayedRow(newRowIndex);
  }

  /// Save the current column index in the grid.
  void setDelayedColumn(int newColumnIndex) {
    _setColTimer?.cancel();
    _setColTimer = Timer(const Duration(milliseconds: 250), () {
      _currentColumn = newColumnIndex;

      // Update arrow direction if we can't go down anymore.
      if (newColumnIndex >= _grid[_currentRow].length - 1 &&
          !_reverseArrowRight) {
        setState(() {
          _reverseArrowRight = true;
        });
      } else if (newColumnIndex <= 0 && _reverseArrowRight) {
        setState(() {
          _reverseArrowRight = false;
        });
      }
    });
  }

  /// Save the current row index in the grid.
  void setDelayedRow(int newRowIndex) {
    _setRowTimer?.cancel();
    _setRowTimer = Timer(const Duration(milliseconds: 250), () {
      _currentRow = newRowIndex;
    });
  }
}
