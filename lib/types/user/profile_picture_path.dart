class ProfilePicturePath {
  final String edited;
  final String original;

  const ProfilePicturePath({
    this.edited = "",
    this.original = "",
  });

  factory ProfilePicturePath.empty() {
    return const ProfilePicturePath(
      edited: "",
      original: "",
    );
  }

  factory ProfilePicturePath.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return ProfilePicturePath.empty();
    }

    return ProfilePicturePath(
      edited: data["edited"],
      original: data["original"],
    );
  }

  ProfilePicturePath merge(ProfilePicturePath userPPPath) {
    final newEdited = userPPPath.edited;
    final newOriginal = userPPPath.original;

    return ProfilePicturePath(
      edited: newEdited.isNotEmpty ? newEdited : edited,
      original: newOriginal.isNotEmpty ? newOriginal : original,
    );
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = {};

    data["edited"] = edited;
    data["original"] = original;

    return data;
  }
}
