import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:super_editor/super_editor.dart';

class PostPageBody extends StatelessWidget {
  const PostPageBody({
    Key? key,
    required this.content,
    required this.document,
    required this.documentEditor,
    required this.maxWidth,
    this.canManagePosts = false,
    this.isMobileSize = false,
    this.loading = false,
  }) : super(key: key);

  /// The current authenticated user can edit & delete this post if true.
  final bool canManagePosts;

  /// True if this post is being loaded.
  final bool loading;

  /// The UI adapts to small screen size if true.
  final bool isMobileSize;

  /// Post's content.
  final Document document;

  /// Visible if the authenticated user has the right to edit this post.
  final DocumentEditor documentEditor;

  final double maxWidth;

  /// Post's content to display in an editor.
  final String content;

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

    if (!canManagePosts) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobileSize ? 0.0 : 56.0,
            horizontal: isMobileSize ? 12.0 : 24.0,
          ),
          child: SingleColumnDocumentLayout(
            presenter: SingleColumnLayoutPresenter(
              document: document,
              componentBuilders: defaultComponentBuilders,
              pipeline: [
                SingleColumnStylesheetStyler(stylesheet: defaultStylesheet),
              ],
            ),
            componentBuilders: defaultComponentBuilders,
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SuperEditor(
        editor: documentEditor,
        documentOverlayBuilders: [
          DefaultCaretOverlayBuilder(
            const CaretStyle().copyWith(color: Colors.amber),
          ),
        ],
        selectionStyle: SelectionStyles(
          selectionColor: Colors.amber.withOpacity(0.3),
        ),
        stylesheet: _createStylesheet(context),
        // componentBuilders: [
        //   const LinkComponentBuilder(),
        //   ...defaultComponentBuilders,
        // ],
      ),
    );
  }

  Stylesheet _createStylesheet(BuildContext context) {
    return defaultStylesheet.copyWith(
      rules: [
        StyleRule(
          BlockSelector.all,
          (Document doc, DocumentNode docNode) {
            return {
              "maxWidth": maxWidth,
              "padding": const CascadingPadding.symmetric(horizontal: 24),
              "textStyle": TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.color
                    ?.withOpacity(0.8),
                fontSize: 18,
                height: 1.4,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("header1"),
          (doc, docNode) {
            return {
              "padding": const CascadingPadding.only(top: 32, bottom: 8.0),
              "textStyle": TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.color
                    ?.withOpacity(0.8),
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("header2"),
          (doc, docNode) {
            return {
              "padding": const CascadingPadding.only(top: 32, bottom: 8.0),
              "textStyle": TextStyle(
                color: Theme.of(context).textTheme.bodyText2?.color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("header3"),
          (doc, docNode) {
            return {
              "padding": const CascadingPadding.only(top: 28),
              "textStyle": TextStyle(
                color: Theme.of(context).textTheme.bodyText2?.color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("paragraph"),
          (doc, docNode) {
            return {
              "padding": const CascadingPadding.only(top: 24),
            };
          },
        ),
        StyleRule(
          const BlockSelector("paragraph").after("header1"),
          (doc, docNode) {
            return {
              "padding": const CascadingPadding.only(top: 0),
            };
          },
        ),
        StyleRule(
          const BlockSelector("paragraph").after("header2"),
          (doc, docNode) {
            return {
              "padding": const CascadingPadding.only(top: 0),
            };
          },
        ),
        StyleRule(
          const BlockSelector("paragraph").after("header3"),
          (doc, docNode) {
            return {
              "padding": const CascadingPadding.only(top: 0),
            };
          },
        ),
        StyleRule(
          const BlockSelector("link"),
          (doc, docNode) {
            GlobalLoggy().loggy.info("link?");
            return {
              "textStyle": const TextStyle(
                color: Colors.pink,
                // fontSize: 18,
                // height: 1.4,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("a"),
          (doc, docNode) {
            GlobalLoggy().loggy.info("a?");
            return {
              "textStyle": const TextStyle(
                color: Colors.pink,
                // fontSize: 18,
                // height: 1.4,
              ),
            };
          },
        ),
        StyleRule(
          const BlockSelector("listItem"),
          (doc, docNode) {
            return {
              "padding": const CascadingPadding.only(top: 24),
            };
          },
        ),
        // StyleRule(
        //   BlockSelector.all.last(),
        //   (doc, docNode) {
        //     return {
        //       "padding": const CascadingPadding.only(bottom: 300),
        //     };
        //   },
        // ),
      ],
      inlineTextStyler: defaultInlineTextStyler,
      documentPadding: EdgeInsets.symmetric(
        horizontal: isMobileSize ? 0.0 : 24.0,
      ),
    );
  }
}
