import 'package:flutter/material.dart';
import 'package:image_edit/page/EditPage.dart';

void main() => runApp(EditPage());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(), // This trailing comma ma
      bottomNavigationBar: new Container(
        height: 60,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _getNavItem("贴图", 1),
            _getNavItem("文字", 2),
            _getNavItem("涂鸦", 3),
            _getNavItem("裁剪", 4),
          ],
        ),
      ), // kes auto-formatting nicer for build methods.
    );
  }

  Widget _getBody() {
    return new Container(
      color: Colors.red,
    );
  }

  ///底部tab
  Widget _getNavItem(String name, int index) {
    return new Expanded(
      child: new Container(
        color: index % 2 == 0 ? Colors.grey : Colors.blueGrey,
        alignment: Alignment.center,
        child: new Column(
          children: <Widget>[
            new Icon(Icons.event),
            new Text(name),
          ],
        ),
      ),
    );
  }
}
