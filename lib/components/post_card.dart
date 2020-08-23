import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String title;
  final String summary;
  final String date;
  final String timeToRead;

  PostCard({
    this.title,
    this.summary,
    this.date,
    this.timeToRead,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 700.0,
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Opacity(
                opacity: 0.6,
                child: Text(
                  widget.summary,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),

              metaData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget metaData() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: 0.6,
            child: Text(
              widget.date,
            ),
          ),

          Container(
            width: 20.0,
            height: 20.0,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),

          Opacity(
            opacity: 0.6,
            child: Text(
              widget.timeToRead,
            ),
          ),
        ],
      ),
    );
  }
}
