import 'dart:convert';

class FeatureProject {
  FeatureProject({
    required this.id,
    required this.color,
    required this.name,
    this.useIcon = false,
  });

  final String id;
  final int color;
  String name;
  final bool useIcon;

  FeatureProject copyWith({
    String? id,
    int? color,
    String? name,
    bool? useIcon,
  }) {
    return FeatureProject(
      id: id ?? this.id,
      color: color ?? this.color,
      name: name ?? this.name,
      useIcon: useIcon ?? this.useIcon,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "color_int": color,
      "project_id": id,
      "name": name,
      "use_icon": useIcon,
    };
  }

  factory FeatureProject.fromMap(Map<String, dynamic> map) {
    return FeatureProject(
      id: map["project_id"] as String,
      color: map["color_int"] as int,
      name: map["name"] ?? "",
      useIcon: map["use_icon"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeatureProject.fromJson(String source) =>
      FeatureProject.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FeaturedProject(id: $id, name: $name, color: $color, useIcon: $useIcon)';

  @override
  bool operator ==(covariant FeatureProject other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.color == color &&
        other.name == name &&
        other.useIcon == useIcon;
  }

  @override
  int get hashCode =>
      id.hashCode ^ color.hashCode ^ name.hashCode ^ useIcon.hashCode;
}
