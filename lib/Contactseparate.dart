import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class separateContacts extends StatefulWidget {
  @override
  _separateContactsState createState() => _separateContactsState();
}

class _separateContactsState extends State<separateContacts> {
  String text = "Press to see alphabets";
  Iterable<Contact> _contacts;

  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts
        .request()
        .isGranted) {
      getContacts();
    }
  }


  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();


    setState(() {
      _contacts = contacts;
    });
  }

  Map hashMap = new HashMap<String, List<Contact>>();

  void alphabetLoop() {
    List<Contact> contacts = _contacts;
    int start = "A".codeUnitAt(0);
    int end = "Z".codeUnitAt(0);
    for(int i=0;i<contacts.length;i++){
      String initial=contacts.elementAt(i).toString();
      if(hashMap.containsKey(initial)){
        List<Contact> temp=hashMap[initial];
        temp.add(contacts.elementAt(i));
      }else
      {
        // ignore: deprecated_member_use
        List<Contact> temp=new List();
        temp.add(contacts.elementAt(i));
        hashMap.putIfAbsent(initial, () => temp);
      }
    }
    // print(hashMap);
    print(contacts.elementAt(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Alphabetical order"),
      ),
      body: new Container(
        margin: new EdgeInsets.all(15.0),
        child: Column(
          children: [
            new Container(
              child: Text(text),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
                child: Text(text = "Display"),
                onPressed: () {
                  // alphabets.clear();
                  hashMap.clear();
                  alphabetLoop();
                })
          ],
        ),
      ),
    );
  }
}
