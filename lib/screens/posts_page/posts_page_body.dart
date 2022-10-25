import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/fade_in_y.dart';
import 'package:rootasjey/components/icons/app_icon.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/types/enums/enum_post_item_action.dart';
import 'package:rootasjey/types/intents/escape_intent.dart';
import 'package:rootasjey/types/intents/next_intent.dart';
import 'package:rootasjey/types/intents/previous_intent.dart';
import 'package:rootasjey/types/post.dart';
import 'package:unicons/unicons.dart';

class PostsPageBody extends StatelessWidget {
  const PostsPageBody({
    super.key,
    this.onTapPost,
    required this.posts,
    required this.postPopupMenuItems,
    required this.windowSize,
    required this.fab,
    this.onPopupMenuItemSelected,
    this.canManage = false,
    this.onCancel,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 72.0,
                    top: 72.0,
                    bottom: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FadeInY(
                            beginY: Utilities.ui.getBeginY(),
                            delay: Duration(
                              milliseconds: Utilities.ui
                                  .getNextAnimationDelay(reset: true),
                            ),
                            child: CircleButton(
                              onTap: Beamer.of(context).beamBack,
                              icon: const Icon(UniconsLine.arrow_left),
                              backgroundColor: Colors.amber,
                            ),
                          ),
                          FadeInY(
                            beginY: Utilities.ui.getBeginY(),
                            delay: Duration(
                              milliseconds:
                                  Utilities.ui.getNextAnimationDelay(),
                            ),
                            child: const Opacity(
                              opacity: 0.6,
                              child: AppIcon(
                                margin: EdgeInsets.only(left: 12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      FadeInY(
                        beginY: Utilities.ui.getBeginY(),
                        delay: Duration(
                          milliseconds: Utilities.ui.getNextAnimationDelay(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Text(
                            "Posts".toUpperCase(),
                            style: Utilities.fonts.body2(
                              textStyle: const TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final Post post = posts.elementAt(index);

                    return Card(
                      elevation: 0.0,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              post.name,
                              style: Utilities.fonts.body(
                                textStyle: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: posts.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
