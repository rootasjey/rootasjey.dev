class Urls {
  String artbooking;
  String behance;
  String bitbucket;
  String dribbble;
  String facebook;
  String github;
  String gitlab;
  String image;
  String instagram;
  String linkedin;
  String other;
  String tiktok;
  String twitch;
  String twitter;
  String website;
  String wikipedia;
  String youtube;

  Map<String, String> map = Map<String, String>();

  Urls({
    this.artbooking = '',
    this.behance = '',
    this.bitbucket = '',
    this.dribbble = '',
    this.facebook = '',
    this.github = '',
    this.gitlab = '',
    this.image = '',
    this.instagram = '',
    this.linkedin = '',
    this.other = '',
    this.tiktok = '',
    this.twitch = '',
    this.twitter = '',
    this.website = '',
    this.wikipedia = '',
    this.youtube = '',
    this.map,
  });

  bool areLinksEmpty() {
    return artbooking.isEmpty &&
        behance.isEmpty &&
        dribbble.isEmpty &&
        facebook.isEmpty &&
        github.isEmpty &&
        gitlab.isEmpty &&
        instagram.isEmpty &&
        linkedin.isEmpty &&
        other.isEmpty &&
        tiktok.isEmpty &&
        twitch.isEmpty &&
        twitter.isEmpty &&
        website.isEmpty &&
        wikipedia.isEmpty &&
        youtube.isEmpty;
  }

  factory Urls.empty() {
    return Urls(
      artbooking: '',
      behance: '',
      bitbucket: '',
      dribbble: '',
      facebook: '',
      github: '',
      gitlab: '',
      image: '',
      instagram: '',
      linkedin: '',
      other: '',
      tiktok: '',
      twitch: '',
      twitter: '',
      website: '',
      wikipedia: '',
      youtube: '',
    );
  }

  factory Urls.fromJSON(Map<String, dynamic> data) {
    if (data == null) {
      return Urls.empty();
    }

    final dataMap = Map<String, String>();
    data.forEach((key, value) {
      dataMap[key] = value;
    });

    return Urls(
      artbooking: data['artbooking'] ?? '',
      behance: data['behance'] ?? '',
      dribbble: data['dribbble'] ?? '',
      facebook: data['facebook'] ?? '',
      github: data['github'] ?? '',
      gitlab: data['gitlab'] ?? '',
      image: data['image'] ?? '',
      instagram: data['instagram'] ?? '',
      linkedin: data['linkedin'] ?? '',
      map: dataMap,
      other: data['other'] ?? '',
      tiktok: data['tiktok'] ?? '',
      twitch: data['twitch'] ?? '',
      twitter: data['twitter'] ?? '',
      website: data['website'] ?? '',
      wikipedia: data['wikipedia'] ?? '',
      youtube: data['youtube'] ?? '',
    );
  }
}
