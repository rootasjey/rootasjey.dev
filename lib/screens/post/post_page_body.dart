import 'dart:ui';

import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme_collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:loggy/loggy.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/all.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/loading_view.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utilities.dart';

class PostPageBody extends StatelessWidget with UiLoggy {
  const PostPageBody({
    super.key,
    required this.content,
    required this.maxWidth,
    required this.editingController,
    this.editing = false,
    this.canManagePosts = false,
    this.isMobileSize = false,
    this.loading = false,
    this.onContentChanged,
    this.copyIcon = const Icon(TablerIcons.copy),
    this.onCopy,
    this.githubTheme = AnySyntaxHighlighterThemeCollection.defaultTheme,
  });

  /// The current authenticated user can edit & delete this post if true.
  final bool canManagePosts;

  /// Show a document editor if true.
  final bool editing;

  /// True if this post is being loaded.
  final bool loading;

  /// The UI adapts to small screen size if true.
  final bool isMobileSize;

  /// Max allowed width to children inside this widget.
  final double maxWidth;

  /// Callback called when content has changed.
  final void Function(String content)? onContentChanged;

  final void Function(String code)? onCopy;

  /// Post's content to display in an editor.
  final String content;

  final TextEditingController editingController;

  final AnySyntaxHighlighterTheme githubTheme;

  final Icon copyIcon;

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
      return editView(context);
    }

    return readOnlyView(context);
  }

  Widget editView(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(
            top: 42.0,
            left: 12.0,
            right: 12.0,
          ),
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
                          .bodyMedium
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

  // Widget readOnlyView() {
  //   return SliverToBoxAdapter(
  //     child: Center(
  //       child: Container(
  //         padding: const EdgeInsets.only(
  //           top: 42.0,
  //           left: 12.0,
  //           right: 12.0,
  //         ),
  //         width: maxWidth,
  //         child: MarkdownViewer(
  //           content,
  //           enableTaskList: true,
  //           enableSuperscript: true,
  //           enableSubscript: true,
  //           enableFootnote: true,
  //           enableImageSize: false,
  //           enableKbd: false,
  //           syntaxExtensions: [LineReturnSyntax()],
  //           elementBuilders: [
  //             LineReturnBuilder(),
  //           ],
  //          // highlightBuilder: (text, language, infoString) {
  //          //   final prism = Prism(
  //          //     mouseCursor: SystemMouseCursors.text,
  //          //     style: PrismStyle(
  //          //       keyword: const TextStyle(
  //          //         color: Colors.green,
  //          //       ),
  //          //       string: TextStyle(
  //          //         color: Colors.blue.shade200,
  //          //       ),
  //          //     ),
  //          //   );
  //          //   return prism.render(text, language ?? "plain");
  //          // },
  //           selectionColor: Colors.pink.withOpacity(0.2),
  //           onTapLink: (href, title) async {
  //             if (href == null) {
  //               return;
  //             }
  //             final uri = Uri.parse(href);
  //             if (!await canLaunchUrl(uri)) {
  //               return;
  //             }
  //             launchUrl(uri);
  //           },
  //           styleSheet: MarkdownStyle(
  //             link: Utilities.fonts.body4(
  //               textStyle: const TextStyle(
  //                 color: Colors.amber,
  //                 fontSize: 18.0,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             list: const TextStyle(
  //               height: 2.0,
  //             ),
  //             paragraphPadding: const EdgeInsets.only(top: 0.0, bottom: 12.0),
  //             textStyle: Utilities.fonts.body4(
  //               textStyle: TextStyle(
  //                 color: Colors.white.withOpacity(0.8),
  //                 fontSize: 18.0,
  //               ),
  //             ),
  //             headline1: Utilities.fonts.body4(
  //               textStyle: const TextStyle(
  //                 fontSize: 54.0,
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //             h1Padding: const EdgeInsets.only(top: 28.0),
  //             headline2: Utilities.fonts.body4(
  //               textStyle: const TextStyle(
  //                 fontSize: 38.0,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             h2Padding: const EdgeInsets.only(top: 28.0),
  //             listItemMarkerTrailingSpace: 12,
  //             codeblockDecoration: BoxDecoration(
  //               color: Colors.black54,
  //               borderRadius: BorderRadius.circular(8.0),
  //             ),
  //             codeblockPadding: const EdgeInsets.all(24.0),
  //             codeSpan: Utilities.fonts.code(
  //               textStyle: const TextStyle(
  //                 fontSize: 14,
  //               ),
  //             ),
  //             codeBlock: Utilities.fonts.code(
  //               textStyle: const TextStyle(
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget readOnlyView(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(
            top: 42.0,
            left: 12.0,
            right: 12.0,
          ),
          width: maxWidth,
          child: MarkdownWidget(
            data: content,
            shrinkWrap: true,
            config: MarkdownConfig.darkConfig.copy(
              configs: [
                PConfig(
                  textStyle: Utilities.fonts.body4(
                    textStyle: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.8),
                      fontSize: 18.0,
                    ),
                  ),
                ),
                H1Config(
                  style: Utilities.fonts.body4(
                    textStyle: const TextStyle(
                      fontSize: 54.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                H2Config(
                  style: Utilities.fonts.body4(
                    textStyle: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.8),
                    ),
                  ),
                ),
                LinkConfig(
                  style: Utilities.fonts.body4(
                    textStyle: const TextStyle(
                      color: Colors.amber,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                PreConfig(
                  wrapper: (child, code, _) {
                    return Stack(
                      children: [
                        AnySyntaxHighlighter(
                          code,
                          isSelectableText: true,
                          lineNumbers: true,
                          padding: 12.0,
                          // lineNumbersPadding:
                          //     const EdgeInsets.only(right: 12.0),
                          theme: AnySyntaxHighlighterTheme(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            private: githubTheme.private,
                            classStyle: githubTheme.classStyle,
                            staticStyle: githubTheme.staticStyle,
                            constructor: githubTheme.constructor,
                            comment: githubTheme.comment,
                            multilineComment: githubTheme.multilineComment,
                            method: githubTheme.method,
                            keyword: githubTheme.keyword,
                            string: githubTheme.string,
                            number: githubTheme.number,
                            identifier: githubTheme.identifier,
                            function: githubTheme.function,
                            separator: githubTheme.separator,
                            operator: githubTheme.operator,
                            fontFamily: githubTheme.fontFamily,
                            fontFeatures: githubTheme.fontFeatures,
                            letterSpacing: githubTheme.letterSpacing,
                            wordSpacing: githubTheme.wordSpacing,
                            lineNumber: Utilities.fonts.body4(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.4),
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12.0,
                          right: 12.0,
                          child: CircleButton(
                            onTap: () => onCopy?.call(code),
                            icon: copyIcon,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
