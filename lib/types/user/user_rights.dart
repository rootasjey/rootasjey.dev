import 'dart:convert';

class UserRights {
  const UserRights({
    this.manageData = false,
    this.manageIllustrations = false,
    this.managePages = false,
    this.managePosts = false,
    this.manageSettings = false,
    this.manageUsers = false,
  });

  /// If true, the current user can manage app data.
  final bool manageData;

  /// True if the current user can manage (add, remove, edit) illustrations.
  final bool manageIllustrations;

  /// True if the current user can edit app pages (e.g. home page).
  final bool managePages;

  /// True if the current user can edit application's blog posts.
  final bool managePosts;

  /// True if the current user can manage (add, remove, edit) app settings.
  final bool manageSettings;

  /// True if the current user can manage (add, remove, edit) users.
  final bool manageUsers;

  /// User's right key prefix used to store document in Firestore.
  static String prefixKey = "user:";

  UserRights copyWith({
    bool? manageData,
    bool? manageIllustrations,
    bool? managePages,
    bool? managePosts,
    bool? manageSettings,
    bool? manageUsers,
  }) {
    return UserRights(
      manageData: manageData ?? this.manageData,
      manageIllustrations: manageIllustrations ?? this.manageIllustrations,
      managePages: manageUsers ?? this.managePages,
      managePosts: managePosts ?? this.managePosts,
      manageSettings: manageUsers ?? this.manageSettings,
      manageUsers: manageUsers ?? this.manageUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "${prefixKey}manage_data": manageData,
      "${prefixKey}manage_illustrations": manageIllustrations,
      "${prefixKey}manage_pages": managePages,
      "${prefixKey}manage_posts": managePosts,
      "${prefixKey}manage_settings": manageSettings,
      "${prefixKey}manage_users": manageUsers,
    };
  }

  factory UserRights.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const UserRights();
    }

    return UserRights(
      manageData: map["${prefixKey}manage_data"] ?? false,
      manageIllustrations: map["${prefixKey}manage_illustrations"] ?? false,
      managePages: map["${prefixKey}manage_pages"] ?? false,
      managePosts: map["${prefixKey}manage_posts"] ?? false,
      manageSettings: map["${prefixKey}manage_settings"] ?? false,
      manageUsers: map["${prefixKey}manage_users"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRights.fromJson(String source) =>
      UserRights.fromMap(json.decode(source));

  @override
  String toString() => "UserRights(manageData: $manageData, "
      "manageIllustrations: $manageIllustrations, managePages: $managePages, "
      "managePosts: $managePosts, manageSeeintgs: $manageSettings, "
      "manageUsers: $manageUsers)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRights &&
        other.manageData == manageData &&
        other.manageIllustrations == manageIllustrations &&
        other.managePages == managePages &&
        other.managePosts == managePosts &&
        other.manageSettings == manageSettings &&
        other.manageUsers == manageUsers;
  }

  @override
  int get hashCode =>
      manageData.hashCode ^
      manageIllustrations.hashCode ^
      managePages.hashCode ^
      managePosts.hashCode ^
      manageSettings.hashCode ^
      manageUsers.hashCode;
}
