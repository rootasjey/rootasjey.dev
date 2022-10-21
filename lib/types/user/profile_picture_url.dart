class ProfilePicutreUrl {
  final String edited;
  final String original;

  const ProfilePicutreUrl({
    this.edited = "",
    this.original = "",
  });

  factory ProfilePicutreUrl.empty() {
    return const ProfilePicutreUrl(
      edited: "",
      original: "",
    );
  }

  factory ProfilePicutreUrl.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return ProfilePicutreUrl.empty();
    }

    return ProfilePicutreUrl(
      edited: data["edited"] ?? "",
      original: data["original"] ?? "",
    );
  }

  ProfilePicutreUrl mergeFromValues({
    String? edited,
    String? original,
  }) {
    final newEditedValue = edited ?? this.edited;
    final newOriginalValue = original ?? this.original;

    return ProfilePicutreUrl(
      edited: newEditedValue,
      original: newOriginalValue,
    );
  }

  ProfilePicutreUrl merge(ProfilePicutreUrl userPPUrl) {
    final String newEditedValue =
        userPPUrl.edited.isNotEmpty ? userPPUrl.edited : edited;
    final String newOriginalValue =
        userPPUrl.original.isNotEmpty ? userPPUrl.original : original;

    return ProfilePicutreUrl(
      edited: newEditedValue,
      original: newOriginalValue,
    );
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = {};

    data["edited"] = edited;
    data["original"] = original;

    return data;
  }
}
