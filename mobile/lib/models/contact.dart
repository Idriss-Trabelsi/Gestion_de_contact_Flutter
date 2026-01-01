// lib/models/contact.dart
class Contact {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String ownerUsername;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.ownerUsername,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      ownerUsername: json['owner_username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}