class Contact {
  String? id;
  String name;
  String phone;
  String email;

  Contact(this.name, this.phone, this.email);
  Contact.withId(this.id, this.name, this.phone, this.email);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      map['name'] ?? '',
      map['phone'] ?? '',
      map['email'] ?? '',
    )..id = map['id'] as String?;
  }
}
