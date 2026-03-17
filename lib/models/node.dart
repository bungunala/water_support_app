class Node {
  final int id;
  final Map<String, dynamic> text;
  final bool isFinal;
  final List<Option> options;

  Node({
    required this.id,
    required this.text,
    required this.isFinal,
    required this.options,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      id: json['id'],
      text: json['text'],
      isFinal: json['is_final'],
      options: (json['options'] as List)
          .map((opt) => Option.fromJson(opt))
          .toList(),
    );
  }
}

class Option {
  final Map<String, dynamic> text;
  final int nextId;

  Option({
    required this.text,
    required this.nextId,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      text: json['text'],
      nextId: json['next_id'],
    );
  }
}