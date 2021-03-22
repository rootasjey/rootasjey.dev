import 'package:cloud_firestore/cloud_firestore.dart';

import 'urls.dart';

class UserFirestore {
  DateTime createdAt;
  String email;
  String lang;
  String name;
  String nameLowerCase;
  String pricing;
  String uid;
  DateTime updatedAt;
  Urls urls;

  UserFirestore({
    this.createdAt,
    this.email = '',
    this.lang = 'en',
    this.name = '',
    this.nameLowerCase = '',
    this.pricing = 'free',
    this.uid,
    this.updatedAt,
    this.urls,
  });

  factory UserFirestore.fromJSON(Map<String, dynamic> data) {
    return UserFirestore(
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      email: data['email'],
      lang: data['lang'],
      name: data['name'],
      nameLowerCase: data['nameLowerCase'],
      pricing: data['pricing'],
      uid: data['uid'],
      updatedAt: (data['updatedAt'] as Timestamp)?.toDate(),
      urls: Urls.fromJSON(data['urls']),
    );
  }
}
