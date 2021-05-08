import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class GroupList extends StatefulWidget {
  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  Map hashMap = new HashMap<String, List<String>>();
  int headerCount;
  String initial;

  List<String> contacts = [
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
  ];

  void initState() {
    super.initState();
    hashMap.clear();
    mapvaluesalpha();
  }

  void mapvaluesalpha() {
    int start = "A".codeUnitAt(0);
    int end = "Z".codeUnitAt(0);
    for (int i = 0; i < contacts.length; i++) {
      String header = String.fromCharCode(start);
      initial = String.fromCharCode(contacts[i].codeUnitAt(0));
      if (hashMap.containsKey(initial)) {
        List<String> temp = hashMap[initial];
        temp.add(contacts[i]);
      } else {
        List<String> temp = new List();
        temp.add(contacts[i]);
        hashMap.putIfAbsent(initial, () => temp);
      }
    }
    print(hashMap);
    hashMap.forEach((key, value) {
      print("key: $key " + "value: $value");
      print("Number of values in $key ");
    });
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
    headerCount = hashMap.keys.length;
    print("Number of Headers: $headerCount");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScaffold(
        title: 'List Example',
        slivers: [
          for (var i = 1; i <= headerCount; i++)
            _StickyHeaderList(
              index: String.fromCharCode(
                contacts[i].codeUnitAt(0),
              ),
              displayName: hashMap[i].toString(),
            )
          /*hashMap.forEach((key, value) { _StickyHeaderList(
            index:key,
            displayName: value,
           itemCount: hashMap.values.length,
          );})*/
        ],
      ),
    );
  }
}

/*
class ListExample extends StatefulWidget {
  const ListExample({
    Key key,
  }) : super(key: key);

  @override
  _ListExampleState createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'List Example',
      slivers: [for (var i = 0; i <= 5; i++) _StickyHeaderList(index: "a")],
    );
  }
}
*/

class _StickyHeaderList extends StatelessWidget {
  const _StickyHeaderList({
    Key key,
    this.index,
    this.displayName,
    this.itemCount,
  }) : super(key: key);

  final String index;
  final String displayName;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Header(index: index),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) => ListTile(
            leading: CircleAvatar(
              child: Text('$index'),
            ),
            title: Text(displayName),
          ),
          childCount: itemCount,
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    this.index,
    this.title,
    this.color = Colors.lightBlue,
  }) : super(key: key);

  final String title;
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

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key key,
    @required this.title,
    @required this.slivers,
    this.reverse = false,
  }) : super(key: key);

  final String title;
  final List<Widget> slivers;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return DefaultStickyHeaderController(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: CustomScrollView(
          slivers: slivers,
          reverse: reverse,
        ),
      ),
    );
  }
}
