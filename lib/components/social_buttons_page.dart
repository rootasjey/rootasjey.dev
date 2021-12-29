import 'package:beamer/beamer.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:unicons/unicons.dart';

class SocialButtonsPage extends StatelessWidget {
  const SocialButtonsPage({
    Key? key,
    this.top,
    this.left,
    this.showBackButton = false,
    this.onCopyLink,
    this.onShareOnTwitter,
    this.onFav,
    this.isFav = false,
  }) : super(key: key);

  final double? top;
  final double? left;
  final bool showBackButton;
  final VoidCallback? onCopyLink;
  final VoidCallback? onShareOnTwitter;
  final Future<bool?> Function(bool)? onFav;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 60.0,
      child: Column(
        children: [
          if (showBackButton)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: IconButton(
                tooltip: "back".tr(),
                onPressed: Beamer.of(context).beamBack,
                icon: Opacity(
                  opacity: 0.6,
                  child: Icon(UniconsLine.arrow_left),
                ),
              ),
            ),
          if (onCopyLink != null)
            IconButton(
              tooltip: "copy_link".tr(),
              onPressed: onCopyLink,
              icon: Opacity(
                opacity: 0.6,
                child: Icon(UniconsLine.link),
              ),
            ),
          if (onShareOnTwitter != null)
            IconButton(
              tooltip: "share_on_twitter".tr(),
              onPressed: onShareOnTwitter,
              icon: Opacity(
                opacity: 0.6,
                child: Icon(UniconsLine.twitter),
              ),
            ),
          if (onFav != null)
            IconButton(
              onPressed: () {},
              tooltip: "like".tr(),
              padding: EdgeInsets.zero,
              icon: LikeButton(
                size: 24.0,
                padding: EdgeInsets.zero,
                isLiked: isFav,
                likeBuilder: (bool isFav) {
                  return Icon(
                    isFav ? UniconsLine.heart_break : UniconsLine.heart,
                    color: isFav
                        ? Colors.pink
                        : Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.color
                            ?.withOpacity(0.6),
                  );
                },
                onTap: onFav,
              ),
            ),
        ],
      ),
    );
  }
}
