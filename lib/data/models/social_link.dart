class SocialLink {
  final String platform;
  final String url;
  final String iconUrl;

  SocialLink({
    required this.platform,
    required this.url,
    required this.iconUrl,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform'] as String,
      url: json['url'] as String,
      iconUrl: json['icon_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'url': url,
      'icon_url': iconUrl,
    };
  }
}
