import 'package:hive/hive.dart';
import '../models/contact.dart';

class ContactHive {
  static const String _boxName = 'contacts';
  static Box<Contact>? _box;

  /// Initialize Hive box for contacts
  static Future<void> init() async {
    Hive.registerAdapter(ContactAdapter());
    _box = await Hive.openBox<Contact>(_boxName);
  }

  /// Save or update a contact
  static Future<void> saveContact(Contact contact) async {
    await _box?.put(contact.id, contact);
  }

  /// Get a contact by ID
  static Contact? getContact(String id) {
    return _box?.get(id);
  }

  /// Get all contacts as a list
  static Future<List<Contact>> getAllContacts() async {
    return _box?.values.toList() ?? [];
  }

  /// Delete a contact by ID
  static Future<void> deleteContact(String id) async {
    await _box?.delete(id);
  }

  /// Delete all contacts
  static Future<void> clearAll() async {
    await _box?.clear();
  }

  /// Check if a contact exists by ID
  static bool contactExists(String id) {
    return _box?.containsKey(id) ?? false;
  }

  /// Get total number of contacts
  static int getContactsCount() {
    return _box?.length ?? 0;
  }

  /// Search contacts by name or phone
  static Future<List<Contact>> searchContacts(String query) async {
    if (query.isEmpty) return getAllContacts();
    
    final allContacts = await getAllContacts();
    final lowerQuery = query.toLowerCase();
    
    return allContacts.where((contact) {
      return contact.name.toLowerCase().contains(lowerQuery) ||
             contact.phone.contains(query) ||
             contact.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}