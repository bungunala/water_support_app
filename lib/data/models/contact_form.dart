class ContactForm {
  final String name;
  final String phone;
  final String email;
  final String message;

  ContactForm({
    required this.name,
    required this.phone,
    required this.email,
    required this.message,
  });

  factory ContactForm.fromJson(Map<String, dynamic> json) {
    return ContactForm(
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'message': message,
    };
  }

  bool get isValid {
    return name.isNotEmpty && email.contains('@') && message.isNotEmpty;
  }
}
