import 'dart:math';

import 'package:flutter_riverpod/legacy.dart';

final userPositionProvider = StateProvider<Point<double>>((ref) => Point(0, 0));
//72 x 72 is the size of graphic
//if the position is in the outside of the edge, it will be moved to the edge
//economic cuestions x axis
//authority cuestions y axis
