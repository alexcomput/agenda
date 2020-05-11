import 'dart:async';
import 'dart:io';

import 'package:agenda/helps/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final  _nameController= TextEditingController();
  final _phoneController = new MaskedTextController(mask: '(00)*0000 0000');
  final _emailController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _useEdited = false;
  Contact _editedContact;

  @override
  void initState() {
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage('images/person.png'),
                    fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  _showwOptionCamera(context);
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _useEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _useEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _useEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_useEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações? "),
              content: Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });

      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _showwOptionCamera(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FlatButton(
                            child: Text(
                              "Tirar Foto",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 20.0),
                            ),
                            onPressed: () {
                              ImagePicker.pickImage(source: ImageSource.camera)
                                  .then((file) {
                                if (file == null)
                                  return;
                                else
                                  setState(() {
                                    _editedContact.img = file.path;
                                    _useEdited = true;
                                    Navigator.pop(context);
                                  });
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FlatButton(
                            child: Text(
                              "Galeria",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 20.0),
                            ),
                            onPressed: () {
                              ImagePicker.pickImage(source: ImageSource.gallery)
                                  .then((file) {
                                if (file == null)
                                  return;
                                else
                                  setState(() {
                                    _editedContact.img = file.path;
                                    _useEdited = true;
                                    Navigator.pop(context);
                                  });
                              });
                            },
                          ),
                        ),
                      ],
                    ));
              });
        });
  }
}
