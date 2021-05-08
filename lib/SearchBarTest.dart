import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'ListView with Search'),
    );
  }
}

class myclass {
  String word1;
  String word2;

  myclass(this.word1, this.word2);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  // ignore: deprecated_member_use
  var items = List<String>();

  List<myclass> words = [
    myclass("Start", "Goood"),
    myclass("Go", "Bad"),
    myclass("Drive", "googles"),
    myclass("Sleep", "bark"),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    if (editingController.text.isEmpty) {
                      return ListTile(
                        title:
                        Text('${words[index].word1} ${words[index].word2}'),
                      );
                    } else if (words[index]
                        .word1
                        .toLowerCase()
                        .contains(editingController.text) ||
                        words[index]
                            .word2
                            .toLowerCase()
                            .contains(editingController.text)) {
                      return ListTile(
                        title:
                        Text('${words[index].word1} ${words[index].word2}'),
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}