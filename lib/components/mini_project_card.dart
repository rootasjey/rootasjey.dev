import 'package:dotted_border/dotted_border.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/drag_data.dart';
import 'package:rootasjey/types/enums/enum_project_item_action.dart';
import 'package:rootasjey/types/project/popup_entry_project.dart';
import 'package:rootasjey/types/project/project.dart';
import 'package:unicons/unicons.dart';

class MiniProjectCard extends StatefulWidget {
  const MiniProjectCard({
    super.key,
    required this.project,
    this.selected = false,
    this.deactivated = false,
    this.showLabel = false,
    this.color = Colors.amber,
    this.onHover,
    this.onTap,
    this.iconData,
    this.iconColor,
    this.onPopupMenuItemSelected,
    this.popupMenuEntries = const [],
    this.useBottomSheet = false,
    this.index = -1,
    this.onLongPress,
    this.canDrag = false,
    this.onRemove,
    this.showEditMode = false,
    this.onDragCompleted,
    this.onDragEnd,
    this.onDraggableCanceled,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDrop,
    this.dragGroupName = "",
  });

  /// If true, the card can be dragged. Usually used to re-order items.
  final bool canDrag;

  /// Card is greyed out if true and interactions are deactivated.
  final bool deactivated;

  /// A visual indicator is built around this card, if true.
  final bool selected;

  /// Display card's name.
  final bool showLabel;

  /// Show a cross icon on this card if true.
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

  /// Icon's color.
  final Color? iconColor;

  /// Callback fired when this card is hovered.
  final void Function(String label, Color color, bool isHover)? onHover;

  /// Callback fired when this card is tapped.
  final void Function(Project project)? onTap;

  /// Callback fired when this card should be removed.
  final void Function(Project project)? onRemove;

  /// Icon data. Used if `thumbnailUrl` is null.
  final IconData? iconData;

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

  /// Callback fired on drag completed.
  final void Function()? onDragCompleted;

  /// Callback fired on drag end.
  final void Function(DraggableDetails details)? onDragEnd;

  /// Callback fired on drag canceled.
  final void Function(Velocity velocity, Offset offset)? onDraggableCanceled;

  /// Callback fired on drag started.
  final void Function()? onDragStarted;

  /// Callback fired on drag update.
  final void Function(DragUpdateDetails details)? onDragUpdate;

  /// Callback fired on drop.
  final void Function(int dropTargetIndex, List<int> dragIndexes)? onDrop;

  /// An arbitrary name given to this item's drag group
  ///  (e.g. "home-page"). Thus to avoid dragging items between sections.
  final String dragGroupName;

  @override
  State<MiniProjectCard> createState() => _MiniProjectCardState();
}

class _MiniProjectCardState extends State<MiniProjectCard> {
  double _startElevation = 4.0;
  final double _endElevation = 12.0;
  double _elevation = 4.0;
  Color _cardColor = Colors.grey.shade800;
  final double _cardSize = 100.0;

  @override
  initState() {
    super.initState();
    _startElevation = widget.project.id.isEmpty ? 0.0 : 4.0;
    _elevation = _startElevation;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.canDrag) {
      return dropTarget();
    }

    return visualChild();
  }

  Widget visualChild({bool usingAsDropTarget = false}) {
    if (widget.project.cover.thumbnails.s.isNotEmpty) {
      return imageCard(usingAsDropTarget: usingAsDropTarget);
    }

    return iconCard(usingAsDropTarget: usingAsDropTarget);
  }

  Widget iconCard({bool usingAsDropTarget = false}) {
    final Color borderColor = Constants.colors.palette.first;
    BorderSide borderSide = BorderSide.none;

    if (widget.selected) {
      borderSide = BorderSide(color: widget.color, width: 4.0);
    }

    if (usingAsDropTarget) {
      borderSide = BorderSide(color: borderColor, width: 4.0);
    }

    final bool isProjectEmpty = widget.project.id.isEmpty;
    final double cardSide = isProjectEmpty ? 82.0 : _cardSize;

    Widget cardChild = Card(
      elevation: isProjectEmpty ? 0.0 : _elevation,
      color: isProjectEmpty ? Colors.transparent : _cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: borderSide,
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onHover: (bool isHover) {
          setState(() {
            _elevation = isHover ? _endElevation : _startElevation;
            _cardColor = isHover ? widget.color : Colors.grey.shade800;
          });

          widget.onHover?.call(widget.project.name, widget.color, isHover);
        },
        onTap: widget.onTap == null
            ? null
            : () => widget.onTap?.call(widget.project),
        onLongPress:
            widget.useBottomSheet && !widget.canDrag ? onLongPress : null,
        child: Container(
          width: cardSide,
          height: cardSide,
          padding: const EdgeInsets.all(12.0),
          child: Icon(widget.iconData, color: widget.iconColor),
        ),
      ),
    );

    if (isProjectEmpty) {
      cardChild = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DottedBorder(
          strokeWidth: 3.0,
          borderType: BorderType.RRect,
          radius: const Radius.circular(4.0),
          color: borderColor,
          dashPattern: const [8, 4],
          child: cardChild,
        ),
      );
    }

    return Column(
      children: [
        Stack(
          children: [
            cardChild,
            removeButton(),
          ],
        ),
        if (widget.showLabel) Text(widget.project.name),
      ],
    );
  }

  Widget imageCard({bool usingAsDropTarget = false}) {
    final Color primaryColor = Theme.of(context).primaryColor;
    BorderSide borderSide = BorderSide.none;

    if (widget.selected) {
      borderSide = BorderSide(color: widget.color, width: 4.0);
    }

    if (usingAsDropTarget) {
      borderSide = BorderSide(color: primaryColor, width: 4.0);
    }

    Widget cardChild = Column(
      children: [
        Stack(
          children: [
            Card(
              elevation: _elevation,
              color: _cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: borderSide,
              ),
              clipBehavior: Clip.hardEdge,
              child: Ink.image(
                  image: NetworkImage(widget.project.cover.thumbnails.s),
                  fit: BoxFit.cover,
                  width: _cardSize,
                  height: _cardSize,
                  colorFilter:
                      widget.deactivated ? Utilities.ui.greyColorFilter : null,
                  child: InkWell(
                    onHover: (bool isHover) {
                      setState(() {
                        _elevation = isHover ? _endElevation : _startElevation;
                        _cardColor =
                            isHover ? widget.color : Colors.grey.shade800;
                      });

                      widget.onHover
                          ?.call(widget.project.name, widget.color, isHover);
                    },
                    onTap: widget.deactivated
                        ? null
                        : () => widget.onTap?.call(widget.project),
                    onLongPress: widget.useBottomSheet && !widget.canDrag
                        ? onLongPress
                        : null,
                  )),
            ),
            removeButton(),
          ],
        ),
        if (widget.showLabel) Text(widget.project.name),
      ],
    );

    if (widget.canDrag) {
      cardChild = Draggable<DragData>(
        childWhenDragging: childWhenDragging(),
        data: DragData(
          index: widget.index,
          groupName: widget.dragGroupName,
          type: MiniProjectCard,
        ),
        feedback: draggingCard(),
        onDragUpdate: widget.onDragUpdate,
        onDragCompleted: widget.onDragCompleted,
        onDragEnd: widget.onDragEnd,
        onDragStarted: widget.onDragStarted,
        onDraggableCanceled: widget.onDraggableCanceled,
        child: cardChild,
      );
    }

    return cardChild;
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
    );
  }

  Widget childWhenDragging({
    String textValue = "",
    Function()? onTapPlaceholder,
  }) {
    const double borderRadiusValue = 4.0;

    return Container(
      width: _cardSize + 8.0,
      height: _cardSize + 8.0,
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        strokeWidth: 3.0,
        borderType: BorderType.RRect,
        radius: const Radius.circular(borderRadiusValue),
        color: Theme.of(context).primaryColor.withOpacity(0.6),
        dashPattern: const [8, 4],
        child: const ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadiusValue),
          ),
        ),
      ),
    );
  }

  Widget draggingCard() {
    return Card(
      elevation: 8.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ExtendedImage.network(
        widget.project.cover.thumbnails.s,
        fit: BoxFit.cover,
        width: _cardSize,
        height: _cardSize,
        clearMemoryCacheWhenDispose: true,
      ),
    );
  }

  Widget dropTarget() {
    return DragTarget<DragData>(
      builder: (BuildContext context, candidateItems, rejectedItems) {
        return visualChild(
          usingAsDropTarget: candidateItems.isNotEmpty,
        );
      },
      onAccept: (DragData dragData) {
        widget.onDrop?.call(widget.index, [dragData.index]);
      },
      onWillAccept: (DragData? dragData) {
        if (dragData == null) {
          return false;
        }

        if (dragData.type != MiniProjectCard) {
          return false;
        }

        if (dragData.groupName != widget.dragGroupName) {
          return false;
        }

        return true;
      },
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
