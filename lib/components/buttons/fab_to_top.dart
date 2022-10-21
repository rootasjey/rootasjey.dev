import 'package:flutter/material.dart';

class FabToTop extends StatelessWidget {
  const FabToTop({
    super.key,
    required this.fabIcon,
    required this.pageScrollController,
    this.hideIfAtTop = false,
  });

  final bool hideIfAtTop;
  final Icon fabIcon;
  final ScrollController pageScrollController;

  @override
  Widget build(BuildContext context) {
    if (hideIfAtTop && pageScrollController.offset == 0.0) {
      return Container();
    }

    return FloatingActionButton(
      onPressed: () {
        final bool atTop =
            pageScrollController.hasClients && pageScrollController.offset == 0;

        if (atTop) {
          pageScrollController.animateTo(
            300.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
          );

          return;
        }

        pageScrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
        );
      },
      backgroundColor: Colors.amber,
      child: fabIcon,
    );
  }
}
