import 'package:flutter/material.dart';
import 'package:rootasjey/utils/fonts.dart';

class HeaderSection extends StatelessWidget {
  final bool isSelected;
  final String titleValue;
  final Function(String path) onTap;
  final String path;

  const HeaderSection({
    Key? key,
    this.isSelected = false,
    required this.titleValue,
    required this.onTap,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(path);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.5,
          child: Text(
            titleValue,
            style: FontsUtils.mainStyle(
              fontSize: 40.0,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
