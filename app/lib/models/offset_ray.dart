import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

class OffsetRay {
  final Offset origin;

  final Offset direction;

  OffsetRay(this.origin, this.direction);

  /// Computes the intersection of [rect] and [this].
  /// Returns the nearest distance, the origin lies inside or outside the graph.
  double? intersectsWithRect(Rect rect) {
    final origin = Vector2(this.origin.dx, this.origin.dy);
    final direction = Vector2(this.direction.dx, this.direction.dy);
    final otherMin = Vector2(rect.left, rect.top);
    final otherMax = Vector2(rect.right, rect.bottom);

    var tNear = -double.maxFinite;
    var tFar = double.maxFinite;

    for (var i = 0; i < 2; ++i) {
      if (direction[i] == 0.0) {
        if (origin[i] < otherMin[i] || origin[i] > otherMax[i]) {
          return null;
        }
      } else {
        var t1 = (otherMin[i] - origin[i]) / direction[i];
        var t2 = (otherMax[i] - origin[i]) / direction[i];

        if (t1 > t2) {
          final temp = t1;
          t1 = t2;
          t2 = temp;
        }

        if (t1 > tNear) {
          tNear = t1;
        }

        if (t2 < tFar) {
          tFar = t2;
        }

        if (tNear > tFar) {
          return null;
        }
      }
    }
    if (tFar < 0) {
      return tFar;
    }

    return tNear;
  }

  Offset? intersectionWithRect(Rect rect) {
    switch (intersectsWithRect(rect)) {
      case null:
        return null;
      case double distance:
        return at(distance);
    }
  }

  Offset at(double distance) {
    return direction * distance + origin;
  }
}
