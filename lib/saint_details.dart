import 'package:flutter/material.dart';

import 'db.dart';

class SaintDetail extends StatefulWidget {
  Saint saint;
  SaintDetail(this.saint);

  @override
  _SaintDetailState createState() => new _SaintDetailState();
}

class _SaintDetailState extends State<SaintDetail> {
  ScrollController _scrollController;
  double _appBarHeight = 350.0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > _appBarHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    _appBarHeight = widget.saint.has_icon ? 350.0 : 100.0;

    return new Scaffold(
        body: CustomScrollView(controller: _scrollController, slivers: <Widget>[
      new SliverAppBar(
          expandedHeight: _appBarHeight,
          pinned: true,
          title: _showTitle ? Text(widget.saint.name) : null,
          flexibleSpace: _showTitle
              ? null
              : FlexibleSpaceBar(
                  title: null,
                  background: Container(
                    padding:
                        EdgeInsets.fromLTRB(10.0, kToolbarHeight, 10.0, 0.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          widget.saint.has_icon
                              ? Image.network(
                                  "https://s3.amazonaws.com/from-alexey/saints-icons/${widget.saint.id}.jpg",
                                  height: 250.0)
                              : Container(),
                          Expanded(
                              child: Center(
                                  child: Text(widget.saint.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white))))
                        ]),
                  ))),
      SliverList(
          delegate:
              new SliverChildListDelegate(<Widget>[Text(widget.saint.zhitie)]))
    ]));
  }
}
