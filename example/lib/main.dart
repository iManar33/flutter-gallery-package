import 'package:flutter/material.dart';
import 'grid_grid.dart';
void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,

  home: Directionality( // add this
    textDirection: TextDirection.rtl, // set this property
    child: GridGrid(),
  ),
));

