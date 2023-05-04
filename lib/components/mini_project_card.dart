import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_project_item_action.dart';
import 'package:rootasjey/types/project/popup_entry_project.dart';
import 'package:rootasjey/types/project/project.dart';
import 'package:unicons/unicons.dart';

class MiniProjectCard extends StatefulWidget {
  const MiniProjectCard({
    super.key,
    required this.project,
    required this.label,
    this.selected = false,
    this.showLabel = false,
    this.color = Colors.amber,
    this.onHover,
    this.onTap,
    this.iconData,
    this.thumbnailUrl = "",
    this.onPopupMenuItemSelected,
    this.popupMenuEntries = const [],
    this.useBottomSheet = false,
    this.index = -1,
    this.onLongPress,
    this.canDrag = false,
    this.onRemove,
    this.showEditMode = false,
  });

  /// If true, the card can be dragged. Usually used to re-order items.
  final bool canDrag;

  /// A visual indicator is built around this card, if true.
  final bool selected;

  /// Display card's name.
  final bool showLabel;

  final bool showEditMode;

  /// If true, a bottom sheet will be displayed on long press event.
  /// Setting this property to true will deactivate popup menu and
  /// hide like button.
  final bool useBottomSheet;

  /// This card's data.
  final Project project;

  /// List position if any.
  final int index;

  /// Card's background color on hover.
  final Color color;

  /// Callback fired when this card is hovered.
  final void Function(String label, Color color, bool isHover)? onHover;

  /// Callback fired when this card is tapped.
  final void Function()? onTap;

  /// Callback fired when this card should be removed.
  final void Function(Project project)? onRemove;

  /// Icon data. Used if `thumbnailUrl` is null.
  final IconData? iconData;

  /// Card's label. Displayed beneath the card.
  final String label;

  /// HTTP URL of this card's thumbnail.
  final String thumbnailUrl;

  /// Callback fired when one of the popup menu item entries is selected.
  final void Function(
    EnumProjectItemAction action,
    int index,
    Project project,
  )? onPopupMenuItemSelected;

  /// Menu item list displayed after tapping on the corresponding popup button.
  final List<PopupEntryProject> popupMenuEntries;

  /// Callback fired on long press.
  final void Function(Project project, bool selected)? onLongPress;

  @override
  State<MiniProjectCard> createState() => _MiniProjectCardState();
}

class _MiniProjectCardState extends State<MiniProjectCard> {
  final double _startElevation = 4.0;
  final double _endElevation = 12.0;
  double _elevation = 4.0;
  Color _cardColor = Colors.grey.shade800;

  /// Display popup menu if true.
  /// Because we only show popup menu on hover.
  // bool _showPopupMenu = false;

  @override
  initState() {
    super.initState();
    _elevation = _startElevation;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.thumbnailUrl.isNotEmpty) {
      return imageCard();
    }

    return iconCard();
  }

  Widget iconCard() {
    return Stack(
      children: [
        Card(
          elevation: _elevation,
          color: _cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onHover: (bool isHover) {
              setState(() {
                _elevation = isHover ? _endElevation : _startElevation;
                _cardColor = isHover ? widget.color : Colors.grey.shade800;
                // _showPopupMenu = isHover;
              });

              widget.onHover?.call(widget.label, widget.color, isHover);
            },
            onTap: widget.onTap,
            onLongPress:
                widget.useBottomSheet && !widget.canDrag ? onLongPress : null,
            child: Container(
                width: 100.0,
                height: 100.0,
                padding: const EdgeInsets.all(12.0),
                child: Icon(widget.iconData)),
          ),
        ),
        removeButton(),
      ],
    );
  }

  Widget imageCard() {
    return Column(
      children: [
        Stack(
          children: [
            Card(
              elevation: _elevation,
              color: _cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: widget.selected
                    ? BorderSide(color: widget.color, width: 4.0)
                    : BorderSide.none,
              ),
              clipBehavior: Clip.hardEdge,
              child: Ink.image(
                  image: NetworkImage(widget.thumbnailUrl),
                  fit: BoxFit.cover,
                  width: 100.0,
                  height: 100.0,
                  child: InkWell(
                    onHover: (bool isHover) {
                      setState(() {
                        _elevation = isHover ? _endElevation : _startElevation;
                        _cardColor =
                            isHover ? widget.color : Colors.grey.shade800;
                        // _showPopupMenu = isHover;
                      });

                      widget.onHover?.call(widget.label, widget.color, isHover);
                    },
                    onTap: widget.onTap,
                    onLongPress: widget.useBottomSheet && !widget.canDrag
                        ? onLongPress
                        : null,
                  )),
            ),
            removeButton(),
          ],
        ),
        if (widget.showLabel) Text(widget.label)
      ],
    );
  }

  Widget removeButton() {
    if (widget.popupMenuEntries.isEmpty ||
        widget.useBottomSheet ||
        !widget.showEditMode) {
      return Positioned(top: 0, left: 0, child: Container());
    }

    return Positioned(
      top: 12.0,
      right: 12.0,
      child: CircleButton(
        radius: 8.0,
        backgroundColor: Colors.black45,
        icon: const Icon(UniconsLine.times, size: 14.0),
        onTap: () {
          widget.onRemove?.call(widget.project);
        },
      ),
    );
  }

  Widget popupMenuButton() {
    if (widget.popupMenuEntries.isEmpty || widget.useBottomSheet) {
      return Container();
    }

    return Positioned(
      top: 10.0,
      right: 10.0,
      child: Opacity(
        // opacity: _showPopupMenu ? 1.0 : 0.0,
        opacity: 1.0,
        child: PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          onSelected: (EnumProjectItemAction action) {
            widget.onPopupMenuItemSelected?.call(
              action,
              widget.index,
              widget.project,
            );
          },
          itemBuilder: (_) => widget.popupMenuEntries,
          child: const CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.black38,
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Icon(UniconsLine.ellipsis_h, size: 14),
            ),
          ),
        ),
      ),
    );
  }

  void onLongPress() {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      backgroundColor: Colors.white70,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(8.0),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.popupMenuEntries.map((popupMenuEntry) {
                  final popupMenuItemIcon = popupMenuEntry
                      as PopupMenuItemIcon<EnumProjectItemAction>;

                  return ListTile(
                    title: Opacity(
                      opacity: 0.8,
                      child: Text(
                        popupMenuItemIcon.textLabel,
                        style: Utilities.fonts.body(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    trailing: popupMenuItemIcon.icon,
                    onTap: () {
                      Navigator.of(context).pop();
                      final EnumProjectItemAction? action =
                          popupMenuItemIcon.value;

                      if (action == null) {
                        return;
                      }

                      widget.onPopupMenuItemSelected?.call(
                        action,
                        widget.index,
                        widget.project,
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );

    widget.onLongPress?.call(
      widget.project,
      widget.selected,
    );
  }
}
