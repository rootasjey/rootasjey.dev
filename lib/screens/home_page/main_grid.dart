import 'dart:async';
import 'dart:math';

import 'package:beamer/beamer.dart';
import 'package:change_case/change_case.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/components/snap_bounce_scroll_physics.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/router/navigation_state_helper.dart';
import 'package:rootasjey/screens/curriculum/curriculum_page.dart';
import 'package:rootasjey/screens/home_page/quote_page.dart';
import 'package:rootasjey/screens/home_page/home_page.dart';
import 'package:rootasjey/screens/home_page/menu_categories_page.dart';
import 'package:rootasjey/screens/illustrations_page/illustrations_page.dart';
import 'package:rootasjey/screens/music/music_page.dart';
import 'package:rootasjey/screens/projects_page/projects_page.dart';
import 'package:rootasjey/screens/undefined_page.dart';
import 'package:rootasjey/screens/video_montage/video_montages_page.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class MainGrid extends StatefulWidget {
  const MainGrid({super.key});

  @override
  State<MainGrid> createState() => _MainGridState();
}

class _MainGridState extends State<MainGrid> with UiLoggy {
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

  /// Offset history.
  /// Used to go back to the previous page.
  static final List<Offset> _offsetHistory = [];

  /// Grid of widgets to display.
  final List<List<Widget?>> _grid = [
    [
      const CurriculumPage(
        onGoHome: onGoToHomePage,
        onGoBack: onGoToPreviousPage,
      ),
      const IllustrationsPage(
        onGoHome: onGoToHomePage,
        onGoBack: onGoToPreviousPage,
      ),
      const QuotePage(
        quoteName: "Le bonheur ne reside pas au kilomètre final "
            "qui n'existera jamais, mais au kilomètre zéro, "
            "qui commence a chaque instant.",
        quoteAuthor: "Shanti",
        quoteReference: "Kilomètre zero",
      ),
      const UndefinedPage(),
    ],
    [
      const MenuCategoriesPage(
        onTapCategory: onGoToPage,
        onGoHome: onGoToHomePage,
        onGoBack: onGoToPreviousPage,
      ),
      const HomePage(
        onGoToPage: onGoToPage,
        onGoBack: onGoToPreviousPage,
      ),
      const VideoMontagesPage(
        onGoHome: onGoToHomePage,
        onGoBack: onGoToPreviousPage,
      ),
      const UndefinedPage(),
    ],
    [
      const MusicPage(
        onGoHome: onGoToHomePage,
        onGoBack: onGoToPreviousPage,
      ),
      const ProjectsPage(
        onGoHome: onGoToHomePage,
        onGoBack: onGoToPreviousPage,
      ),
      const UndefinedPage(),
      const UndefinedPage(),
    ],
  ];

  /// Horizontal axis scroll controller.
  static ScrollController _hScrollController = ScrollController();

  /// Vertical axis scroll controller.
  static ScrollController _vScrollController = ScrollController();

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

  /// Used to rebuild part of the UI if we had an exception
  /// (usually from two dimension scrollables).
  bool _recoverUiFromCrash = false;

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

      if (!kIsWeb) return;
      Future.delayed(const Duration(milliseconds: 500), () {
        initGridPositionFromUrl();
      });
    });

    FlutterError.onError = (FlutterErrorDetails details) {
      loggy.error(details.exception, details.stack);
      if (details.exception is! AssertionError) {
        return;
      }

      final AssertionError assertionError = details.exception as AssertionError;

      final String stackTrace = assertionError.stackTrace?.toString() ?? "";
      final bool isDimensionalViewport = stackTrace.contains(
          "package:flutter/src/widgets/two_dimensional_viewport.dart");

      final bool containChildError = details.exception
          .toString()
          .contains("_children.containsValue(child)': is not true.");

      final bool isTwoDimensionalGridError =
          details.library == "rendering library" &&
              isDimensionalViewport &&
              containChildError;

      // loggy.info(stackTrace);
      if (isTwoDimensionalGridError) {
        _vScrollController = ScrollController();
        _hScrollController = ScrollController();
        if (_recoverUiFromCrash) {
          return;
        }

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            _recoverUiFromCrash = true;
          });
        });
      }
    };
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
    } else if (_windowSize != _previousSize || _recoverUiFromCrash) {
      _previousSize = _windowSize;
      _recoverUiFromCrash = false;

      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_vScrollController.hasClients) {
            _vScrollController.jumpTo(_currentRow * _windowSize.height);
          }

          if (_hScrollController.hasClients) {
            _hScrollController.jumpTo(_currentColumn * _windowSize.width);
          }
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
    moveGridTo(_vStartPage, _hStartPage);
  }

  /// Callback to go to a specific page.
  static void onGoToPage(String pageName) {
    switch (pageName) {
      case "illustrations-page":
        moveGridTo(0, 1);
        break;
      case "home-page":
        moveGridTo(_vStartPage, _hStartPage);
        break;
      case "projects-page":
        moveGridTo(2, 1);
        break;
      case "video-montages-page":
        moveGridTo(1, 2);
        break;
    }
  }

  static Future<void> moveGridTo(int line, int column) {
    return Future.wait([
      _vScrollController.animateTo(
        line * _windowSize.height,
        // duration must be > 0
        duration: Duration(milliseconds: 800 * max(1, line)),
        curve: Curves.decelerate,
      ),
      _hScrollController.animateTo(
        column * _windowSize.width,
        // duration must be > 0
        duration: Duration(milliseconds: 800 * max(1, column)),
        curve: Curves.decelerate,
      ),
    ]);
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
      duration: const Duration(milliseconds: 1000),
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
      duration: const Duration(milliseconds: 1000),
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
      duration: const Duration(milliseconds: 1000),
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
      duration: const Duration(milliseconds: 1000),
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

      updateBrowserUrl();
    });
  }

  /// Save the current row index in the grid.
  void setDelayedRow(int newRowIndex) {
    _setRowTimer?.cancel();
    _setRowTimer = Timer(const Duration(milliseconds: 250), () {
      _currentRow = newRowIndex;
      updateBrowserUrl();
    });
  }

  void updateBrowserUrl() {
    final String segment = _grid[_currentRow][_currentColumn]
        .toString()
        .replaceFirst("Page", "")
        .toKebabCase();

    final BeamerDelegate beamer = Beamer.of(context);
    const String origin = "/";

    beamer.updateRouteInformation(RouteInformation(
      uri: Uri.parse("$origin$segment"),
    ));

    pushOffset(_currentRow, _currentColumn);
  }

  static void onGoToPreviousPage() {
    if (_offsetHistory.isEmpty) {
      return;
    }

    _offsetHistory.removeLast(); // First remove current offset.
    final Offset offset = _offsetHistory.removeLast(); // Use N-2 offset value
    moveGridTo(offset.dx.toInt(), offset.dy.toInt());
  }

  void pushOffset(int currentRow, int currentColumn) {
    if (_offsetHistory.isEmpty) {
      _offsetHistory.add(
        Offset(currentRow.toDouble(), currentColumn.toDouble()),
      );
      return;
    }

    final Offset currentOffset = _offsetHistory.last;
    if (currentOffset.dx.toInt() == currentRow &&
        currentOffset.dy.toInt() == currentColumn) {
      return;
    }

    _offsetHistory.add(Offset(currentRow.toDouble(), currentColumn.toDouble()));
  }

  void initGridPositionFromUrl() {
    final String url = NavigationStateHelper.initialBrowserUrl;
    if (url.isEmpty || url == "/") {
      return;
    }

    final List<String> segments = url.split("/");
    if (segments.length < 2) {
      return;
    }

    final String targetSegment = segments.elementAt(1);
    switch (targetSegment) {
      case "curriculum":
        moveGridTo(0, 0);
        break;
      case "illustrations":
        moveGridTo(0, 1);
        break;
      case "quote":
        moveGridTo(0, 2);
        break;
      case "creative":
        moveGridTo(1, 0);
        break;
      case "home":
        moveGridTo(1, 1);
        break;
      case "video-montages":
        moveGridTo(1, 2);
        break;
      case "music":
        moveGridTo(2, 0);
        break;
      case "projects":
        moveGridTo(2, 1);
        break;
      default:
    }
  }
}
