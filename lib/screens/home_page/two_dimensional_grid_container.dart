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
  /// Accent color.
  // Color _accentColor = Colors.amber.shade100;

  // bool _shouldRepaintUi = false;

  Size _previousSize = Size.zero;

  /// Background color.
  Color _backgroundColor = Colors.blue.shade50;

  /// Horizontal scroll controller.
  static final ScrollController _hScrollController = ScrollController();

  /// Vertical scroll controller.
  static final ScrollController _vScrollController = ScrollController();

  /// Window's size.
  static Size _windowSize = Size.zero;

  /// Grid of widgets to display.
  final List<List<Widget?>> _grid = [
    [
      const QuotePage(key: ValueKey("about-me")),
      const IllustrationsPage(
        key: ValueKey("illustrations-page"),
        onGoToHomePage: onGoToHomePage,
      ),
      const UndefinedPage(),
    ],
    [
      const MenuCategoriesPage(),
      const HomePage(
        key: ValueKey("home-page"),
        onGoToPage: onGoToPage,
      ),
      const VideoMontagesPage(key: ValueKey("video-montages-page")),
    ],
    [
      const UndefinedPage(),
      const ProjectsPage(key: ValueKey("projects-page")),
      const UndefinedPage(),
    ],
  ];

  /// Initial horizontal page index in the [_grid] to display.
  static const int _hStartPage = 1;

  /// Initial vertical page index in the [_grid] to display.
  static const int _vStartPage = 1;

  /// Current horizontal & vertical page index in the [_grid] visible.
  /// Useful for navigating with the arrow buttons.
  TableVicinity _vicinity = const TableVicinity(row: 1, column: 1);

  @override
  void initState() {
    super.initState();
    _backgroundColor = Constants.colors.getRandomLight();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _hScrollController.jumpTo(
        _hStartPage * _windowSize.width,
      );

      _vScrollController.jumpTo(_vStartPage * _windowSize.height);
      _vicinity = const TableVicinity(row: _vStartPage, column: _hStartPage);
    });
  }

  @override
  void dispose() {
    _hScrollController.dispose();
    _vScrollController.dispose();
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
      });
      return LoadingView.scaffold(
        message: "Rebuilding complex UI...",
      );
    }

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
            bottom: 36.0,
            right: 8.0,
            child: Utils.graphic.tooltip(
              tooltipString: "go down",
              child: IconButton(
                onPressed: () {
                  _vScrollController.animateTo(
                    (_vicinity.row + 1) * _windowSize.width,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.decelerate,
                  );
                },
                color: foregroundColor?.withOpacity(0.6),
                icon: const Icon(TablerIcons.arrow_down),
              ),
            ),
          ),
          Positioned(
            bottom: 8.0,
            right: 36.0,
            child: Utils.graphic.tooltip(
              tooltipString: "go right",
              child: IconButton(
                onPressed: () {},
                color: foregroundColor?.withOpacity(0.6),
                icon: const Icon(TablerIcons.arrow_right),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}
