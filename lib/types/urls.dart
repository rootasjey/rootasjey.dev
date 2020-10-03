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
    this.behance    = '',
    this.bitbucket  = '',
    this.dribbble   = '',
    this.facebook   = '',
    this.github     = '',
    this.gitlab     = '',
    this.image      = '',
    this.instagram  = '',
    this.twitter    = '',
    this.website    = '',
    this.wikipedia  = '',
    this.youtube    = '',
  });

  bool areLinksEmpty() {
    return behance.isEmpty  &&
      dribbble.isEmpty      &&
      facebook.isEmpty      &&
      github.isEmpty        &&
      gitlab.isEmpty        &&
      instagram.isEmpty     &&
      twitter.isEmpty       &&
      website.isEmpty       &&
      wikipedia.isEmpty     &&
      youtube.isEmpty;
  }

  factory Urls.fromJSON(Map<String, dynamic> json) {
    return Urls(
      behance     : json['behance']     ?? '',
      dribbble    : json['dribbble']    ?? '',
      facebook    : json['facebook']    ?? '',
      github      : json['github']      ?? '',
      gitlab      : json['gitlab']      ?? '',
      image       : json['image']       ?? '',
      instagram   : json['instagram']   ?? '',
      twitter     : json['twitter']     ?? '',
      website     : json['website']     ?? '',
      wikipedia   : json['wikipedia']   ?? '',
      youtube     : json['youtube']     ?? '',
    );
  }
}