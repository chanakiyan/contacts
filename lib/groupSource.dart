import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class GroupListSource extends StatefulWidget {
  @override
  _GroupListSourceState createState() => _GroupListSourceState();
}

class _GroupListSourceState extends State<GroupListSource> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListExample()
    );
  }

}

class ListExample extends StatelessWidget {
  const ListExample({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'List Example',
      slivers: [
        _StickyHeaderList(index: 'A'),
        _StickyHeaderList(index: 'B'),
        _StickyHeaderList(index: 'C'),
        _StickyHeaderList(index: 'D'),
      ],
    );
  }
}

class _StickyHeaderList extends StatelessWidget {
  const _StickyHeaderList({
    Key key,
    this.index,
  }) : super(key: key);

  final String index;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader(
      header: Header(index: index),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, i) =>
              ListTile(
                leading: CircleAvatar(
                  child: Text('$index'),
                ),
                title: Text('List tile #$i'),
              ),
          childCount: 6,
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
        title ?? 'Header #$index',
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