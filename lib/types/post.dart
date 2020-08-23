import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rootasjey/types/urls.dart';

class Post {
  final List<String> authors;
  final DateTime createdAt;
  final bool featured;
  final String path;
  final bool referenced;
  final String summary;
  final List<String> tags;
  final String title;
  final DateTime updatedAt;
  final Urls urls;

  Post({
    this.authors    = const [],
    this.createdAt,
    this.featured   = false,
    this.path       = '',
    this.referenced = true,
    this.summary    = '',
    this.tags       = const [],
    this.title      = '',
    this.updatedAt,
    this.urls,
  });

  factory Post.fromJSON(Map<String, dynamic> data) {
    final _authors = <String>[];
    final _tags = <String>[];
    final dataTags = data['tags'] as Map<String, dynamic>;

    dataTags.forEach((key, value) {
      _tags.add(key);
    });

    final dataAuthors = data['authors'] as List<dynamic>;

    dataAuthors.forEach((authorId) {
      _authors.add(authorId);
    });

    return Post(
      authors     : _authors,
      createdAt   : (data['createdAt'] as Timestamp).toDate(),
      featured    : data['featured'],
      path        : data['path'],
      referenced  : data['referenced'],
      summary     : data['summary'],
      tags        : _tags,
      title       : data['title'],
      updatedAt   : (data['updatedAt'] as Timestamp).toDate(),
      urls        : Urls.fromJSON(data['urls']),
    );
  }
}
