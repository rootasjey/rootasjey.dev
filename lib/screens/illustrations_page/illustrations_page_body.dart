import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/illustration_card.dart';
import 'package:rootasjey/components/upload_panel/upload_panel.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_illustration_item_action.dart';
import 'package:rootasjey/types/illustration/illustration.dart';

class IllustrationsPageBody extends StatelessWidget {
  const IllustrationsPageBody({
    super.key,
    required this.illustrations,
    this.onSelectFiles,
    this.fab,
    this.popupMenuItems = const [],
    this.onPopupMenuItemSelected,
    this.onTapIllustration,
    this.windowSize = Size.zero,
  });

  /// Callback fired when an item is selected in illustration popup menu.
  final void Function(
    EnumIllustrationItemAction action,
    int index,
    Illustration illustration,
    String stringKey,
  )? onPopupMenuItemSelected;

  /// Callback fired to upload new illustrations.
  final void Function()? onSelectFiles;

  /// Callback fired when an illustration card is tapped.
  final void Function(Illustration illustration)? onTapIllustration;

  /// Illustration list.
  final List<Illustration> illustrations;

  final List<PopupMenuEntry<EnumIllustrationItemAction>> popupMenuItems;

  /// Window's size.
  final Size windowSize;

  /// Floating Action Button to show at the bottom right of this page.
  final Widget? fab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: fab,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const ApplicationBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 60.0,
                    left: 12.0,
                    right: 12.0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "illustrations".tr().toUpperCase(),
                        style: Utilities.fonts.body2(
                          textStyle: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.4,
                        child: Text(
                          "illustrations_subtitle".tr(),
                          style: Utilities.fonts.body(
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(42.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final Illustration illustration = illustrations.elementAt(
                        index,
                      );

                      return IllustrationCard(
                        illustration: illustration,
                        index: index,
                        heroTag: illustration.id,
                        onTap: onTapIllustration != null
                            ? () => onTapIllustration?.call(illustration)
                            : null,
                        borderRadius: BorderRadius.circular(12.0),
                        popupMenuEntries: popupMenuItems,
                        onPopupMenuItemSelected: onPopupMenuItemSelected,
                      );
                    },
                    childCount: illustrations.length,
                  ),
                  gridDelegate: getGridDelegate(),
                ),
              ),
            ],
          ),
          const Positioned(
            bottom: 24.0,
            left: 24.0,
            child: UploadPanel(),
          ),
        ],
      ),
    );
  }

  SliverGridDelegate getGridDelegate() {
    if (windowSize.width < Utilities.size.mobileWidthTreshold) {
      return const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      );
    }

    return const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 42.0,
      crossAxisSpacing: 42.0,
    );
  }
}
