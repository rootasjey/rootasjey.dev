import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_editor.dart';

class EditProjectPage extends StatefulWidget {
  final String projectId;

  EditProjectPage({@required @PathParam() this.projectId});

  @override
  _EditProjectPageState createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  @override
  Widget build(BuildContext context) {
    return ProjectEditor(
      projectId: widget.projectId,
    );
  }
}
