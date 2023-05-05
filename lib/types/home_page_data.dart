import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:rootasjey/types/featured_project.dart';

class HomePageData {
  final String id;
  final List<FeaturedProject> featuredProjects;

  HomePageData({
    required this.id,
    required this.featuredProjects,
  });

  HomePageData copyWith({
    String? id,
    List<FeaturedProject>? featuredProjects,
  }) {
    return HomePageData(
      id: id ?? this.id,
      featuredProjects: featuredProjects ?? this.featuredProjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "featured_projects": featuredProjects.map((x) => x.toMap()).toList(),
    };
  }

  factory HomePageData.empty() {
    return HomePageData(
      id: "",
      featuredProjects: [],
    );
  }

  factory HomePageData.fromMap(Map<String, dynamic> map) {
    return HomePageData(
      id: map["id"] as String,
      featuredProjects: parseFeaturedProjects(map["featured_projects"]),
    );
  }

  static List<FeaturedProject> parseFeaturedProjects(
    List<dynamic>? rawProjects,
  ) {
    final List<FeaturedProject> projects = [];

    if (rawProjects == null) {
      return projects;
    }

    for (final rawProject in rawProjects) {
      projects.add(FeaturedProject.fromMap(rawProject));
    }

    return projects;
  }

  String toJson() => json.encode(toMap());

  factory HomePageData.fromJson(String source) =>
      HomePageData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      "HomePageData(id: $id, featuredProjects: $featuredProjects)";

  @override
  bool operator ==(covariant HomePageData other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.featuredProjects, featuredProjects);
  }

  @override
  int get hashCode => id.hashCode ^ featuredProjects.hashCode;
}
