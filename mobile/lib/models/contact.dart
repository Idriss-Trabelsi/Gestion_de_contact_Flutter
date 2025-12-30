class Contact {
  
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String address;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.address = '',
  });
}