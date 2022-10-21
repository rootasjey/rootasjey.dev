class Author {
  const Author({
    required this.id,
  });

  final String id;

  factory Author.empty() {
    return const Author(
      id: "",
    );
  }

  factory Author.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return Author.empty();
    }

    return Author(
      id: data["id"] ?? "",
    );
  }
}
