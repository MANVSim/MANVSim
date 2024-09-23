import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:manvsim/utils/offset_ray.dart';
import 'package:vector_math/vector_math_64.dart';

class CustomTransformationController extends ChangeNotifier
    implements ValueListenable<Matrix4> {
  CustomTransformationController(this.focalPoint);

  double currentTilt = 0;
  double maxTilt = 1.5;

  double currentRotation = 0;

  double currentScale = 1;
  double minScale = 0.25;
  double maxScale = 2;

  Offset currentTranslation = Offset.zero;

  Matrix4 tiltMatrix = Matrix4.identity();
  Matrix4 rotationScaleMatrix = Matrix4.identity();
  Matrix4 translationMatrix = Matrix4.identity();

  Offset focalPoint;

  @override
  Matrix4 get value => tiltMatrix * (rotationScaleMatrix * translationMatrix);

  void rotate(double rotation) {
    currentRotation += rotation;
    final Offset focalPointScene = rotated(focalPoint);
    rotationScaleMatrix
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..rotateZ(-rotation)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
    notifyListeners();
  }

  void tilt(double tilt) {
    double newTilt = currentTilt + tilt;
    if (newTilt.abs() > maxTilt) return;
    final Offset focalPointScene = rotated(focalPoint);
    currentTilt = newTilt;
    tiltMatrix
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..rotateX(-tilt)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
    notifyListeners();
  }

  void scale(double scale) {
    double newScale = currentScale * scale;
    if (newScale < minScale || newScale > maxScale) return;
    final Offset focalPointScene = rotated(focalPoint);
    currentScale = newScale;
    rotationScaleMatrix
      ..translate(focalPointScene.dx, focalPointScene.dy)
      ..scale(scale)
      ..translate(-focalPointScene.dx, -focalPointScene.dy);
    notifyListeners();
  }

  void setTranslation(Offset translation) {
    currentTranslation = translation;
    translationMatrix = translationMatrix
      ..setTranslation(translation.toVector3());
    notifyListeners();
  }

  Offset toScene(Offset viewportPoint) {
    // On viewportPoint, perform the inverse transformation of the scene to get
    // where the point would be in the scene before the transformation.
    final Matrix4 inverseMatrix = Matrix4.inverted(value);
    return inverseMatrix.transform3(viewportPoint.toVector3()).toOffset();
  }

  Offset rotated(Offset viewportPoint) {
    Matrix4 inverseMatrix = Matrix4.inverted(tiltMatrix * rotationScaleMatrix);
    return inverseMatrix.transform3(viewportPoint.toVector3()).toOffset();
  }
}
