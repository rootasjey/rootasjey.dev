import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rootasjey/components/author_component.dart';
import 'package:rootasjey/components/buttons/close_ship.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_content_visibility.dart';
import 'package:simple_animations/simple_animations.dart';

class PostPageHeader extends StatelessWidget {
  const PostPageHeader({
    super.key,
    required this.createdAt,
    required this.publishedAt,
    required this.updatedAt,
    required this.visibility,
    required this.tags,
    required this.documentId,
    required this.language,
    required this.name,
    required this.summary,
    required this.userId,
    required this.summaryController,
    required this.nameController,
    required this.tagInputController,
    this.showAddTag = false,
    this.canManagePosts = false,
    this.isMobileSize = false,
    this.onNameChanged,
    this.onInputTagChanged,
    this.onRemoveTag,
    this.onToggleAddTagVisibility,
  });

  /// The current authenticated user can edit & delete this post if true.
  final bool canManagePosts;

  /// The UI adapts to small screen size if true.
  final bool isMobileSize;

  /// Show an input to add more tags if true.
  final bool showAddTag;

  /// Date when this project was created.
  final DateTime createdAt;

  /// Date when this project was published.
  final DateTime publishedAt;

  /// Date when this project was last updated.
  final DateTime updatedAt;

  /// Currently project's visibility (e.g. private|public)
  final EnumContentVisibility visibility;

  /// Callback fired when input tag has changed.
  /// Useful to automatically save a new tag after specific key (e.g. ",", " ").
  final void Function(String tag)? onInputTagChanged;

  /// Callback fired when title is updated.
  final void Function(String? newTitle)? onNameChanged;

  /// Callback fired to remove a tag from a project.
  final void Function(String tag)? onRemoveTag;

  /// Callback fired when tag input visibility is toggled.
  final void Function()? onToggleAddTagVisibility;

  /// Current tags list of the project/post.
  final List<String> tags;

  /// Id the target document (project/post).
  final String documentId;

  /// Post language.
  final String language;

  /// Post name.
  final String name;

  /// Post description.
  final String summary;

  /// Author of this post..
  final String userId;

  /// Editing controller related to the project's summary.
  final TextEditingController summaryController;

  /// Editing controller related to the project's name.
  final TextEditingController nameController;

  /// Editing controller related to the project's tag.
  final TextEditingController tagInputController;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          padding: EdgeInsets.only(
            left: isMobileSize ? 12.0 : 24.0,
            right: isMobileSize ? 12.0 : 24.0,
          ),
          width: 800.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tagsWidget(context),
              addTagComponent(),
              titleWidget(),
              summaryWidget(),
              dateWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget authorWidget() {
    if (userId.isEmpty) {
      return Container();
    }

    return AuthorComponent(
      userId: userId,
      simpleMode: true,
    );
  }

  Widget dateWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            authorWidget(),
            dot(),
            publishedAtWidget(),
            // updatedAtWidget(),
          ],
        ),
      ),
    );
  }

  Widget dot() {
    final List<Color> colors = Constants.colors.palette.sublist(0)..shuffle();

    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: colors.first,
        borderRadius: BorderRadius.circular(24.0),
      ),
    );
  }

  Widget addTagComponent() {
    if (!showAddTag) {
      return Container();
    }

    return PlayAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 60.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value / 60,
          child: SizedBox(
            height: value,
            child: TextField(
              autofocus: true,
              controller: tagInputController,
              onChanged: onInputTagChanged,
              onSubmitted: onInputTagChanged,
              decoration: const InputDecoration(
                hintText: "Add tags...",
              ),
            ),
          ),
        );
      },
    );
  }

  Widget tagsWidget(BuildContext context) {
    final List<Widget> children = [
      ActionChip(
        elevation: 2.0,
        backgroundColor: Colors.pink,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Opacity(opacity: 0.8, child: Icon(TablerIcons.arrow_left)),
            Text("back".tr()),
          ],
        ),
        onPressed: () => Utilities.navigation.back(context),
      ),
    ];

    children.addAll(tags.map((tag) {
      return Chip(
        label: Text(tag),
        onDeleted: canManagePosts ? () => onRemoveTag?.call(tag) : null,
      );
    }));

    if (canManagePosts) {
      children.add(
        OpenCloseChip(
          onTap: onToggleAddTagVisibility,
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        ),
      ),
    );
  }

  Widget summaryWidget() {
    final TextStyle style = Utilities.fonts.body(
      textStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
    );

    if (!canManagePosts) {
      if (summary.isNotEmpty) {
        return Container();
      }

      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
        child: Opacity(
          opacity: 0.6,
          child: Text(
            summary,
            style: style,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Opacity(
        opacity: 0.6,
        child: TextField(
          controller: summaryController,
          style: style,
          textAlign: TextAlign.center,
          maxLines: null,
          onChanged: onNameChanged,
          decoration: InputDecoration(
            hintText: "${"project_summary_add".tr()}...",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    final TextStyle style = Utilities.fonts.body(
      textStyle: TextStyle(
        fontSize: isMobileSize ? 36.0 : 70.0,
        fontWeight: isMobileSize ? FontWeight.w700 : FontWeight.w600,
      ),
    );

    if (!canManagePosts) {
      return Hero(
        tag: documentId,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
      );
    }

    return Hero(
      tag: documentId,
      child: TextField(
        controller: nameController,
        style: style,
        textAlign: TextAlign.center,
        maxLines: null,
        onChanged: onNameChanged,
        decoration: InputDecoration(
          hintText: "post_title".tr(),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget publishedAtWidget() {
    final Duration publishedAtDiff = DateTime.now().difference(publishedAt);
    final String publishedAtStr = publishedAtDiff.inDays > 4
        ? Jiffy.parseFromDateTime(publishedAt).yMMMEd
        : Jiffy.parseFromDateTime(publishedAt).fromNow();

    return Opacity(
      opacity: 0.6,
      child: Text(
        publishedAtStr,
        style: Utilities.fonts.body2(
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget updatedAtWidget() {
    final bool updateSameOrBeforePub = Jiffy.parseFromDateTime(updatedAt)
        .isSameOrBefore(Jiffy.parseFromDateTime(publishedAt));

    final bool updatePubDiff = updatedAt.difference(publishedAt).inMinutes < 30;

    final bool dateTooClose = updateSameOrBeforePub || updatePubDiff;

    if (visibility == EnumContentVisibility.public && dateTooClose) {
      return Container();
    }

    if (updatedAt.difference(createdAt).inMinutes < 10) {
      return Container();
    }

    final Duration updatedAtDiff = DateTime.now().difference(updatedAt);
    final String updatedAtStr = updatedAtDiff.inDays > 20
        ? Jiffy.parseFromDateTime(updatedAt).format(pattern: "dd/MM/yy")
        : Jiffy.parseFromDateTime(updatedAt).fromNow();

    return Opacity(
      opacity: 0.5,
      child: Text(
        "(${"date_last_update".tr()}: $updatedAtStr)",
        style: Utilities.fonts.body2(
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
