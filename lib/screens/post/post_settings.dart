import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/buttons/dark_elevated_button.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/cover.dart';
import 'package:rootasjey/types/enums/enum_content_visibility.dart';
import 'package:rootasjey/types/enums/enum_cover_corner.dart';
import 'package:rootasjey/types/enums/enum_cover_width.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';

class PostSettings extends StatelessWidget {
  const PostSettings({
    super.key,
    required this.cover,
    required this.visibility,
    required this.language,
    this.confirmDelete = false,
    this.hasCover = false,
    this.isMobileSize = false,
    this.show = false,
    this.onLanguageChanged,
    this.onVisibilitySelected,
    this.onTryAddCoverImage,
    this.onCloseSetting,
    this.onTryDeletePost,
    this.onConfirmDeletePost,
    this.onCancelDeletePost,
    this.onCoverWidthTypeSelected,
    this.onCoverCornerTypeSelected,
    this.onTryRemoveCoverImage,
  });

  /// Adapt the UI for small screens if this is true.
  final bool isMobileSize;

  /// Show this widget if true.
  /// Settings is hidden by default.
  final bool show;

  /// True if this post/project has an image cover.
  /// Used to customize the "upload a new cover" button.
  final bool hasCover;

  /// True if we must confirm a post/project deletion.
  /// If this is true, a specific panel will be visible to confirm action.
  final bool confirmDelete;

  /// This post's cover. Used to tweak its design (eg. full, center)
  final Cover cover;

  /// This post/project's current visibility.
  final EnumContentVisibility visibility;

  /// Callback fired when a new language is selected.
  final void Function(String language)? onLanguageChanged;

  /// Callback fired when a new visibility is selected.
  final void Function(
    EnumContentVisibility visibility,
    bool selected,
  )? onVisibilitySelected;

  /// Callback fired when we try to upload a new cover
  /// or replace an existing one.
  final void Function()? onTryAddCoverImage;

  /// Callback fired to remove the project/post cove;
  final void Function()? onTryRemoveCoverImage;

  /// Callback fired to close the settings panel.
  final void Function()? onCloseSetting;

  /// Callback fired to delete this post or project.
  final void Function()? onTryDeletePost;

  /// Callback to confirm post or project deletion.
  final void Function()? onConfirmDeletePost;

  /// Callback to cancel deletion.
  final void Function()? onCancelDeletePost;

  /// Callback fired when a new cover width type is selected.
  final void Function(
    EnumCoverWidth coverWidthType,
    bool selected,
  )? onCoverWidthTypeSelected;

  /// Callback fired when a new cover corner type is selected.
  final void Function(
    EnumCoverCorner coverCornerType,
    bool selected,
  )? onCoverCornerTypeSelected;

  /// Current post/project's language.
  final String language;

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SliverToBoxAdapter();
    }

    const double dividerHeight = 60.0;

    return SliverToBoxAdapter(
      child: PlayAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 900.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.decelerate,
        builder: (BuildContext context, double value, Widget? child) {
          return SizedBox(
            height: value,
            child: OverflowBox(
              maxHeight: double.infinity,
              child: child,
            ),
          );
        },
        child: Center(
          child: Container(
            width: 800.0,
            padding: const EdgeInsets.only(
              left: 42.0,
              right: 42.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleButton(
                      icon: const Icon(TablerIcons.x),
                      onTap: onCloseSetting,
                      margin: const EdgeInsets.only(right: 24.0),
                    ),
                    Text(
                      "settings".tr().toUpperCase(),
                      style: Utilities.fonts.body(
                        textStyle: TextStyle(
                          fontSize: isMobileSize ? 24.0 : 42.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                languageWidget(dividerHeight: dividerHeight),
                visibilityWidget(dividerHeight: dividerHeight),
                coverWidget(dividerHeight: dividerHeight),
                dangerZoneWidget(dividerHeight: dividerHeight),
                const Divider(height: dividerHeight * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget languageWidget({required double dividerHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: dividerHeight),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Language".toUpperCase(),
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: Utilities.lang.available().map((String chipLanguage) {
            return ChoiceChip(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              label: Text(
                Utilities.lang.toFullString(chipLanguage),
                style: Utilities.fonts.body(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: chipLanguage == language
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ),
              selected: chipLanguage == language,
              selectedColor: Colors.blue,
              onSelected: (bool selected) {
                onLanguageChanged?.call(chipLanguage);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget visibilityWidget({required double dividerHeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: dividerHeight),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              "Visibility".toUpperCase(),
              style: Utilities.fonts.body(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                EnumContentVisibility.private,
                EnumContentVisibility.public,
              ].map((chipVisibility) {
                return ChoiceChip(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  label: Text(
                    chipVisibility.name,
                    style: Utilities.fonts.body(
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: chipVisibility == visibility
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  selected: chipVisibility == visibility,
                  selectedColor: Colors.blue,
                  onSelected: (bool selected) {
                    onVisibilitySelected?.call(chipVisibility, selected);
                  },
                );
              }).toList()),
        ],
      ),
    );
  }

  Widget confirmDeleteWidget({required double dividerHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: dividerHeight),
        Opacity(
          opacity: 0.6,
          child: Text(
            "Delete this project".toUpperCase(),
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Text(
            "Are you sure?",
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 24.0,
          runSpacing: 24.0,
          children: [
            DarkElevatedButton(
              backgroundColor: Colors.pink,
              onPressed: onTryDeletePost,
              child: Text("confirmation_buttons.yes".tr()),
            ),
            DarkElevatedButton(
              onPressed: onCancelDeletePost,
              child: Text("confirmation_buttons.no".tr()),
            ),
          ],
        ),
      ],
    );
  }

  Widget coverWidget({required double dividerHeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: dividerHeight),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Cover".toUpperCase(),
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        coverWidthWidget(),
        coverCenterCustomWidget(),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Wrap(
            spacing: 24.0,
            runSpacing: 24.0,
            children: [
              DarkElevatedButton(
                onPressed: onTryAddCoverImage,
                child: Text(
                  hasCover ? "cover_replace".tr() : "cover_add".tr(),
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (hasCover)
                DarkElevatedButton(
                  onPressed: onTryRemoveCoverImage,
                  child: Text(
                    "cover_remove".tr(),
                    style: Utilities.fonts.body(
                      textStyle: const TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget coverCenterCustomWidget() {
    if (!hasCover || cover.widthType == EnumCoverWidth.full) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 200.0, child: Divider()),
        Opacity(
          opacity: 0.8,
          child: Text(
            "corners",
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              EnumCoverCorner.squared,
              EnumCoverCorner.rounded,
            ].map((coverCornerhType) {
              return ChoiceChip(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                label: Text(
                  coverCornerhType.name,
                  style: Utilities.fonts.body(
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: coverCornerhType == cover.cornerType
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                selected: coverCornerhType == cover.cornerType,
                selectedColor: Colors.blue.shade400,
                onSelected: (bool selected) {
                  onCoverCornerTypeSelected?.call(coverCornerhType, selected);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget dangerZoneWidget({required double dividerHeight}) {
    if (confirmDelete) {
      return confirmDeleteWidget(dividerHeight: dividerHeight);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: dividerHeight),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Danger zone".toUpperCase(),
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: [
            DarkElevatedButton(
              onPressed: onConfirmDeletePost,
              child: Text("delete".tr()),
            ),
          ],
        ),
      ],
    );
  }

  Widget coverWidthWidget() {
    if (!hasCover) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.8,
          child: Text(
            "width",
            style: Utilities.fonts.body(
              textStyle: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              EnumCoverWidth.center,
              EnumCoverWidth.full,
            ].map((coverWidthType) {
              return ChoiceChip(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                label: Text(
                  coverWidthType.name,
                  style: Utilities.fonts.body(
                    textStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: coverWidthType == cover.widthType
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                selected: coverWidthType == cover.widthType,
                selectedColor: Colors.blue.shade400,
                onSelected: (bool selected) {
                  onCoverWidthTypeSelected?.call(
                    coverWidthType,
                    selected,
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
