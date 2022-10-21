import 'package:flutter/material.dart';

class MiniProjectCard extends StatefulWidget {
  const MiniProjectCard({
    super.key,
    required this.iconData,
    required this.label,
    this.onHover,
    this.color = Colors.amber,
  });

  final Color color;
  final IconData iconData;
  final String label;
  final void Function(String label, Color color, bool isHover)? onHover;

  @override
  State<MiniProjectCard> createState() => _MiniProjectCardState();
}

class _MiniProjectCardState extends State<MiniProjectCard> {
  double _elevation = 2.0;
  Color _cardColor = Colors.grey.shade800;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: _elevation,
      color: _cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onHover: (bool isHover) {
          setState(() {
            _elevation = isHover ? 8.0 : 2.0;
            _cardColor = isHover ? widget.color : Colors.grey.shade800;
          });

          widget.onHover?.call(widget.label, widget.color, isHover);
        },
        onTap: () {},
        child: Container(
          width: 100.0,
          height: 100.0,
          // color: Colors.red,
          padding: const EdgeInsets.all(12.0),
          child: Icon(widget.iconData),
        ),
      ),
    );
  }
}
