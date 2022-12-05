library galleryimage;

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:galleryimage/gallery_image_view_wrapper.dart';
import 'package:galleryimage/gallery_item_model.dart';
import 'package:galleryimage/gallery_item_thumbnail.dart';

class GridViewImages extends StatefulWidget {
  final int numOfShowItems;
  final String titleGallery;

  GridViewImages(
      {required this.titleGallery,
        // required this.imageUrls,
        this.numOfShowItems = 3})
  // : assert(numOfShowItems <= imageUrls.length, )
      ;
  @override
  State<GridViewImages> createState() => _GridViewImagesState();
}

class _GridViewImagesState extends State<GridViewImages> {
  late final List<String> imageUrls = <String>[];
  late final List<GalleryItemModel> galleryItems = <GalleryItemModel>[];

  List<String> imageURLs = [
    "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
    "https://tahh3ccmtxa7trnk.s3.me-south-1.amazonaws.com/3ff5b5f1-6d92-46a3-ba58-7ad4df4defa5",
    // "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
    // "https://tahh3ccmtxa7trnk.s3.me-south-1.amazonaws.com/3ff5b5f1-6d92-46a3-ba58-7ad4df4defa5",
    // "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
  ];

  List<String> ytURLs = [
    "https://www.youtube.com/watch?v=qPj50i3gkAo",
    "https://www.youtube.com/watch?v=R4jQemNpxn4",
    "https://www.youtube.com/watch?v=X-yIEMduRXk&list=RDX-yIEMduRXk&start_radio=1",
    // "https://www.youtube.com/watch?v=qPj50i3gkAo",
    // "https://www.youtube.com/watch?v=R4jQemNpxn4",
  ];
  @override
  void initState() {
    buildItemsList(imageURLs, ytURLs);
    super.initState();
  }

  String buildVideoThumbnail(String url) {
    print(url);
    var videoID = Uri.parse('$url').queryParameters['v'];
    print('bbbbbbbbbbbbbbbbbbb $videoID');
    String image = 'https://img.youtube.com/vi/$videoID/hqdefault.jpg';
    return image;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: galleryItems.isEmpty
            ? const SizedBox.shrink()
            : GridView.builder(
            primary: false,
            itemCount:
            galleryItems.length > 3 ? widget.numOfShowItems : galleryItems.length,
            padding: const EdgeInsets.all(0),
            semanticChildCount: 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                // if have less than 4 image w build GalleryItemThumbnail
                // if have mor than 4 build image number 3 with number for other images
                child: index < galleryItems.length - 1 &&
                    index == widget.numOfShowItems - 1
                    ? buildImageNumbers(index)
                    : galleryItems[index].isVideo == true
                    ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      galleryItems[index].imageUrl,
                    ),
                    Link(
                        target: LinkTarget.self,
                        uri: Uri.parse(
                            '${galleryItems[index].videoUrl}'),
                        builder: (context, followLink) =>
                            OutlinedButton(
                              onPressed: followLink,
                              child: Image.asset(
                                  'images/youtube_icon.png'),
                            )),
                  ],
                )
                    : GalleryItemThumbnail(
                  galleryItem: galleryItems[index],
                  onTap: () {
                    openImageFullScreen(index);
                  },
                ),
              );
            }),
      ),
    );
  }

// build image with number for other images
  Widget buildImageNumbers(int index) {
    return GestureDetector(
      onTap: () {
        print('mmmmmm${galleryItems.map((e) => e.imageUrl).toList()}');
        openImageFullScreen(index);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          galleryItems[index].isVideo == true
              ? Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                galleryItems[index].imageUrl,
              ),
              Link(
                  target: LinkTarget.self,
                  uri: Uri.parse('${galleryItems[index].videoUrl}'),
                  builder: (context, followLink) => OutlinedButton(
                    onPressed: followLink,
                    child: Image.asset('images/youtube_icon.png'),
                  )),
            ],
          )
              : GalleryItemThumbnail(
            galleryItem: galleryItems[index],
          ),
          Container(
            color: Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                "+${galleryItems.length - index}",
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

// to open gallery image in full screen
  void openImageFullScreen(final int indexOfImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageViewWrapper(
          titleGallery: widget.titleGallery,
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: indexOfImage,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

// clear and build list
  buildItemsList(List<String> images, List<String> videos) {
    print('1');
    galleryItems.clear();
    for (int i = 0; i < images.length; i++) {
      galleryItems.add(
        GalleryItemModel('', id: images[i], imageUrl: images[i], isVideo: false),

      );
      print(galleryItems[i].imageUrl);
    }
    for (int i = 0; i < videos.length; i++) {
      galleryItems.add(GalleryItemModel(
        '${videos[i]}',
          id: videos[i],
          imageUrl: buildVideoThumbnail(videos[i]),
          isVideo: true,
          ));
      print(galleryItems[i].imageUrl);
    }
    imageUrls.addAll(galleryItems.map((e) => e.imageUrl).toList());
  }
}
