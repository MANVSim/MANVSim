import 'dart:math';

import 'package:flutter/material.dart';
import 'package:manvsim/utils/custom_transformation_controller.dart';

class MapControls extends StatelessWidget {
  final CustomTransformationController transformationController;
  final VoidCallback onUp;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onStop;

  const MapControls(
      {super.key,
      required this.transformationController,
      required this.onUp,
      required this.onLeft,
      required this.onRight,
      required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(children: [
        IconButton(
            onPressed: () => transformationController.tilt(-pi / 12),
            icon: const Icon(Icons.arrow_drop_down)),
        IconButton(
            onPressed: () => transformationController.tilt(pi / 12),
            icon: const Icon(Icons.arrow_drop_up)),
      ]),
      Column(children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              onPressed: () => transformationController.rotate(-pi / 12),
              icon: const Icon(Icons.rotate_left)),
          IconButton(onPressed: onUp, icon: const Icon(Icons.arrow_circle_up)),
          IconButton(
              onPressed: () => transformationController.rotate(pi / 12),
              icon: const Icon(Icons.rotate_right)),
        ]),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: onLeft,
                icon: const Icon(Icons.arrow_circle_left_outlined)),
            IconButton(onPressed: onStop, icon: const Icon(Icons.stop_circle)),
            IconButton(
                onPressed: onRight,
                icon: const Icon(Icons.arrow_circle_right_outlined)),
          ],
        )
      ]),
      Column(children: [
        IconButton(
            onPressed: () => transformationController.scale(2),
            icon: const Icon(Icons.zoom_in)),
        IconButton(
            onPressed: () => transformationController.scale(0.5),
            icon: const Icon(Icons.zoom_out)),
      ])
    ]);
  }
}
