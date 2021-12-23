class PostImageMap {
  final String? cover;
  final String? thumbnail;

  PostImageMap({this.cover, this.thumbnail});

  factory PostImageMap.empty() {
    return PostImageMap(
      cover: '',
      thumbnail: '',
    );
  }

  factory PostImageMap.fromJSON(Map<String, dynamic>? data) {
    if (data == null) {
      return PostImageMap.empty();
    }

    return PostImageMap(
      cover: data['cover'],
      thumbnail: data['thumbnail'],
    );
  }
}
