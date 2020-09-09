import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rootasjey/types/urls.dart';

class Post {
  final String id;
  final String author;
  final List<String> coauthors;
  final DateTime createdAt;
  final bool featured;
  final String path;
  final bool referenced;
  final String summary;
  final List<String> tags;
  final String title;
  final String timeToRead;
  final DateTime updatedAt;
  final Urls urls;

  Post({
    this.id = '',
    this.author,
    this.coauthors  = const [],
    this.createdAt,
    this.featured   = false,
    this.path       = '',
    this.referenced = true,
    this.summary    = '',
    this.tags       = const [],
    this.timeToRead = '',
    this.title      = '',
    this.updatedAt,
    this.urls,
  });

  factory Post.fromJSON(Map<String, dynamic> data) {
    final _coauthors = <String>[];
    final _tags = <String>[];
    final dataTags = data['tags'] as Map<String, dynamic>;

    dataTags.forEach((key, value) {
      _tags.add(key);
    });

    final dataAuthors = data['coauthors'] as List<dynamic>;

    dataAuthors.forEach((authorId) {
      _coauthors.add(authorId);
    });

    return Post(
      id          : data['id'],
      author      : data['author'],
      coauthors   : _coauthors,
      createdAt   : (data['createdAt'] as Timestamp).toDate(),
      featured    : data['featured'],
      path        : data['path'],
      referenced  : data['referenced'],
      summary     : data['summary'],
      tags        : _tags,
      timeToRead  : data['timeToRead'],
      title       : data['title'],
      updatedAt   : (data['updatedAt'] as Timestamp).toDate(),
      urls        : Urls.fromJSON(data['urls']),
    );
  }
}
