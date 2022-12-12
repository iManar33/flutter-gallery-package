library galleryimage;

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:galleryimage/gallery_image_view_wrapper.dart';
import 'package:galleryimage/gallery_item_model.dart';
import 'package:galleryimage/gallery_item_thumbnail.dart';

class GridViewImages extends StatefulWidget {
  final List<String> urls;
  final bool isVideo;
  final int  spacing;
  GridViewImages(
      {required this.urls,
        required  this.isVideo,
        required this.spacing,
      });

  @override
  State<GridViewImages> createState() => _GridViewImagesState();
}

class _GridViewImagesState extends State<GridViewImages> {
  late final List<GalleryItemModel> galleryItems = <GalleryItemModel>[];
  List<String> itemsToShow  =  [];
   int remainingItems  =0;

  @override
  void initState() {
    buildItemsList(widget.urls);
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
        2; // 2= cross axis count
    return galleryItems.isEmpty
        ? const SizedBox.shrink()
        : Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 4,
                spacing: 4,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: List.generate(
                  itemsToShow.length,
                  (index) => Container(
                    color: Colors.transparent,
                    width: w,
                    height: w,
                    child: index == 3 && remainingItems != 0
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
                              builder: (context, followLink) =>
                                  OutlinedButton(
                                    onPressed: followLink,
                                    child: Image.asset(
                                        'images/youtube_icon.png'),
                                  )),
                      ],
                    ),
                  ),
                ));
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
                        child: Image.asset('images/youtube_icon.png'),
                      )),
            Container(
              color: Colors.black.withOpacity(.7),
              child: Center(
                child: Text(
                  '+$remainingItems',
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
  buildItemsList(List<String> urls,) {
    // List<String> itemsToShow  = [];
    // int remainingItems = 0;
    if(urls.length > 4){
      for(int i = 0; i < 4;  i++) {
        itemsToShow.add(urls[i]);
      }
      remainingItems = urls.length - itemsToShow.length + 1;

    }
         else if (urls.length == 4 ){
           for (int i = 0; i < 4;  i++) {
             itemsToShow.add(urls[i]);
           }
           remainingItems = urls.length - itemsToShow.length;
         }
else  {
      itemsToShow = urls;
      remainingItems = urls.length - itemsToShow.length;
    }

    print('1');
    galleryItems.clear();
    if (urls != null && widget.isVideo  ==  false) {
      galleryItems.addAll(urls.map((e) =>
          GalleryItemModel(id: e, videoUrl: "", imageUrl: e, isVideo: false)));
    }
    if (urls != null  &&  widget.isVideo == true) {
      galleryItems.addAll(urls.map((e) => GalleryItemModel(
          id: e,
          videoUrl: e,
          imageUrl: buildVideoThumbnail(e),
          isVideo: true)));
    }
  }
}
