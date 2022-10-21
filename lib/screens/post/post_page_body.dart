import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prism/flutter_prism.dart';
import 'package:loggy/loggy.dart';
import 'package:markdown_viewer/markdown_viewer.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:rootasjey/screens/post/editor_plugins/markdown_line_return.dart';
import 'package:url_launcher/url_launcher.dart';

class PostPageBody extends StatelessWidget with UiLoggy {
  const PostPageBody({
    Key? key,
    required this.content,
    required this.maxWidth,
    required this.editingController,
    this.editing = false,
    this.canManagePosts = false,
    this.isMobileSize = false,
    this.loading = false,
    this.onContentChanged,
  }) : super(key: key);

  /// The current authenticated user can edit & delete this post if true.
  final bool canManagePosts;

  final bool editing;

  /// True if this post is being loaded.
  final bool loading;

  /// The UI adapts to small screen size if true.
  final bool isMobileSize;

  final double maxWidth;

  final void Function(String content)? onContentChanged;

  /// Post's content to display in an editor.
  final String content;

  final TextEditingController editingController;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return LoadingView(
        message: "loading".tr(),
      );
    }

    if (content.isEmpty) {
      return LoadingView(
        message: "post_content_creating".tr(),
      );
    }

    if (editing && canManagePosts) {
      return SliverToBoxAdapter(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 42.0),
            width: maxWidth,
            child: TextField(
              autofocus: true,
              controller: editingController,
              maxLines: null,
              minLines: 12,
              onChanged: onContentChanged,
              decoration: InputDecoration(
                hintText: "Once upon a time...",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.palette.first,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.color
                            ?.withOpacity(0.4) ??
                        Colors.white12,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Constants.colors.getRandomFromPalette(),
                    width: 4.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 42.0),
          width: maxWidth,
          child: MarkdownViewer(
            content,
            enableTaskList: true,
            enableSuperscript: true,
            enableSubscript: true,
            enableFootnote: true,
            enableImageSize: false,
            enableKbd: false,
            syntaxExtensions: [LineReturnSyntax()],
            elementBuilders: [
              LineReturnBuilder(),
            ],
            highlightBuilder: (text, language, infoString) {
              final prism = Prism(
                mouseCursor: SystemMouseCursors.text,
                style: PrismStyle(
                  keyword: const TextStyle(
                    color: Colors.green,
                  ),
                  string: TextStyle(
                    color: Colors.blue.shade200,
                  ),
                ),
              );
              return prism.render(text, language ?? "plain");
            },
            selectionColor: Colors.pink.withOpacity(0.2),
            onTapLink: (href, title) async {
              if (href == null) {
                return;
              }

              final uri = Uri.parse(href);

              if (!await canLaunchUrl(uri)) {
                return;
              }

              launchUrl(uri);
            },
            styleSheet: MarkdownStyle(
              link: Utilities.fonts.body5(
                const TextStyle(
                  color: Colors.amber,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              list: const TextStyle(
                height: 2.0,
              ),
              paragraphPadding: const EdgeInsets.only(top: 0.0, bottom: 12.0),
              textStyle: Utilities.fonts.body5(
                TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18.0,
                ),
              ),
              headline1: Utilities.fonts.body5(
                const TextStyle(
                  fontSize: 54.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              h1Padding: const EdgeInsets.only(top: 28.0),
              headline2: Utilities.fonts.body5(
                const TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              h2Padding: const EdgeInsets.only(top: 28.0),
              listItemMarkerTrailingSpace: 12,
              codeblockDecoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8.0),
              ),
              codeblockPadding: const EdgeInsets.all(24.0),
              codeSpan: Utilities.fonts.body4(
                fontSize: 14,
              ),
              codeBlock: Utilities.fonts.body4(
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
