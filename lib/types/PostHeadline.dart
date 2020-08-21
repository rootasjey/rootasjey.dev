import 'package:cloud_firestore/cloud_firestore.dart';

class PostHeadline {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostHeadline({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory PostHeadline.fromJSON(Map<String, dynamic> data) {
    return PostHeadline(
      id: data['id'],
      title: data['title'],
      createdAt : (data['createdAt'] as Timestamp).toDate(),
      updatedAt : (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}