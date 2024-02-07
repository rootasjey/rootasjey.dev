import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/post_card.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_post_item_action.dart';
import 'package:rootasjey/types/intents/escape_intent.dart';
import 'package:rootasjey/types/intents/next_intent.dart';
import 'package:rootasjey/types/intents/previous_intent.dart';
import 'package:rootasjey/types/post.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PostsPageBody extends StatelessWidget {
  const PostsPageBody({
    super.key,
    required this.posts,
    required this.postPopupMenuItems,
    required this.windowSize,
    required this.fab,
    this.canManage = false,
    this.onCancel,
    this.onPopupMenuItemSelected,
    this.onTapPost,
  });

  /// True if the current authenticated user can manage projects.
  final bool canManage;

  /// Callback fired to go back or exit this page.
  final void Function()? onCancel;

  /// Callback fired when a popup menu item is selected.
  final void Function(
    EnumPostItemAction,
    int,
    Post,
  )? onPopupMenuItemSelected;

  /// Callback fired after tapping on a project.
  final void Function(Post post)? onTapPost;

  /// Post list. Main data.
  final List<Post> posts;

  /// Menu item list to display on project card.
  final List<PopupMenuEntry<EnumPostItemAction>> postPopupMenuItems;

  /// Window dimension for adaptive/responsive UI.
  final Size windowSize;

  /// Page floating action button showing creation button if available.
  final Widget fab;

  @override
  Widget build(BuildContext context) {
    const double maxCrossAxisExtent = 800.0;
    final bool isMobileSize =
        windowSize.width < Utilities.size.mobileWidthTreshold;
    final double maxWidth = isMobileSize ? windowSize.width - 40.0 : 580.0;

    return Shortcuts(
      shortcuts: const <SingleActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowLeft): PreviousIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): NextIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          EscapeIntent: CallbackAction(
            onInvoke: (Intent intent) => onCancel?.call(),
          ),
        },
        child: Scaffold(
          floatingActionButton: fab,
          body: CustomScrollView(
            slivers: [
              ApplicationBar(
                padding: getAppBarPadding(windowSize),
              ),
              SliverPadding(
                padding: getTitlePadding(windowSize),
                sliver: SliverCrossAxisConstrained(
                  maxCrossAxisExtent: maxCrossAxisExtent,
                  alignment: -0.28,
                  child: SliverToBoxAdapter(
                    child: Text(
                      "posts".tr().toUpperCase(),
                      style: Utilities.fonts.body2(
                        textStyle: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverCrossAxisConstrained(
                maxCrossAxisExtent: maxCrossAxisExtent,
                alignment: -0.39,
                child: SliverPadding(
                  padding: const EdgeInsets.only(
                    top: 42.0,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final Post post = posts.elementAt(index);

                        return PostCard(
                          post: post,
                          onTap: onTapPost != null
                              ? () => onTapPost?.call(post)
                              : null,
                          maxWidth: maxWidth,
                          compact: isMobileSize,
                        );
                      },
                      childCount: posts.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  EdgeInsets getAppBarPadding(Size size) {
    if (size.width < 1000.0) {
      return const EdgeInsets.only(
        left: 0.0,
        top: 16.0,
      );
    }

    return const EdgeInsets.only(
      left: 120.0,
      top: 16.0,
    );
  }

  EdgeInsets getTitlePadding(Size size) {
    if (size.width < 1000.0) {
      return const EdgeInsets.only(left: 24.0, top: 64.0);
    }

    return const EdgeInsets.only(top: 120.0);
  }
}
