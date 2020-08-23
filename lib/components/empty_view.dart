import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String title;

  EmptyView({
    this.title = 'This section is empty',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Column(
        children: [
          Icon(
            Icons.do_not_disturb_alt,
            size: 50.0,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
