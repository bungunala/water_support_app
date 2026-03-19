class WaterSystem {
  final String id;
  final Map<String, String> title;
  final Map<String, String> subtitle;
  final String icon;
  final String image;
  final List<WaterSystem> children;

  WaterSystem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.image,
    required this.children,
  });

  bool get hasChildren => children.isNotEmpty;

  static Map<String, String> _mapFromJson(dynamic map) {
    if (map == null) return {'en': '', 'es': ''};
    return Map<String, String>.from(map);
  }

  static List<WaterSystem> _parseChildren(dynamic children) {
    if (children == null) return [];
    if (children is! List) return [];
    return children
        .map((e) => WaterSystem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  factory WaterSystem.fromJson(Map<String, dynamic> json) {
    return WaterSystem(
      id: json['id'] as String? ?? '',
      title: _mapFromJson(json['title']),
      subtitle: _mapFromJson(json['subtitle']),
      icon: json['icon'] as String? ?? '',
      image: json['image'] as String? ?? '',
      children: _parseChildren(json['children']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'image': image,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}
