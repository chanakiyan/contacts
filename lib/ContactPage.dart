import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';


class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts;
  Iterable<Contact> contactsFiltered;
  TextEditingController searchingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getPermissions();
    searchingController.addListener(() {
      filterContacts();
    });
  }

  getPermissions() async {
    if (await Permission.contacts
        .request()
        .isGranted) {
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
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchingController.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: (Text('Contacts')),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          ContactsService.openContactForm();
        },
      ),
      body: _contacts != null
      //Build a list view of all contacts, displaying their avatar and
      // display name
          ? Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
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
            ),
            Expanded(
              child: Scrollbar(

                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: isSearching==true?contactsFiltered.length:_contacts.length,
                  itemBuilder: (BuildContext context, int index) {
                  Contact contact = isSearching==true?contactsFiltered.elementAt(index):_contacts.elementAt(index);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 18),
                      leading: (contact.avatar != null &&
                          contact.avatar.isNotEmpty)
                          ? CircleAvatar(
                        backgroundImage:
                        MemoryImage(contact.avatar),
                      )
                          : CircleAvatar(
                        child: Text(contact.initials()),
                        backgroundColor:
                        Theme
                            .of(context)
                            .accentColor,
                      ),
                      title: Text(contact.displayName ?? ''),
                      subtitle: Text((contact.phones.length > 0)
                          ? "${contact.phones
                          .elementAt(0)
                          .value}"
                          : " "),
                      // subtitle: Text((contact.phones.elementAt(0).value).isEmpty?'':contact.phones.elementAt(0).value),
                      //This can be further expanded to showing contacts detail
                      // onPressed().
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}
