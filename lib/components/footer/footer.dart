import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rootasjey/components/footer/sections/about_us_section.dart';
import 'package:rootasjey/components/footer/sections/editorial_section.dart';
import 'package:rootasjey/components/footer/sections/legal_section.dart';
import 'package:rootasjey/components/footer/sections/user_section.dart';

class Footer extends ConsumerWidget {
  final ScrollController? pageScrollController;
  final bool closeModalOnNav;
  final bool autoNavToHome;

  Footer({
    this.autoNavToHome = true,
    this.pageScrollController,
    this.closeModalOnNav = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    final WrapAlignment alignment =
        width < 700.0 ? WrapAlignment.spaceBetween : WrapAlignment.spaceAround;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 60.0,
        vertical: 90.0,
      ),
      child: Wrap(
        runSpacing: 80.0,
        alignment: alignment,
        children: <Widget>[
          Divider(
            height: 20.0,
            thickness: 1.0,
            color: Colors.black38,
          ),
          LegalSection(),
          EditorialSection(),
          UserSection(),
          AboutUsSection(),
        ],
      ),
    );
  }
}
