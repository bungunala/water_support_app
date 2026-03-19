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
      platform: json['platform'] as String? ?? '',
      url: json['url'] as String? ?? '',
      iconUrl: json['icon_url'] as String? ?? '',
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

class MainPageOption {
  final String id;
  final Map<String, String> title;
  final String icon;

  MainPageOption({
    required this.id,
    required this.title,
    required this.icon,
  });

  static Map<String, String> _mapFromJson(dynamic map) {
    if (map == null) return {'en': '', 'es': ''};
    return Map<String, String>.from(map);
  }

  factory MainPageOption.fromJson(Map<String, dynamic> json) {
    return MainPageOption(
      id: json['id'] as String? ?? '',
      title: _mapFromJson(json['title']),
      icon: json['icon'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
    };
  }
}

class MainPageContent {
  final String backgroundImage;
  final Map<String, String> title;
  final List<SocialLink> socialLinks;
  final List<MainPageOption> options;

  MainPageContent({
    required this.backgroundImage,
    required this.title,
    required this.socialLinks,
    required this.options,
  });

  static Map<String, String> _mapFromJson(dynamic map) {
    if (map == null) return {'en': '', 'es': ''};
    return Map<String, String>.from(map);
  }

  factory MainPageContent.fromJson(Map<String, dynamic> json) {
    return MainPageContent(
      backgroundImage: json['background_image'] as String? ?? '',
      title: _mapFromJson(json['title']),
      socialLinks: (json['social_links'] as List?)
              ?.map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      options: (json['options'] as List?)
              ?.map((e) => MainPageOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'background_image': backgroundImage,
      'title': title,
      'social_links': socialLinks.map((e) => e.toJson()).toList(),
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}
