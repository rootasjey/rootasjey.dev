import 'package:flutter/material.dart';
import 'package:rootasjey/components/buttons/circle_button.dart';
import 'package:rootasjey/components/fade_in_x.dart';
import 'package:rootasjey/types/cover.dart';
import 'package:rootasjey/types/enums/enum_cover_corner.dart';
import 'package:rootasjey/types/enums/enum_cover_width.dart';
import 'package:unicons/unicons.dart';

class PostCover extends StatefulWidget {
  const PostCover({
    super.key,
    required this.cover,
    this.onTryAddCoverImage,
    this.onTryRemoveCoverImage,
    this.showControlButtons = false,
    this.isMobileSize = false,
    this.windowSize = Size.zero,
  });

  /// Adapt the UI for small screens if this is true.
  final bool isMobileSize;

  /// Show edit and remove buttons if this is true.
  final bool showControlButtons;

  /// Cover image of this post to show.
  final Cover cover;

  /// Callback fired when we try to upload a new cover
  /// or replace an existing one.
  final void Function()? onTryAddCoverImage;

  /// Callback fired to remove the project/post cove;
  final void Function()? onTryRemoveCoverImage;

  final Size windowSize;

  @override
  State<PostCover> createState() => _PostCoverState();
}

class _PostCoverState extends State<PostCover> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    if (widget.cover.storagePath.isEmpty) {
      return SliverToBoxAdapter(child: Container());
    }

    if (widget.cover.widthType == EnumCoverWidth.center) {
      return centerWidthWidget(context);
    }

    return fullWidthWidget(context);
  }

  Widget fullWidthWidget(BuildContext context) {
    final Size windowSize = widget.windowSize;
    final double height =
        widget.isMobileSize ? windowSize.width : windowSize.height;

    return SliverToBoxAdapter(
      child: InkWell(
        onHover: (bool isHover) {
          if (!widget.showControlButtons) {
            return;
          }

          setState(() => _isHover = isHover);
        },
        onTap: widget.showControlButtons ? () {} : null,
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  widget.cover.thumbnails.xxl,
                  fit: BoxFit.cover,
                  height: height,
                ),
              ),
              buttonsWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget centerWidthWidget(BuildContext context) {
    const double height = 500.0;
    const double width = 800.0;

    return SliverToBoxAdapter(
      child: Center(
        child: InkWell(
          onHover: (bool isHover) {
            setState(() => _isHover = isHover);
          },
          onTap: () {},
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
            ),
            clipBehavior: widget.cover.cornerType == EnumCoverCorner.rounded
                ? Clip.hardEdge
                : Clip.none,
            child: Stack(
              children: [
                Image.network(
                  widget.cover.thumbnails.xxl,
                  fit: BoxFit.cover,
                  width: width,
                  height: height,
                ),
                buttonsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonsWidget() {
    if (!_isHover) {
      return Container();
    }

    return Positioned(
      top: 12.0,
      right: 12.0,
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: [
          FadeInX(
            beginX: 24.0,
            delay: const Duration(milliseconds: 0),
            child: CircleButton(
              backgroundColor: Colors.black54,
              elevation: 2.0,
              icon: const Icon(UniconsLine.trash),
              onTap: widget.onTryRemoveCoverImage,
            ),
          ),
          FadeInX(
            beginX: 24.0,
            delay: const Duration(milliseconds: 50),
            child: CircleButton(
              backgroundColor: Colors.black54,
              elevation: 2.0,
              icon: const Icon(UniconsLine.upload),
              onTap: widget.onTryAddCoverImage,
            ),
          ),
        ],
      ),
    );
  }
}
