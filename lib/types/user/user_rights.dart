import 'dart:convert';

class UserRights {
  const UserRights({
    this.manageData = false,
    this.managePosts = false,
    this.manageUsers = false,
  });

  /// If true, the current user can manage app data.
  final bool manageData;

  /// True if the current user can edit application's blog posts.
  final bool managePosts;

  /// True if the current user can manage (add, remove, edit) users.
  final bool manageUsers;

  /// User's right key prefix used to store document in Firestore.
  static String prefixKey = "user:";

  UserRights copyWith({
    bool? manageData,
    bool? managePosts,
    bool? manageUsers,
  }) {
    return UserRights(
      manageData: manageData ?? this.manageData,
      managePosts: managePosts ?? this.managePosts,
      manageUsers: manageUsers ?? this.manageUsers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "${prefixKey}manage_data": manageData,
      "${prefixKey}manage_posts": managePosts,
      "${prefixKey}manage_users": manageUsers,
    };
  }

  factory UserRights.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const UserRights();
    }

    return UserRights(
      manageData: map["${prefixKey}manage_data"] ?? false,
      managePosts: map["${prefixKey}manage_posts"] ?? false,
      manageUsers: map["${prefixKey}manage_users"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRights.fromJson(String source) =>
      UserRights.fromMap(json.decode(source));

  @override
  String toString() => "UserRights(manageData: $manageData, "
      "managePosts: $managePosts, manageUsers: $manageUsers)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRights &&
        other.manageData == manageData &&
        other.managePosts == managePosts &&
        other.manageUsers == manageUsers;
  }

  @override
  int get hashCode =>
      manageData.hashCode ^ managePosts.hashCode ^ manageUsers.hashCode;
}
