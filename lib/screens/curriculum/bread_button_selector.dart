import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/stateful_button.dart';
import 'package:rootasjey/types/enums/enum_curriculum_item.dart';

class BreadButtonSelector extends StatefulWidget {
  const BreadButtonSelector({
    super.key,
    required this.selectedItem,
    this.onSelectionChanged,
  });

  /// Called when the selection changes.
  final void Function(EnumCurriculumItem newItem)? onSelectionChanged;

  /// The selected item.
  final EnumCurriculumItem selectedItem;

  @override
  State<BreadButtonSelector> createState() => _BreadButtonSelectorState();
}

class _BreadButtonSelectorState extends State<BreadButtonSelector> {
  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: foregroundColor?.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: [
          StatefulButton(
            selected: widget.selectedItem == EnumCurriculumItem.identity,
            icondData: TablerIcons.user_square,
            tooltip: "Identity",
            onTap: () {
              widget.onSelectionChanged?.call(EnumCurriculumItem.identity);
            },
          ),
          StatefulButton(
            selected: widget.selectedItem == EnumCurriculumItem.experiences,
            icondData: TablerIcons.briefcase,
            tooltip: "Professional experiences",
            onTap: () {
              widget.onSelectionChanged?.call(EnumCurriculumItem.experiences);
            },
          ),
          StatefulButton(
            selected: widget.selectedItem == EnumCurriculumItem.education,
            icondData: TablerIcons.school,
            tooltip: "Education",
            onTap: () {
              widget.onSelectionChanged?.call(EnumCurriculumItem.education);
            },
          ),
        ],
      ),
    );
  }
}
