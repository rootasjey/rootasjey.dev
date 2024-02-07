import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/buttons/dark_elevated_button.dart';
import 'package:rootasjey/components/upload_panel/upload_panel.dart';
import 'package:rootasjey/globals/utilities.dart';

class IllustrationsPageEmpty extends StatelessWidget {
  const IllustrationsPageEmpty({
    super.key,
    required this.fab,
    this.onShowCreatePage,
    this.canCreate = false,
    this.onCancel,
  });

  /// True if the current authenticated user can create posts.
  final bool canCreate;

  /// Callback fired to show create page.
  final void Function()? onShowCreatePage;

  /// Callback fired to go back to the previous page or home location.
  final void Function()? onCancel;

  /// Page floating action button showing creation button if available.
  final Widget fab;

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
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/animations/skull_bats.json",
                        width: 200.0,
                        height: 200.0,
                        repeat: true,
                      ),
                      Text(
                        canCreate
                            ? "illustration_empty_create".tr()
                            : "illustrations_empty".tr(),
                        style: Utilities.fonts.body2(
                          textStyle: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (canCreate)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: DarkElevatedButton(
                            onPressed: canCreate ? onShowCreatePage : null,
                            child: Text("illustration_upload".tr()),
                          ),
                        ),
                      if (!canCreate)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: DarkElevatedButton(
                            onPressed: onCancel,
                            child: Text("back".tr()),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const UploadPanel(),
        ],
      ),
    );
  }
}
