import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SizeService {

  static double maxWebAppWidth = 600;

  static double getScreenWidth(BuildContext context) {
    return kIsWeb
        ?  min(maxWebAppWidth, MediaQuery.of(context).size.width)
        : MediaQuery.of(context).size.width;
  }

}