import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_editor.dart';

class EditProjectPage extends StatefulWidget {
  final String? projectId;

  EditProjectPage({required this.projectId});

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
