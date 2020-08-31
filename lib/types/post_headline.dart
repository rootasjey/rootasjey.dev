import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rootasjey/types/urls.dart';

class PostHeadline {
  @required final String id;
  @required final String title;
  final String summary;
  final String timeToRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  Urls urls;

  PostHeadline({
    this.id,
    this.title,
    this.summary,
    this.timeToRead,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
    this.urls,
  });

  factory PostHeadline.fromJSON(Map<String, dynamic> data) {
    final _tags = <String>[];

    if (data['tags'] != null) {
      Map<String, dynamic> mapTags = data['tags'];

      mapTags.forEach((key, value) {
        _tags.add(key);
      });
    }

    return PostHeadline(
      id          : data['id'],
      title       : data['title'],
      timeToRead  : data['timeToRead'],
      summary     : data['summary'],
      tags        : _tags,
      urls        : Urls.fromJSON(data['urls']),
      createdAt   : (data['createdAt'] as Timestamp).toDate(),
      updatedAt   : (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}