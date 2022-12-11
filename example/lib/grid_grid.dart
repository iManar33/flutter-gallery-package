import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';

class GridGrid extends StatelessWidget {
  List<String> imageURLs = [
    "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
    "https://tahh3ccmtxa7trnk.s3.me-south-1.amazonaws.com/3ff5b5f1-6d92-46a3-ba58-7ad4df4defa5",
    "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
    // "https://tahh3ccmtxa7trnk.s3.me-south-1.amazonaws.com/3ff5b5f1-6d92-46a3-ba58-7ad4df4defa5",
    // "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
  ];

  List<String> ytURLs = [
    "https://www.youtube.com/watch?v=qPj50i3gkAo",
    "https://www.youtube.com/watch?v=R4jQemNpxn4",
    "https://www.youtube.com/watch?v=X-yIEMduRXk&list=RDX-yIEMduRXk&start_radio=1",
    "https://www.youtube.com/watch?v=qPj50i3gkAo",
    "https://www.youtube.com/watch?v=R4jQemNpxn4",
    "https://www.youtube.com/watch?v=R4jQemNpxn4",
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          body:
          ListView(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
child: GridViewImages(imageUrls: imageURLs, videoUrls: null, numOfEnteredItems: 4),                  // numOfShowItems: imageURLs.length >= 4 ? 4 : imageURLs.length, //in case  I  want  numOfShowItem =<4 but I'm not sure how many items in List I'm  gonna  get
                
              ),
              SizedBox(
                height: size.height,
                width: size.width,
                child: GridViewImages(
                  numOfEnteredItems: 4,
                  imageUrls: null,
                  videoUrls: ytURLs,
                  // numOfShowItems:ytURLs.length >= 4 ? 4 : ytURLs.length,
                ),
              ),
            ],
          ),
          ),
    );
  }
}
