import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        children: <Widget>[
          new Container(
            color: Colors.white,
            child: new Image.asset("images/bg.jpg"),
          ),
          _showGesture(),
        ],
      ),
    );
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
              onTap: () => revert(),
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
        setState(() {
          addLine(color);
        });
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

  List<Line> _lines = <Line>[];
  Line _lastLines;

  Widget _showGesture() {
    if (_lastLines == null) {
      _lastLines = new Line(Colors.white);
      _lines.add(_lastLines);
    }
    if (_editState == 3) {
      return new GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          setState(() {
            RenderBox _object = context.findRenderObject();
            Offset _locationPoints =
                _object.localToGlobal(details.globalPosition);
            _lines = new List.from(_lines);
            _lastLines.points..add(_locationPoints);
          });
        },
        onPanEnd: (DragEndDetails details) {
          setState(() {
            _lastLines.points.add(null);
          });
        },
        child: new CustomPaint(
          painter: new PaintPan(_lines),
          size: Size.infinite,
        ),
      );
    } else {
      return new CustomPaint(
        painter: new PaintPan(_lines),
        size: Size.infinite,
      );
    }
  }

  void revert() {
    bool success = _lastLines.reStep();
    if (!success) {
      if (_lines.length == 1) {
        return;
      }
      for (int i = _lines.length - 2; i >= 0; i--) {
        Line line = _lines[i];
        bool reStep = line.reStep();
        if (reStep) {
          break;
        }
        _lines.remove(line);
      }
    }
    setState(() {
      _lines = new List.from(_lines);
    });
  }

  void addLine(Color color) {
    _lastLines = new Line(color);
    _lines.add(_lastLines);
  }
}

class Line {
  List<Offset> points = <Offset>[];
  Color color;
  double strokeWidth;

  Line(this.color, {this.strokeWidth = 5.0});

  bool reStep() {
    if (points.length == 0) {
      return false;
    }
    points.removeLast();
    for (int i = points.length - 1; i >= 0; i--) {
      Offset offset = points[i];
      if (offset == null) {
        break;
      }
      points.remove(offset);
    }
    return true;
  }
}

class PaintPan extends CustomPainter {
  List<Line> lines = <Line>[];

  Paint _paint;

  PaintPan(this.lines) {
    _paint = Paint()
      ..strokeCap = StrokeCap.square
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < lines.length; i++) {
      Line line = lines[i];
      _paint
        ..color = line.color
        ..strokeWidth = line.strokeWidth;
      List<Offset> path = line.points;
      if (path.length > 1) {
        for (int i = 0; i < path.length - 1; i++) {
          if (path[i] != null && path[i + 1] != null) {
            canvas.drawLine(path[i], path[i + 1], _paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(PaintPan oldDelegate) {
    if (oldDelegate.lines != lines) {
      return true;
    }
    if (oldDelegate.lines.length != lines.length) {
      return true;
    }
    for (int i = 0; i < lines.length; i++) {
      if (oldDelegate.lines[i].points != lines[i].points) {
        return true;
      }
      if (oldDelegate.lines[i].color != lines[i].color) {
        return true;
      }
    }
    return false;
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
