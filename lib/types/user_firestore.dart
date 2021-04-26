import 'package:flutter/foundation.dart';
import 'package:rootasjey/types/user_stats.dart';
import 'package:rootasjey/utils/date_helper.dart';

import 'urls.dart';

class UserFirestore {
  final DateTime createdAt;
  final String email;
  final String id;
  final String job;
  final String lang;
  final String location;
  final String name;
  final String nameLowerCase;
  final String pricing;
  final String role;
  final UserStats stats;
  final String summary;
  final DateTime updatedAt;
  final Urls urls;

  UserFirestore({
    this.createdAt,
    this.email = 'anonymous@rootasjey.dev',
    @required this.id,
    this.job = 'Ghosting',
    this.lang = 'en',
    this.location = 'Nowhere',
    this.name = 'Anonymous',
    this.nameLowerCase = 'anonymous',
    this.pricing = 'free',
    this.role = 'user',
    this.stats,
    this.summary = 'An anonymous user ghosting decent people.',
    this.updatedAt,
    this.urls,
  });

  factory UserFirestore.empty() {
    return UserFirestore(
      createdAt: DateTime.now(),
      email: 'anonymous@rootasjey.dev',
      id: '',
      job: 'Ghosting',
      lang: 'en',
      location: 'Nowhere',
      name: 'Anonymous',
      nameLowerCase: 'anonymous',
      pricing: 'free',
      role: 'user',
      summary: 'An anonymous user ghosting decent people.',
      stats: UserStats.empty(),
      updatedAt: DateTime.now(),
      urls: Urls.empty(),
    );
  }

  factory UserFirestore.fromJSON(Map<String, dynamic> data) {
    if (data == null) {
      return UserFirestore.empty();
    }

    return UserFirestore(
      createdAt: DateHelper.fromFirestore(data['createdAt']),
      email: data['email'],
      id: data['id'],
      job: data['job'],
      lang: data['lang'],
      location: data['location'],
      name: data['name'],
      nameLowerCase: data['nameLowerCase'],
      pricing: data['pricing'],
      role: data['role'],
      stats: UserStats.fromJSON(data['stats']),
      summary: data['summary'],
      updatedAt: DateHelper.fromFirestore(data['updatedAt']),
      urls: Urls.fromJSON(data['urls']),
    );
  }
}
