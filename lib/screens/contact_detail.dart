import 'package:flutter/material.dart';
import '../model/contact.dart';
import '../util/firebasehelper.dart';

class ContactDetail extends StatefulWidget {
  final Contact? contact;
  const ContactDetail({super.key, this.contact});

  @override
  State<StatefulWidget> createState() => ContactDetailState();
}

class ContactDetailState extends State<ContactDetail> {
  FirebaseHelper helper = FirebaseHelper();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      phoneController.text = widget.contact!.phone;
      emailController.text = widget.contact!.email;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.contact == null ? 'Adicionar contato' : 'Editar contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(labelText: 'Nome')),
            TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Celular')),
            TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email')),
            ElevatedButton(
              child: widget.contact != null
                  ? const Text('Atualizar')
                  : const Text('Adicionar'),
              onPressed: () async {
                var contact = Contact(nameController.text, phoneController.text,
                    emailController.text);
                if (widget.contact == null) {
                  await helper.insertContact(contact);
                } else {
                  contact.id = widget.contact!.id;
                  await helper.updateContact(contact);
                }
                Navigator.pop(context, true);
              },
            ),
            if (widget.contact != null)
              ElevatedButton(
                child: const Text('Excluir'),
                onPressed: () {
                  _confirmDelete(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Apagar contato"),
          content: const Text("Tem certeza que deseja apagar esse contato?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Deletar"),
              onPressed: () async {
                await helper.deleteContact(widget.contact!.id!);
                Navigator.of(context).pop();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
