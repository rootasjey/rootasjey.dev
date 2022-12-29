import 'dart:convert';

class MinimalProjectCardData {
  MinimalProjectCardData({
    required this.projectId,
    required this.colorInt,
  });

  final String projectId;
  final int colorInt;

  MinimalProjectCardData copyWith({
    String? projectId,
    int? colorInt,
  }) {
    return MinimalProjectCardData(
      projectId: projectId ?? this.projectId,
      colorInt: colorInt ?? this.colorInt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'colorInt': colorInt,
    };
  }

  factory MinimalProjectCardData.fromMap(Map<String, dynamic> map) {
    return MinimalProjectCardData(
      projectId: map["project_id"] ?? "",
      colorInt: map["color_int"]?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MinimalProjectCardData.fromJson(String source) =>
      MinimalProjectCardData.fromMap(json.decode(source));

  @override
  String toString() =>
      'MinimalProjectCardData(projectId: $projectId, colorInt: $colorInt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MinimalProjectCardData &&
        other.projectId == projectId &&
        other.colorInt == colorInt;
  }

  @override
  int get hashCode => projectId.hashCode ^ colorInt.hashCode;
}
