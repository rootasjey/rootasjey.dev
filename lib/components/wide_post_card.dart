import 'package:flutter/material.dart';
import 'package:rootasjey/screens/post_page.dart';
import 'package:rootasjey/state/colors.dart';

class WidePostCard extends StatefulWidget {
  @required final String? id;
  final String? title;
  final String? summary;
  final String? metadata;
  final String? imageUrl;
  final List<String> tags;

  WidePostCard({
    this.id,
    this.imageUrl,
    this.metadata,
    this.summary,
    this.tags = const [],
    this.title,
  });

  @override
  _WidePostCardState createState() => _WidePostCardState();
}

class _WidePostCardState extends State<WidePostCard> {
  Color? foreground;

  @override
  initState() {
    super.initState();

    setState(() {
      foreground = stateColors.foreground;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 400.0,
          width: 800.0,
          child: Card(
            elevation: 6.0,
            child: Ink.image(
              image: NetworkImage(widget.imageUrl!),
              fit: BoxFit.cover,
              width: 700.0,
              height: 300.0,
              child: InkWell(
                onTap: navigateToPost,
                onHover: (isHover) {
                  isHover
                    ? setState(() => foreground = stateColors.primary)
                    : setState(() => foreground = stateColors.foreground);
                },
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 40.0,
          ),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: widget.tags.map((tag) {
              return Opacity(
                opacity: 0.6,
                child: Chip(
                  label: Text(
                    tag,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
            left: 8.0,
          ),
          child: postInkWell(
            child: Text(
              widget.title!,
              style: TextStyle(
                color: foreground,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 8.0,
          ),
          child: postInkWell(
            child: Opacity(
              opacity: 0.6,
              child: Text(
                widget.summary!,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 8.0,
          ),
          child: postInkWell(
            child: Opacity(
              opacity: 0.4,
              child: Text(
                widget.metadata!,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget postInkWell({Widget? child}) {
    return InkWell(
      onTap: navigateToPost,
      hoverColor: Colors.transparent,
      onHover: (isHover) {
        isHover
          ? setState(() => foreground = stateColors.primary)
          : setState(() => foreground = stateColors.foreground);
      },
      child: child,
    );
  }

  void navigateToPost() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return PostPage(
            postId: widget.id,
          );
        },
      ),
    );
  }
}
