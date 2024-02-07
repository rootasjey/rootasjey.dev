import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/popup_menu/popup_menu_item_icon.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_content_visibility.dart';

class PubPopupMenuButton extends StatelessWidget {
  const PubPopupMenuButton({
    super.key,
    required this.visibility,
    required this.popupVisibilityItems,
    this.asIconButton = false,
    this.onVisibilityItemSelected,
  });

  /// If true, show this PopupMenuButton button as an IconButton.
  final bool asIconButton;

  /// Current content visibility.
  final EnumContentVisibility visibility;

  /// Callback fired when a visibility popup menu item is selected..
  final void Function(
    EnumContentVisibility visibility,
  )? onVisibilityItemSelected;

  /// List of popup items to manage post's visibility.
  final List<PopupMenuEntry<EnumContentVisibility>> popupVisibilityItems;

  @override
  Widget build(BuildContext context) {
    final Color baseColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;

    const Color color = Colors.black;
    Widget? child;
    Widget? icon;

    if (!asIconButton) {
      child = Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          border: Border.all(
            color: baseColor.withOpacity(0.3),
            width: 2.0,
          ),
        ),
        child: Text(
          visibility == EnumContentVisibility.public
              ? "published".tr()
              : "visibility.private".tr(),
          style: Utilities.fonts.body(
            textStyle: TextStyle(
              color: baseColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    if (asIconButton) {
      icon = visibility == EnumContentVisibility.public
          ? const Icon(TablerIcons.eye, color: color)
          : const Icon(TablerIcons.eye_cancel, color: color);
    }

    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      onSelected: onVisibilityItemSelected,
      itemBuilder: (_) => popupVisibilityItems.map(
        (final PopupMenuEntry<EnumContentVisibility> item) {
          final popupMenuItemIcon =
              item as PopupMenuItemIcon<EnumContentVisibility>;

          final bool selected = visibility == popupMenuItemIcon.value;
          final Color? selectedColor = selected ? Colors.amber : null;

          return popupMenuItemIcon.copyWith(
            selected: selected,
            selectedColor: selectedColor,
          );
        },
      ).toList(),
      icon: icon,
      child: child,
    );
  }
}
