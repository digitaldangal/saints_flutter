import 'package:flutter/material.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';

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
        _scrollController.offset + 10.0 > _appBarHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    _appBarHeight = widget.saint.has_icon ? 350.0 : 100.0;

    String markdown =
        html2md.convert(widget.saint.zhitie);

    final body1 = Theme.of(context).textTheme.body1.copyWith(fontSize: 18.0);
    final textTheme = Theme.of(context).textTheme.copyWith(body1: body1);
    final theme = Theme.of(context).copyWith(textTheme:textTheme);


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
          delegate: new SliverChildListDelegate(<Widget>[
        Container(
            padding: EdgeInsets.all(10.0),
            child: MarkdownBody(
                data: markdown,
                styleSheet: MarkdownStyleSheet.fromTheme(theme),
            ))
      ]))
    ]));
  }
}
