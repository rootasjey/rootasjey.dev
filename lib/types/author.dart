class Author {
  final String? id;

  Author({required this.id});

  factory Author.empty() {
    return Author(
      id: '',
    );
  }

  factory Author.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return Author.empty();
    }

    return Author(
      id: data['id'],
    );
  }
}
