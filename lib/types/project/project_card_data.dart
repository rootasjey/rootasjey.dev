import 'dart:convert';
import 'dart:ui';

import 'package:rootasjey/types/project/project.dart';

/// A data class for mini card project on home page.
class ProjectCardData {
  ProjectCardData({
    required this.color,
    required this.project,
  });

  final Color color;
  final Project project;

  ProjectCardData copyWith({
    Color? color,
    Project? project,
  }) {
    return ProjectCardData(
      color: color ?? this.color,
      project: project ?? this.project,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "color_int": color.value,
      "project": project.toMap(),
    };
  }

  factory ProjectCardData.fromMap(Map<String, dynamic> map) {
    return ProjectCardData(
      color: Color(map["color_int"]),
      project: Project.fromMap(map["project"]),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectCardData.fromJson(String source) =>
      ProjectCardData.fromMap(json.decode(source));

  @override
  String toString() => "ProjectCardData(color_int: $color, project: $project)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProjectCardData &&
        other.color == color &&
        other.project == project;
  }

  @override
  int get hashCode => color.hashCode ^ project.hashCode;
}
