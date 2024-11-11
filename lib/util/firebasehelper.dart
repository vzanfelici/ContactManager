import 'package:firebase_database/firebase_database.dart';
import '../model/contact.dart';

class FirebaseHelper {
  final DatabaseReference _contactRef =
      FirebaseDatabase.instance.ref().child('contacts');

  Future<void> insertContact(Contact contact) async {
    await _contactRef.push().set(contact.toMap());
  }

  Future<void> updateContact(Contact contact) async {
    await _contactRef.child(contact.id!).set(contact.toMap());
  }

  Future<void> deleteContact(String id) async {
    await _contactRef.child(id).remove();
  }

  Future<List<Contact>> getContacts() async {
    DatabaseReference contactsRef =
        FirebaseDatabase.instance.ref().child('contacts');
    DataSnapshot snapshot = await contactsRef.get();

    List<Contact> contacts = [];

    if (snapshot.value != null) {
      Map<String, dynamic> contactsMap =
          Map<String, dynamic>.from(snapshot.value as Map);

      contactsMap.forEach((key, value) {
        var contactMap = Map<String, dynamic>.from(value as Map);
        var contact = Contact.fromMap(contactMap)..id = key;
        contacts.add(contact);
      });
    }

    return contacts;
  }
}
