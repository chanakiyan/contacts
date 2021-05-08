import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsTestPage extends StatefulWidget {
  @override
  _ContactsTestPageState createState() => _ContactsTestPageState();
}

class _ContactsTestPageState extends State<ContactsTestPage> {
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
    if (await Permission.contacts.request().isGranted) {
      getContacts();
    }
  }

  filterContacts() {
    List<Contact> contacts = [];
    contacts.addAll(_contacts);
    if (searchingController.text.isNotEmpty) {
      contacts.retainWhere((contact) {
        String searchTerm = searchingController.text.toLowerCase();
        String contactName = contact.displayName;
        print(contact.displayName);
        return contactName != null
            ? contactName.toLowerCase().contains(searchTerm)
            : false;
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
          ? CustomScrollView(
              slivers: [
                SliverStickyHeader(
                    header: Header(index: 'A'),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        Contact contact = isSearching == true
                            ? contactsFiltered.elementAt(index)
                            : _contacts.elementAt(index);
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 18),
                          leading: (contact.avatar != null &&
                                  contact.avatar.isNotEmpty)
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(contact.avatar),
                                )
                              : CircleAvatar(
                                  child: Text(contact.initials()),
                                  backgroundColor:
                                      Theme.of(context).accentColor,
                                ),
                          title: Text(contact.displayName ?? ''),
                          subtitle: Text((contact.phones.length > 0)
                              ? "${contact.phones.elementAt(0).value}"
                              : " "),
                          //This can be further expanded to showing contacts detail
                          // onPressed().
                        );
                      }),
                    )),
              ],
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    this.index,
    this.color = Colors.lightBlue,
  }) : super(key: key);

  final String index;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: Text(
        index,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
