import 'package:flutter/cupertino.dart';
import 'package:image_edit/paint/paintWidget.dart';

abstract class LayerWidget extends StatefulWidget {}

///图层基类
abstract class LayerAbstractState extends State {
  Matrix4 layerMatrix;

  ///must be between 0.0 and 1.0
  double scale = 1.0;

  ///must be between 0.0 and 360.0
  double rotate = 0.0;

  ///偏移
  Offset translate = Offset.zero;

  ///must be between 0.0 and 1.0
  double alpha = 1.0;

  Widget layerWidget;

  @override
  void initState() {
    super.initState();
    layerMatrix = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    layerMatrix
      ..scale(scale, scale, 1.0)
      ..rotateZ(rotate)
      ..translate(translate.dx, translate.dy, 0.0);
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleUpdate: (ScaleUpdateDetails value) {
        print(value);
        setState(() {
          scale = value.scale;
          rotate = value.rotation;
        });
      },
      child: new Container(
        transform: layerMatrix,
        child: new Opacity(
          opacity: alpha,
          child: layerWidget = buildLayer(context),
        ),
      ),
    );
  }

  Widget buildLayer(BuildContext context);
}

abstract class GestureScaleLayer extends LayerAbstractState {}

class PaintLayerWidget extends LayerWidget {
  PaintLayerState state;

  @override
  State<StatefulWidget> createState() {
    state = PaintLayerState();
    return state;
  }

  setPaintColor(Color color) {
    (state.layerWidget as PaintWidget).setPaintColor(color);
  }

  enablePaint(bool enable) {
    (state.layerWidget as PaintWidget).enablePaint(enable);
  }

  revertStep() {
    (state.layerWidget as PaintWidget).revertStep();
  }
}

class PaintLayerState extends GestureScaleLayer {
  @override
  PaintWidget buildLayer(BuildContext context) {
    return new PaintWidget();
  }
}

class ImageLayer extends LayerWidget{
  @override
  State<StatefulWidget> createState() {
    return null;
  }

}
