import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/dom.dart' as dom;
import 'package:rootasjey/components/circle_button.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class CloseIntent extends Intent {
  const CloseIntent();
}

class CopyLinkIntent extends Intent {
  const CopyLinkIntent();
}

class ImageViewer extends StatefulWidget {
  final Map<String, String?> attributes;
  final dom.Element? element;

  const ImageViewer({
    Key? key,
    required this.attributes,
    required this.element,
  }) : super(key: key);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  bool _triggeredCloseAction = false;

  double? _height = 300.0;
  double? _width = 300.0;

  final Map<Type, Action<Intent>> _actions = {};

  final Map<LogicalKeySet, Intent> _shortcuts = {
    LogicalKeySet(LogicalKeyboardKey.escape): const CloseIntent(),
    LogicalKeySet(LogicalKeyboardKey.space): const CloseIntent(),
    LogicalKeySet(LogicalKeyboardKey.backspace): const CloseIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowUp): const CloseIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowDown): const CloseIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowLeft): const CloseIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowRight): const CloseIntent(),
    LogicalKeySet(LogicalKeyboardKey.keyC): const CopyLinkIntent(),
    LogicalKeySet(
      LogicalKeyboardKey.meta,
      LogicalKeyboardKey.keyC,
    ): const CopyLinkIntent(),
  };

  Function? _closeActionCopy;

  ScrollController? _scrollController;

  String _src = '';
  String _alt = '';

  @override
  initState() {
    super.initState();

    _scrollController = ScrollController(initialScrollOffset: 12.0);
    _scrollController!.addListener(scrollListener);

    setState(() {
      final attributes = widget.attributes;
      _src = attributes['src'] ?? '';
      _alt = attributes['alt'] ?? '';

      final String? attrW = attributes['width'];
      final String? attrH = attributes['height'];

      _width = attrW != null ? double.tryParse(attrW) : _width;
      _height = attrH != null ? double.tryParse(attrH) : _height;
    });

    _actions.putIfAbsent(
      CopyLinkIntent,
      () => CallbackAction<CopyLinkIntent>(
        onInvoke: (CopyLinkIntent copyLinkIntent) => copyLink(),
      ),
    );
  }

  @override
  dispose() {
    _scrollController!.removeListener(scrollListener);
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        image(),
        caption(),
      ],
    );
  }

  Widget caption() {
    if (_alt.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: TextButton(
        onPressed: () => launch(_src),
        child: Opacity(
          opacity: 0.6,
          child: Text(
            _alt,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        style: TextButton.styleFrom(
          primary: stateColors.foreground,
        ),
      ),
    );
  }

  Widget image() {
    return OpenContainer(
      closedElevation: 0.0,
      openElevation: 0.0,
      closedColor: stateColors.lightBackground,
      openColor: Colors.black,
      openBuilder: (context, closeAction) {
        _closeActionCopy = closeAction;

        _actions.removeWhere((type, action) => type is CloseIntent);

        _actions.putIfAbsent(
          CloseIntent,
          () => CallbackAction<CloseIntent>(
            onInvoke: (CloseIntent closeIntent) => _closeActionCopy?.call(),
          ),
        );

        return Shortcuts(
          shortcuts: _shortcuts,
          child: Actions(
            actions: _actions,
            child: Focus(
              autofocus: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 12.0),
                    Stack(
                      children: [
                        Ink.image(
                          image: NetworkImage(_src),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: InkWell(
                            onTap: () {
                              _triggeredCloseAction = true;
                              closeAction();
                            },
                          ),
                        ),
                        Positioned(
                          top: 20.0,
                          right: 20.0,
                          child: CircleButton(
                            tooltip: "close".tr(),
                            onTap: () {
                              _triggeredCloseAction = true;
                              closeAction();
                            },
                            icon: Icon(
                              UniconsLine.times,
                              color: stateColors.background,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(height: 12.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      closedBuilder: (context, openAction) {
        return SizedBox(
          height: _height! > 500.0 ? 500.0 : _height,
          child: Ink.image(
            image: NetworkImage(_src),
            width: _width,
            height: _height,
            fit: BoxFit.scaleDown,
            child: InkWell(onTap: () {
              _triggeredCloseAction = false;
              openAction();
            }),
          ),
        );
      },
    );
  }

  void scrollListener() {
    final position = _scrollController!.position;

    if (_triggeredCloseAction) {
      return;
    }

    if (!position.atEdge && !position.outOfRange) {
      return;
    }

    _triggeredCloseAction = true;
    _closeActionCopy?.call();
  }

  void copyLink() {
    Clipboard.setData(
      ClipboardData(text: _src),
    );

    Snack.i(
      context: context,
      message: "copy_image_link_success".tr(),
    );
  }
}
