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
  Map<String, String> profilesMap = Map<String, String>();

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
    this.map,
    this.other = '',
    this.profilesMap,
    this.tiktok = '',
    this.twitch = '',
    this.twitter = '',
    this.website = '',
    this.wikipedia = '',
    this.youtube = '',
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
      profilesMap: Map(),
      map: Map(),
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
    final profilesMap = Map<String, String>();

    data.forEach((key, value) {
      dataMap[key] = value;

      if (key != "image") {
        profilesMap[key] = value;
      }
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
      profilesMap: profilesMap,
      other: data['other'] ?? '',
      tiktok: data['tiktok'] ?? '',
      twitch: data['twitch'] ?? '',
      twitter: data['twitter'] ?? '',
      website: data['website'] ?? '',
      wikipedia: data['wikipedia'] ?? '',
      youtube: data['youtube'] ?? '',
    );
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> data = Map();

    data['artbooking'] = artbooking;
    data['behance'] = behance;
    data['dribbble'] = dribbble;
    data['facebook'] = facebook;
    data['github'] = github;
    data['gitlab'] = gitlab;
    data['image'] = image;
    data['instagram'] = instagram;
    data['linkedin'] = linkedin;
    data['other'] = other;
    data['tiktok'] = tiktok;
    data['twitch'] = twitch;
    data['twitter'] = twitter;
    data['website'] = website;
    data['wikipedia'] = wikipedia;
    data['youtube'] = youtube;

    return data;
  }

  void copyFrom(Urls copy) {
    artbooking = copy.artbooking;
    behance = copy.behance;
    dribbble = copy.dribbble;
    facebook = copy.facebook;
    github = copy.github;
    gitlab = copy.gitlab;
    instagram = copy.instagram;
    linkedin = copy.linkedin;
    other = copy.other;
    tiktok = copy.tiktok;
    twitch = copy.twitch;
    twitter = copy.twitter;
    website = copy.website;
    wikipedia = copy.wikipedia;
    youtube = copy.youtube;
  }

  void setUrl(String key, String value) {
    switch (key) {
      case "artbooking":
        artbooking = value;
        break;
      case "behance":
        behance = value;
        break;
      case "dribbble":
        dribbble = value;
        break;
      case "facebook":
        facebook = value;
        break;
      case "github":
        github = value;
        break;
      case "gitlab":
        gitlab = value;
        break;
      case "instagram":
        instagram = value;
        break;
      case "linkedin":
        linkedin = value;
        break;
      case "other":
        other = value;
        break;
      case "tiktok":
        tiktok = value;
        break;
      case "twitch":
        twitch = value;
        break;
      case "twitter":
        twitter = value;
        break;
      case "website":
        website = value;
        break;
      case "wikipedia":
        wikipedia = value;
        break;
      case "youtube":
        youtube = value;
        break;
      default:
    }
  }
}
