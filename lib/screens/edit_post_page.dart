import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/post_editor.dart';

class EditPostPage extends StatefulWidget {
  final String postId;

  EditPostPage({@required @PathParam() this.postId});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  @override
  Widget build(BuildContext context) {
    return PostEditor(
      postId: widget.postId,
    );
  }
}
