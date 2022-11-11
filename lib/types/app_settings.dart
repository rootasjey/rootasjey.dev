import 'dart:convert';

import 'package:rootasjey/types/social_links.dart';

class AppSettings {
  final SocialLinks socialNetworks;
  AppSettings({
    required this.socialNetworks,
  });

  factory AppSettings.empty() {
    return AppSettings(socialNetworks: SocialLinks.empty());
  }

  AppSettings copyWith({
    SocialLinks? socialNetworks,
  }) {
    return AppSettings(
      socialNetworks: socialNetworks ?? this.socialNetworks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "social_networks": socialNetworks.toMap(),
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      socialNetworks: SocialLinks.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) =>
      AppSettings.fromMap(json.decode(source));

  @override
  String toString() => "AppSettings(socialNetworks: $socialNetworks)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppSettings && other.socialNetworks == socialNetworks;
  }

  @override
  int get hashCode => socialNetworks.hashCode;
}
