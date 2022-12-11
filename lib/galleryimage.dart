library galleryimage;

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:galleryimage/gallery_image_view_wrapper.dart';
import 'package:galleryimage/gallery_item_model.dart';
import 'package:galleryimage/gallery_item_thumbnail.dart';

class GridViewImages extends StatefulWidget {

  final List<String>? imageUrls;
  final List<String>? videoUrls;
  final int numOfEnteredItems;

  GridViewImages({required this.imageUrls,required this.videoUrls,required this.numOfEnteredItems,})
  // : assert(numOfShowItems <= imageUrls.length, )
  ;

  @override
  State<GridViewImages> createState() => _GridViewImagesState();
}

class _GridViewImagesState extends State<GridViewImages> {
  late int numOfShowItems;
  late final List<GalleryItemModel> galleryItems = <GalleryItemModel>[];

  @override
  void initState() {
    buildItemsList(widget.imageUrls, widget.videoUrls);

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
    final double runSpacing = 4;
    final w = (MediaQuery.of(context).size.width - runSpacing * (2 - 1)) /
        2; // 2= cross axis count
      return Center(
        child: galleryItems.isEmpty
            ? const SizedBox.shrink()
            : numOfShowItems <= 3
                ? Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 8,
                    spacing: 8,
                    // direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: List.generate(
                      numOfShowItems,
                      (index) => Container(
                        color: Colors.transparent,
                          width: w - 10,
                          height: w - 10,
                          child: Stack(
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
                                    uri:
                                        Uri.parse(galleryItems[index].videoUrl),
                                    builder: (context, followLink) =>
                                        OutlinedButton(
                                          onPressed: followLink,
                                          child: Image.asset(
                                              'images/youtube_icon.png'),
                                        )),
                            ],
                          )),
                    ))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: galleryItems.length > 3
                            ? numOfShowItems
                            : galleryItems.length,
                        padding: const EdgeInsets.all(0),
                        semanticChildCount: 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(

                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          // return ClipRRect(
                          //     borderRadius:
                          //     const BorderRadius.all(Radius.circular(8)),
                          return index < galleryItems.length - 1 &&
                                  index == numOfShowItems - 1
                              ? buildImageNumbers(index)
                              :
                              // child:
                              Stack(
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
                                          uri: Uri.parse(
                                              galleryItems[index].videoUrl),
                                          builder: (context, followLink) =>
                                              OutlinedButton(
                                                onPressed: followLink,
                                                child: Image.asset(
                                                    'images/youtube_icon.png'),
                                              )),
                                  ],
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
  buildItemsList(List<String>? images, List<String>? videos) {
    print('1');
    galleryItems.clear();
    if (images != null) {
      numOfShowItems = images.length  >= widget.numOfEnteredItems? widget.numOfEnteredItems : images.length;
          galleryItems.addAll(images.map((e) =>
          GalleryItemModel(id: e, videoUrl: "", imageUrl: e, isVideo: false)));
    }
    if (videos != null) {
      numOfShowItems = videos.length  >= widget.numOfEnteredItems? widget.numOfEnteredItems : videos.length;
      galleryItems.addAll(videos.map((e) => GalleryItemModel(
          id: e,
          videoUrl: e,
          imageUrl: buildVideoThumbnail(e),
          isVideo: true)));
    }
  }
}
