import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rootasjey/types/urls.dart';

class PostHeadline {
  final String author;
  final List<String> coauthors;
  final DateTime createdAt;
  @required final String id;
  final String summary;
  final List<String> tags;
  final String timeToRead;
  @required final String title;
  final DateTime updatedAt;
  Urls urls;

  PostHeadline({
    this.author,
    this.coauthors = const [],
    this.createdAt,
    this.id,
    this.summary,
    this.tags = const [],
    this.timeToRead,
    this.title,
    this.updatedAt,
    this.urls,
  });

  factory PostHeadline.fromJSON(Map<String, dynamic> data) {
    final _tags = <String>[];
    var _coauthors = <String>[];

    if (data['tags'] != null) {
      Map<String, dynamic> mapTags = data['tags'];

      mapTags.forEach((key, value) {
        _tags.add(key);
      });
    }

    if (data['coauthors'] != null) {
      final dataCoauthors = data['coauthors'] as List<dynamic>;
      dataCoauthors.forEach((value) {
        _coauthors.add(value);
      });
    }

    return PostHeadline(
      author      : data['author'],
      coauthors   : _coauthors,
      createdAt   : (data['createdAt'] as Timestamp).toDate(),
      id          : data['id'],
      summary     : data['summary'],
      tags        : _tags,
      timeToRead  : data['timeToRead'],
      title       : data['title'],
      updatedAt   : (data['updatedAt'] as Timestamp).toDate(),
      urls        : Urls.fromJSON(data['urls']),
    );
  }
}