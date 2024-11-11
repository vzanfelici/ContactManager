import 'package:flutter/material.dart';
import '../model/contact.dart';
import '../util/firebasehelper.dart';
import 'contact_detail.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<StatefulWidget> createState() => ContactListState();
}

class ContactListState extends State<ContactList> {
  FirebaseHelper helper = FirebaseHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final contactList = await helper.getContacts();
    setState(() {
      contacts = contactList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sua lista de Contatos'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index].name),
            subtitle: Text(contacts[index].phone),
            onTap: () async {
              bool? result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return ContactDetail(contact: contacts[index]);
              }));

              if (result == true) {
                getData();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return const ContactDetail();
          }));

          if (result == true) {
            getData();
          }
        },
        tooltip: "Novo",
        child: const Icon(Icons.add),
      ),
    );
  }
}
