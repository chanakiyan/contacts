import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class Alphabets extends StatefulWidget {
  @override
  _AlphabetsState createState() => _AlphabetsState();
}

class _AlphabetsState extends State<Alphabets> {
  String text = "Press to see alphabets";
  Map hashMap = new HashMap<String, List<String>>();

  void initState() {
    super.initState();
    mapvaluesalpha();
  }

  // ignore: deprecated_member_use
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

  void mapvaluesalpha() {
    int start = "A".codeUnitAt(0);
    int end = "Z".codeUnitAt(0);
    for (int i = 0; i < contacts.length; i++) {
      String initial = String.fromCharCode(contacts[i].codeUnitAt(0));
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
    hashMap.forEach((key, value) {print("key: $key "+"value: $value");});
    setState(() {
      text = hashMap.toString();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Alphabetical order"),
      ),
      body: Column(
        children: [
          new Container(
            height: 60,
            color: Colors.lightBlue,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              hashMap.keys.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Container(
            height: 60,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              hashMap.values.toString(),
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
