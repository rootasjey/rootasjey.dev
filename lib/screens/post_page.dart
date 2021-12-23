import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:like_button/like_button.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:rootasjey/actions/posts.dart';
import 'package:rootasjey/components/author_header.dart';
import 'package:rootasjey/components/dates_header.dart';
import 'package:rootasjey/components/application_bar/main_app_bar.dart';
import 'package:rootasjey/components/markdown_viewer.dart';
import 'package:rootasjey/components/sliver_loading_view.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post.dart';
import 'package:rootasjey/utils/app_logger.dart';
import 'package:rootasjey/utils/cloud.dart';
import 'package:rootasjey/utils/constants.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:rootasjey/utils/keybindings.dart';
import 'package:rootasjey/utils/mesure_size.dart';
import 'package:rootasjey/utils/snack.dart';
import 'package:unicons/unicons.dart';
import 'package:supercharged/supercharged.dart';
import 'package:url_launcher/url_launcher.dart';

class PostPage extends StatefulWidget {
  @required
  final String? postId;

  PostPage({this.postId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _isFabVisible = false;
  bool _isLiked = false;
  bool _isLoading = false;

  final double _textWidth = 750.0;
  final _scrollController = ScrollController();

  FocusNode _focusNode = FocusNode();

  KeyBindings _keyBindings = KeyBindings();

  Post? _post;

  String _postData = '';
  String _postShareUrl = '';

  @override
  initState() {
    super.initState();

    fetchMeta();
    fetchContent();

    _postShareUrl = "https://rootasjey.dev/posts/${widget.postId}";

    // Delay initialization.
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _keyBindings.init(
        scrollController: _scrollController,
        pageHeight: 100.0,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: fab(),
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKey: (RawKeyEvent key) => _keyBindings.onKey(key, context),
        child: NotificationListener<ScrollNotification>(
          onNotification: onNotification,
          child: Scrollbar(
            controller: _scrollController,
            child: Focus(
              descendantsAreFocusable: false,
              child: Stack(
                children: [
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      MainAppBar(),
                      header(),
                      body(),
                    ],
                  ),
                  socialButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget allChips() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 16.0,
          children: [
            tags(),
            programmingLang(),
          ],
        ),
      ),
    );
  }

  Widget backButton() {
    return IconButton(
      tooltip: "back".tr(),
      onPressed: Beamer.of(context).beamBack,
      icon: Opacity(
        opacity: 0.6,
        child: Icon(UniconsLine.arrow_left),
      ),
    );
  }

  Widget body() {
    if (_isLoading) {
      return SliverLoadingView(
        title: "loading_post".tr(),
      );
    }

    final bool isNarrow = MediaQuery.of(context).size.width < 500.0;

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 400.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              if (!isNarrow) Spacer(),
              postBody(),
              if (!isNarrow) Spacer(),
            ],
          ),
        ]),
      ),
    );
  }

  Widget postBody() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: MeasureSize(
          onChange: (size) {
            _keyBindings.updatePageHeight(size.height);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownViewer(
                data: _postData,
                width: _textWidth,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dates() {
    return DatesHeader(
      padding: const EdgeInsets.only(top: 12.0),
      createdAt: Jiffy(_post!.createdAt).fromNow(),
      updatedAt: Jiffy(_post!.updatedAt).fromNow(),
    );
  }

  Widget fab() {
    if (!_isFabVisible) {
      return Container();
    }

    return FloatingActionButton.extended(
      backgroundColor: stateColors.primary,
      foregroundColor: Colors.white,
      onPressed: () => _scrollController.animateTo(
        0,
        duration: 250.milliseconds,
        curve: Curves.bounceOut,
      ),
      label: Text("scroll_to_top".tr()),
    );
  }

  Widget header() {
    if (_isLoading) {
      return SliverList(
        delegate: SliverChildListDelegate.fixed([]),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate.fixed([
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _textWidth,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backButton(),
                  allChips(),
                  title(),
                  summary(),
                  dates(),
                  AuthorHeader(
                    authorId: _post?.author?.id ?? '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget programmingLang() {
    if (_post!.programmingLanguages!.isEmpty) {
      return Container();
    }

    return Wrap(
      spacing: 8.0,
      children: _post!.programmingLanguages!
          .map(
            (pLang) => Tooltip(
              message: "Programming language",
              child: Chip(
                label: Text(pLang),
                side: BorderSide(
                  color: Colors.pink,
                  width: 1.5,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget socialButtons() {
    final size = MediaQuery.of(context).size;
    final top = size.height / 2 - 80.0;

    return Positioned(
      top: top,
      left: 60.0,
      child: Column(
        children: [
          if (_isFabVisible)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: backButton(),
            ),
          IconButton(
            tooltip: "copy_link".tr(),
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: _postShareUrl),
              );

              PostsActions.share(postId: _post!.id);

              Snack.s(
                context: context,
                message: "copy_link_success".tr(),
              );
            },
            icon: Opacity(
              opacity: 0.6,
              child: Icon(UniconsLine.link),
            ),
          ),
          IconButton(
            tooltip: "share_on_twitter".tr(),
            onPressed: () {
              final shareTags = _post!.tags.join(",");
              final baseShare = Constants.baseTwitterShareUrl;
              final hashTags = Constants.twitterShareHashtags;

              launch("$baseShare$_postShareUrl$hashTags$shareTags");

              PostsActions.share(postId: _post!.id);
            },
            icon: Opacity(
              opacity: 0.6,
              child: Icon(UniconsLine.twitter),
            ),
          ),
          IconButton(
            onPressed: () {},
            tooltip: "like".tr(),
            padding: EdgeInsets.zero,
            icon: LikeButton(
              size: 24.0,
              padding: EdgeInsets.zero,
              isLiked: _isLiked,
              likeBuilder: (bool isLiked) {
                return Icon(
                  isLiked ? UniconsLine.heart_break : UniconsLine.heart,
                  color: isLiked
                      ? Colors.pink
                      : stateColors.foreground.withOpacity(0.6),
                );
              },
              onTap: (bool isLiked) async {
                PostsActions.like(postId: _post!.id, like: !isLiked);
                return !isLiked;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget summary() {
    return Align(
      alignment: Alignment.topLeft,
      child: Opacity(
        opacity: 0.6,
        child: Text(
          _post!.summary,
          style: FontsUtils.mainStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget tags() {
    if (_post!.tags.isEmpty) {
      return Container();
    }

    return Wrap(
      spacing: 8.0,
      children: _post!.tags
          .map(
            (tag) => Tooltip(
              message: "Tag",
              child: Chip(
                label: Text(tag),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget title() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Text(
        _post!.title,
        style: FontsUtils.mainStyle(
          height: 1.0,
          fontSize: 80.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void fetchMeta() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      if (!doc.exists) {
        return;
      }

      final data = doc.data()!;
      data['id'] = doc.id;

      setState(() {
        _post = Post.fromJSON(data);
      });
    } catch (error) {
      appLogger.e(error.toString());
    }
  }

  void fetchContent() async {
    setState(() => _isLoading = true);

    try {
      final response =
          await Cloud.fun('posts-fetch').call({'postId': widget.postId});
      final markdownData = response.data['post'];

      _postData = markdown.markdownToHtml(markdownData);

      setState(() => _isLoading = false);
    } catch (error) {
      setState(() => _isLoading = false);
      appLogger.e(error.toString());

      Snack.e(
        context: context,
        message: "post_fetch_error".tr(),
      );
    }
  }

  bool onNotification(ScrollNotification notification) {
    // FAB visibility
    if (notification.metrics.pixels < 50 && _isFabVisible) {
      setState(() => _isFabVisible = false);
    } else if (notification.metrics.pixels > 50 && !_isFabVisible) {
      setState(() => _isFabVisible = true);
    }

    return false;
  }
}
