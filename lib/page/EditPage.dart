import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_edit/paint/layer.dart';
import 'package:image_edit/paint/paintWidget.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Container(
        child: EditStateWidget(),
      ),
    );
  }
}

class EditStateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditState();
  }
}

class EditState extends State<EditStateWidget> {
  int _editState = 0;

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        _getBody(),
        new Align(
          child: BottomNavBar(_onSelect),
          alignment: Alignment.bottomCenter,
        )
      ],
    );
  }

  _onSelect(int index) {
    setState(() {
      _editState = index;
    });
  }

  Widget _getBody() {
    return new Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 60),
      color: Colors.grey,
      child: new Stack(
        children: <Widget>[
          _getCanvas(),
          new Align(
            alignment: Alignment.bottomCenter,
            child: _getEditPan(),
          )
        ],
      ),
    );
  }

  ///画布
  _getCanvas() {
    return new Center(
      child: new Stack(
        children: _showLayer(),
      ),
    );
  }

  Widget bgLayer;
  PaintLayerWidget paintLayer;

  ///显示图层
  _showLayer() {
    if (_editState == 1) {}
    if (_editState == 2) {}
    if (_editState == 3) {
      if (paintLayer == null) {
        paintLayer = new PaintLayerWidget();
      } else {
        paintLayer.enablePaint(true);
      }
    } else if (paintLayer != null) {
      paintLayer.enablePaint(false);
    }
    if (_editState == 4) {}
    if (bgLayer == null) {
      bgLayer = new Container(
        color: Colors.white,
        child: new Image.asset("images/bg.jpg"),
      );
    }
    List<Widget> layers = <Widget>[];

    layers.add(bgLayer);
    if (paintLayer != null) {
      layers.add(paintLayer);
    }
    return layers;
  }

  ///编辑选择框
  Widget _getEditPan() {
    if (_editState == 1) {
      return new Container(
        height: 80,
        color: Colors.blue,
      );
    } else if (_editState == 2) {
      return new Container(
        height: 80,
        color: Colors.yellow,
      );
    } else if (_editState == 3) {
      return new Container(
        height: 60,
        color: Colors.white,
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _getPaintColor(Colors.white),
                  _getPaintColor(Colors.black),
                  _getPaintColor(Colors.red),
                  _getPaintColor(Colors.green),
                  _getPaintColor(Colors.yellow),
                  _getPaintColor(Colors.blue),
                  _getPaintColor(Colors.purple),
                ],
              ),
            ),
            new GestureDetector(
              onTap: () => paintLayer.revertStep(),
              child: new Icon(
                Icons.reply,
                size: 60,
                color: Colors.red,
              ),
            )
          ],
        ),
      );
    } else if (_editState == 4) {
      return new Container(
        height: 80,
        color: Colors.deepOrange,
      );
    }
    return null;
  }

  Widget _getPaintColor(Color color) {
    return new GestureDetector(
      onTap: () {
        if (paintLayer != null) {
          paintLayer.setPaintColor(color);
        }
      },
      child: new Container(
          width: 40,
          margin: EdgeInsets.all(10),
          height: 40,
          decoration: new ShapeDecoration(
            color: color,
            shape: new RoundedRectangleBorder(
                side: new BorderSide(
                    color: Colors.grey, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(
                  Radius.circular(60),
                )),
          )),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BottomStatus(onItemClick);
  }

  OnItemClick onItemClick;

  BottomNavBar(this.onItemClick);
}

typedef OnItemClick = void Function(int index);

class BottomStatus extends State<BottomNavBar> {
  OnItemClick onItemClick;

  BottomStatus(this.onItemClick);

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
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
    );
  }

  int selectIndex = -1;

  void _onItemSelect(int index) {
    setState(() {
      if (selectIndex == index) {
        selectIndex = -1;
      } else {
        selectIndex = index;
      }
    });
    if (onItemClick != null) {
      onItemClick(index);
    }
  }

  final style = new TextStyle(
    fontSize: 14,
    color: Colors.grey,
    textBaseline: null,
    decoration: TextDecoration.none,
  );
  final styleSelect = new TextStyle(
    fontSize: 14,
    color: Colors.black,
    textBaseline: null,
    decoration: TextDecoration.none,
  );

  ///底部tab
  Widget _getNavItem(String name, int index) {
    return new Expanded(
      child: new GestureDetector(
        onTap: () => _onItemSelect(index),
        child: new Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(Icons.event),
              new Text(
                name,
                style: (selectIndex == index) ? styleSelect : style,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
