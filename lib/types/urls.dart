class Urls {
  String behance;
  String bitbucket;
  String dribbble;
  String facebook;
  String github;
  String gitlab;
  String image;
  String instagram;
  String twitter;
  String website;
  String wikipedia;
  String youtube;

  Urls({
    this.behance = '',
    this.bitbucket = '',
    this.dribbble = '',
    this.facebook = '',
    this.github = '',
    this.gitlab = '',
    this.image = '',
    this.instagram = '',
    this.twitter = '',
    this.website = '',
    this.wikipedia = '',
    this.youtube = '',
  });

  bool areLinksEmpty() {
    return behance.isEmpty &&
        dribbble.isEmpty &&
        facebook.isEmpty &&
        github.isEmpty &&
        gitlab.isEmpty &&
        instagram.isEmpty &&
        twitter.isEmpty &&
        website.isEmpty &&
        wikipedia.isEmpty &&
        youtube.isEmpty;
  }

  factory Urls.empty() {
    return Urls(
      behance: '',
      bitbucket: '',
      dribbble: '',
      facebook: '',
      github: '',
      gitlab: '',
      image: '',
      instagram: '',
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

    return Urls(
      behance: data['behance'] ?? '',
      dribbble: data['dribbble'] ?? '',
      facebook: data['facebook'] ?? '',
      github: data['github'] ?? '',
      gitlab: data['gitlab'] ?? '',
      image: data['image'] ?? '',
      instagram: data['instagram'] ?? '',
      twitter: data['twitter'] ?? '',
      website: data['website'] ?? '',
      wikipedia: data['wikipedia'] ?? '',
      youtube: data['youtube'] ?? '',
    );
  }
}
