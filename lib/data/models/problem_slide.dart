class ProblemSlide {
  final int id;
  final Map<String, String> title;
  final Map<String, String> description;
  final String image;

  ProblemSlide({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  static Map<String, String> _mapFromJson(dynamic map) {
    if (map == null) return {'en': '', 'es': ''};
    return Map<String, String>.from(map);
  }

  factory ProblemSlide.fromJson(Map<String, dynamic> json) {
    return ProblemSlide(
      id: json['id'] as int? ?? 0,
      title: _mapFromJson(json['title']),
      description: _mapFromJson(json['description']),
      image: json['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
