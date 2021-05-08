import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:permission_handler/permission_handler.dart';

Map<String, List> _elements = {
  'Team A': ['Klay Lewis', 'Ehsan Woodard', 'River Bains'],
  'Team B': ['Toyah Downs', 'Tyla Kane'],
  'Team C': ['Marcus Romero', 'Farrah Parkes', 'Fay Lawson', 'Asif Mckay'],
  'Team D': [
    'Casey Zuniga',
    'Ayisha Burn',
    'Josie Hayden',
    'Kenan Walls',
    'Mario Powers'
  ],
  'Team Q': ['Toyah Downs', 'Tyla Kane', 'Toyah Downs'],
};

class GroupListPlug extends StatefulWidget {
  @override
  _GroupListPlugState createState() => _GroupListPlugState();
}

class _GroupListPlugState extends State<GroupListPlug> {
  Iterable<Contact> _contacts;
  Iterable<Contact> contactsFiltered;
  TextEditingController searchingController = new TextEditingController();
  // ignore: deprecated_member_use
  List<String> headerList =new List();
  Map hashMap = new HashMap<String, List<Contact>>();
  LinkedHashMap resMap = new LinkedHashMap();

  int headerCount;

  String initial;

  /* List<String> contacts = [
    "Abinav",
    "jadav",
    "Olivia",
    "Noah",
    "Jackson",
    "Aiden",
    "Muhammad",
    "Leo",
    "Charlie",
    "Emily",
    "Aria"
  ];*/

  void initState() {
    super.initState();
    getPermissions();
    hashMap.clear();
    searchingController.addListener(() {
      filterContacts();
    });
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getContacts();
    }
  }

  filterContacts() {
    List<Contact> contacts = [];
    contacts.addAll(_contacts);
    if (searchingController.text.isNotEmpty) {
      contacts.retainWhere((contact)
      {
        String
        searchTerm = searchingController.text.toLowerCase();
        String contactName=contact.displayName;
        print(contact.displayName);
        return contactName!=null?contactName.toLowerCase().contains(searchTerm):false;
      });

      setState(() {
        contactsFiltered = contacts;
      });
    }
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();

    setState(() {
      _contacts = contacts;
    });
    mapvaluesalpha();
  }

  void mapvaluesalpha() {
   /* int start = "A".codeUnitAt(0);
    int end = "Z".codeUnitAt(0);*/
    for (int i = 0; i < _contacts.length; i++) {
      // String header = String.fromCharCode(start);
      if (_contacts.elementAt(i).displayName != null) {
        initial =
            _contacts.elementAt(i).displayName.substring(0, 1).toUpperCase();

        headerList.add(initial);
        /* print(hashMap);
        hashMap.forEach((key, value) {
          print("key: $key " + "value:" + value.displa);
          print("Number of values in $key ");
        });
        headerCount = hashMap.keys.length;
        print("Number of Headers: $headerCount");*/
      }
    }
    // print(headerList.toString());
    headerList = headerList.toSet().toList();
    // print(headerList.toString());
    headerList.sort((a, b) {
      return a.toString().compareTo(b.toString());
    });
    // print(headerList.toString());
    for(int i=0;i<headerList.length;i++){
      if (hashMap.containsKey(headerList[i])) {
        /* List<Contact> temp = hashMap[initial];
          temp.add(_contacts.elementAt(i));*/
      } else {
        // ignore: deprecated_member_use
        /*List<Contact> temp = new List();
        temp.add(_contacts.firstWhere((element) =>
        element.displayName.substring(0, 1).toUpperCase() == initial));*/

        List<Contact> searchResults = _contacts
            .where((Contact item) =>
            item.displayName.toString().toUpperCase().startsWith(headerList[i]))
            .toList();
        hashMap.putIfAbsent(headerList[i], () => searchResults);
      }
    }
    // print(hashMap);

      /*List mapKeys = hashMap.keys.toList(growable : false);
      mapKeys.sort((k1, k2) => hashMap[k1].length - hashMap[k2].length);*/

      headerList.forEach((k1) { resMap[k1] = hashMap[k1] ; }) ;
    print(resMap.keys);


    /*for (start; start <= end; start++) {
      String alphabet = String.fromCharCode(start);
      alphabets.add(alphabet);
      */
    /*for (int i = 0; i < contacts.length; i++) {
        String initial = String.fromCharCode(contacts[i].codeUnitAt(0));
        print("Initial of " + contacts[i] + " is " + initial);
        if (contacts[i].startsWith(alphabet)) {

        }
      }*/
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchingController.text.isNotEmpty;
    return MaterialApp(
      title: 'Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contacts'),
        ),floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          ContactsService.openContactForm();
        },
      ),

        body: _contacts != null
            ? Container(
          padding: EdgeInsets.all(20),
              child: Column(
                children: [/*Container(
                  child: TextField(
                    controller: searchingController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: new OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Theme
                            .of(context)
                            .primaryColor),
                      ),
                      prefixIcon: Icon(Icons.search, color: Theme
                          .of(context)
                          .primaryColor,),
                    ),
                  ),
                )*/
                  Expanded(
                    child: Scrollbar(
                      child: GroupListView(
                          sectionsCount: isSearching==true?0 :resMap.keys.toList().length,
                          countOfItemInSection: (int section) {
                            return isSearching==true?contactsFiltered.length:resMap.values.toList()[section].length;
                          },
                          itemBuilder:  resMap.values.toList().isNotEmpty?_itemBuilder:null,
                          groupHeaderBuilder: (BuildContext context, int section) {
                            return Container(color: Colors.blue[100],
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical:5),
                                child: Text(
                                  resMap.keys.toList()[section],
                                  style:
                                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(height: 10),
                          sectionSeparatorBuilder: (context, section) =>
                              SizedBox(height: 10),
                        ),
                    ),
                  ),
                ],
              ),
            )
            : Center(child: const CircularProgressIndicator()),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, IndexPath index) {
    Contact user =
    resMap.values.toList()[index.section][index.index];
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18,vertical: 2),
      leading: (user.avatar != null &&
          user.avatar.isNotEmpty)
          ? CircleAvatar(
        backgroundImage:
        MemoryImage(user.avatar),
      )
          : CircleAvatar(
        child: Text(user.initials()),
        backgroundColor:
        Theme
            .of(context)
            .accentColor,
      ),
      title: Text(
        user.displayName.toString(),
        //hashMap.values.toList()[index.section][index.index].toString(),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      subtitle: Text((user.phones.length > 0)
          ? "${user.phones
          .elementAt(0)
          .value}"
          : " "),
    );
  }

  String _getInitials(String user) {
    var buffer = StringBuffer();
    var split = user.split(" ");
    for (var s in split) buffer.write(s[0]);

    return buffer.toString().substring(0, split.length);
  }
}
