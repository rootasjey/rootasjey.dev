import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/icons/cicle_app_icon.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:unicons/unicons.dart';

class PostAppBar extends StatefulWidget {
  const PostAppBar({
    super.key,
    required this.showSettings,
    required this.showTitle,
    required this.textTitle,
    this.onTapSettings,
    this.onTapTitle,
  });

  /// Used to handle settings button icon animation.
  final bool showSettings;

  /// Show the app bar title if true only if the Y offset is above
  /// a certain amount.
  final bool showTitle;

  /// Callback fired in order to show the settings panel.
  final void Function()? onTapSettings;

  /// Callback usally fired to scroll to top of the page.
  final void Function()? onTapTitle;

  /// App bar title value.
  final String textTitle;

  @override
  State<PostAppBar> createState() => _PostAppBarState();
}

class _PostAppBarState extends State<PostAppBar> with AnimationMixin {
  /// Handle button rotation icon animation.
  late Animation<double> angle;

  /// Animation's duration.
  final Duration _duration = const Duration(
    milliseconds: 250,
  );

  @override
  initState() {
    super.initState();
    angle = Tween(begin: 0.0, end: 60.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: true,
      floating: true,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: widget.showTitle
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: widget.onTapTitle,
                child: Text(
                  widget.textTitle,
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : Container(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(30.0),
        child: Container(
          height: 50.0,
          padding: const EdgeInsets.only(left: 12.0, bottom: 4.0),
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                left: 0.0,
                width: 40.0,
                // child: AppIcon(size: 24.0),
                child: CircleButton(
                  tooltip: "home".tr(),
                  // icon: const Icon(UniconsLine.box),
                  icon: const CircleAppIcon(size: 48.0),
                  onTap: () => Beamer.of(context, root: true).beamToNamed(
                    HomeLocation.route,
                  ),
                ),
              ),
              Positioned(
                top: 0.0,
                left: 48.0,
                width: 40.0,
                child: CircleButton(
                  tooltip: "back".tr(),
                  icon: const Icon(UniconsLine.arrow_left),
                  onTap: () => Utilities.navigation.back(context),
                ),
              ),
              Positioned(
                top: 0.0,
                right: 24.0,
                child: CircleButton(
                  tooltip: "home".tr(),
                  icon: const Icon(UniconsLine.home_alt),
                  onTap: () => Beamer.of(context, root: true).beamToNamed(
                    HomeLocation.route,
                  ),
                ),
              ),
              if (widget.onTapSettings != null)
                Positioned(
                  top: 0.0,
                  right: 70.0,
                  child: CircleButton(
                    tooltip: "settings".tr(),
                    icon: Transform.rotate(
                      angle: angle.value,
                      child: const Icon(UniconsLine.setting),
                    ),
                    onTap: () {
                      if (widget.showSettings) {
                        controller.playReverse(duration: _duration);
                      } else {
                        controller.play(duration: _duration);
                      }

                      widget.onTapSettings?.call();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
