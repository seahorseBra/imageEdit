import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

///手绘板插件,后期需要采用双画布来解决内容过多导致界面渲染效率问题
class PaintWidget extends StatefulWidget {
  PaintState paintState;

  @override
  State<StatefulWidget> createState() {
    paintState = new PaintState();
    return paintState;
  }

  setPaintColor(Color color) {
    print(color);
    paintState.paintColor = color;
  }

  enablePaint(bool enable) {
    paintState.canPaint = enable;
  }

  revertStep() {
    paintState.reStep();
  }
}

class PaintState extends State<PaintWidget> {
  Color _paintColor = Colors.white;

  bool canPaint = true;

  ///缓存绘制数据
  List<Element> _cacheFrame = <Element>[];

  ///缓冲数据，
  List<Element> _tmpFrame = <Element>[];
  static const int tmpSize = 40;

  ///用来标记界面是否需要重绘
  int dirty = 0;
  int dirtyCache = 0;

  ///添加一个绘制元素
  void addElement(Element element) {
    if (element == null) {
      return;
    }
    setState(() {
      _tmpFrame.add(element);
//      if (_tmpFrame.length >= tmpSize) {
//        _cacheFrame.addAll(_tmpFrame.sublist(0, tmpSize ~/ 2));
//        changeCacheDirty();
//      }
      changeDirty();
    });
  }

  ///返回上一步元素
  void reStep() {
    if (_tmpFrame.length == 0) {
      return;
    }
    setState(() {
      _tmpFrame.removeLast();
      if (_tmpFrame.length == 0) {
        if (_cacheFrame.length > 0) {
          _tmpFrame.addAll(_cacheFrame.sublist(
              max(0, _cacheFrame.length - tmpSize), _cacheFrame.length - 1));
          changeCacheDirty();
        }
      }
      changeDirty();
    });
  }

  set paintColor(Color value) {
    _paintColor = value;
  }

  changeDirty() {
    dirty++;
    dirty = dirty % 2;
  }

  changeCacheDirty() {
    dirtyCache++;
    dirtyCache = dirtyCache % 2;
  }

  Offset offset;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanStart: (DragStartDetails details) {
        if (!canPaint) {
          return;
        }
        setState(() {
          RenderBox _object = context.findRenderObject();
          Offset _locationPoints =
              _object.localToGlobal(details.globalPosition);
          offset = _locationPoints;
          PaintLine paintLine = new PaintLine(color: _paintColor);
          paintLine.moveTo(_locationPoints.dx, _locationPoints.dy);
          addElement(paintLine);
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        if (!canPaint) {
          return;
        }
        RenderBox _object = context.findRenderObject();
        Offset _locationPoints = _object.localToGlobal(details.globalPosition);
        ///这儿是判断是否是同一根手指。
        double dis = (offset + details.delta - _locationPoints).distanceSquared;
        if (dis > 1) {
          return;
        }
        offset = _locationPoints;
        setState(() {
          Element last = _tmpFrame.last;
          if (last is PaintLine) {
            last.lineTo(_locationPoints.dx, _locationPoints.dy);
          }
          changeDirty();
        });
      },
      onPanEnd: (DragEndDetails details) {},
      child: new Stack(
        children: <Widget>[
//          new CustomPaint(
//            painter: new PaintPan(_cacheFrame, dirtyCache, key: "cache"),
//            size: Size.infinite,
//          ),
          new CustomPaint(
            painter: new PaintPan(_tmpFrame, dirty, key: "tmp"),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }
}

class Element {
  Color color;
  double strokeWidth;
}

///线条元素
class PaintLine extends Path with Element {
  PaintLine({Color color = Colors.white, double strokeWidth = 5.0}) {
    this.color = color;
    this.strokeWidth = strokeWidth;
  }
}

///界面绘制数据
class PaintData {}

class PaintPan extends CustomPainter {
  List<Element> _cacheFrame = <Element>[];
  int dirty = -1;
  Paint _paint;
  String key;

  PaintPan(this._cacheFrame, this.dirty, {this.key}) {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
//    print("paint:$key:${_cacheFrame.length}");
    for (int i = 0; i < _cacheFrame.length; i++) {
      Element element = _cacheFrame[i];
      _paint
        ..color = element.color
        ..strokeWidth = element.strokeWidth;
      if (element is PaintLine) {
        canvas.drawPath(element, _paint);
      }
    }
  }

  @override
  bool shouldRepaint(PaintPan oldDelegate) {
    if (oldDelegate != this) {
      return true;
    }
    if (oldDelegate.dirty != dirty) {
      return true;
    }
    return false;
  }
}
