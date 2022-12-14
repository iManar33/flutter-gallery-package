library galleryimage;

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:galleryimage/gallery_image_view_wrapper.dart';
import 'package:galleryimage/gallery_item_model.dart';
import 'package:galleryimage/gallery_item_thumbnail.dart';

class GridViewImages extends StatefulWidget {
  final List<String> urls;
  final bool isVideo;
  final double spacing;
  final int numOfShowItems;

  GridViewImages(
      {required this.urls,
      required this.isVideo,
      required this.spacing,
      required this.numOfShowItems})
  // : assert(numOfShowItems <= imageUrls.length, )
  ;

  @override
  State<GridViewImages> createState() => _GridViewImagesState();
}

class _GridViewImagesState extends State<GridViewImages> {
  late final List<GalleryItemModel> galleryItems = <GalleryItemModel>[];

  @override
  void initState() {
    buildItemsList(widget.urls, widget.isVideo);
    super.initState();
  }

  String buildVideoThumbnail(String url) {
    print(url);
    var videoID = Uri.parse('$url').queryParameters['v'];
    print('bbbbbbbbbbbbbbbbbbb $videoID');
    String image = 'https://img.youtube.com/vi/$videoID/maxresdefault.jpg';
    return image;
  }

  @override
  Widget build(BuildContext context) {
    final w = (MediaQuery.of(context).size.width - widget.spacing * (2 - 1)) /
        2;
    final h = (MediaQuery.of(context).size.height - widget.spacing * (2 - 1)) /
        2;
    return galleryItems.isEmpty
        ? const SizedBox.shrink()
        : GridView.builder(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: galleryItems.length > 3
                ? widget.numOfShowItems
                : galleryItems.length,
            padding: const EdgeInsets.all(0),
            semanticChildCount: 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: widget.spacing,
                crossAxisSpacing: widget.spacing,
              childAspectRatio: w/h,

            ),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              // return ClipRRect(
              //     borderRadius:
              //     const BorderRadius.all(Radius.circular(8)),
              return index < galleryItems.length - 1 &&
                      index == widget.numOfShowItems - 1
                  ? buildImageNumbers(index)
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        GalleryItemThumbnail(
                          galleryItem: galleryItems[index],
                          onTap: () {
                            openImageFullScreen(index);
                          },
                        ),
                        if (galleryItems[index].isVideo == true)
                          Link(
                              target: LinkTarget.self,
                              uri: Uri.parse(galleryItems[index].videoUrl),
                              builder: (context, followLink) => OutlinedButton(
                                    onPressed: followLink,
                                    child:
                                    Image(image: AssetImage('images/youtube_icon.png', package: 'galleryimage')),
                                  )),
                      ],
                    );
            });
  }

// build image with number for other images
  Widget buildImageNumbers(int index) {
    return GestureDetector(
        onTap: () {
          print('mmmmmm${galleryItems.map((e) => e.imageUrl).toList()}');
          openImageFullScreen(index);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            GalleryItemThumbnail(
              galleryItem: galleryItems[index],
            ),
            if (galleryItems[index].isVideo == true)
              Link(
                  target: LinkTarget.self,
                  uri: Uri.parse(galleryItems[index].videoUrl),
                  builder: (context, followLink) => OutlinedButton(
                        onPressed: followLink,
                        child: Image(image: AssetImage('images/youtube_icon.png', package: 'galleryimage')),
                      )),
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
        ));
  }

// to open gallery image in full screen
  void openImageFullScreen(final int indexOfImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageViewWrapper(
          titleGallery: '',
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
  buildItemsList(List<String> urls, bool isVideo) {
    print('1');
    galleryItems.clear();
    if (urls != null && isVideo == false) {
      galleryItems.addAll(urls.map((e) =>
          GalleryItemModel(id: e, videoUrl: "", imageUrl: e, isVideo: false)));
    }
    if (urls != null && isVideo == true) {
      galleryItems.addAll(urls.map((e) => GalleryItemModel(
          id: e,
          videoUrl: e,
          imageUrl: buildVideoThumbnail(e),
          isVideo: true)));
    }
  }
}
