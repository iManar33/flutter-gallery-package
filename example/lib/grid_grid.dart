import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';

class GridGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GridViewImages( numOfShowItems: 4,titleGallery: 'Gallery',),
      ),
    );
  }
}
