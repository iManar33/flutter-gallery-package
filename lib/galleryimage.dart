library galleryimage;

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:galleryimage/gallery_image_view_wrapper.dart';
import 'package:galleryimage/gallery_item_model.dart';
import 'package:galleryimage/gallery_item_thumbnail.dart';

class GridViewImages extends StatefulWidget {
  final int numOfShowItems;
  final String titleGallery;
  final String titleGrid;
  final List<String>? imageUrls;
  final List<String>? videoUrls;

  GridViewImages(
      {required this.titleGallery,
      required this.titleGrid,
      this.imageUrls,
      this.videoUrls,
      required this.numOfShowItems})
  // : assert(numOfShowItems <= imageUrls.length, )
  ;

  @override
  State<GridViewImages> createState() => _GridViewImagesState();
}

class _GridViewImagesState extends State<GridViewImages> {
  // late final List<String> imageUrls = <String>[];
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
    String image = 'https://img.youtube.com/vi/$videoID/hqdefault.jpg';
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: galleryItems.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.titleGrid} (${galleryItems.length})',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        color: Color(0xFF3C3C3C),
                      ),
                    ),
                    SizedBox(
                      height: 21.0,
                    ),
                    GridView.builder(
                        primary: false,
                        itemCount: galleryItems.length > 3
                            ? widget.numOfShowItems
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
                          return ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
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
                  ],
                ),
        ),
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
  buildItemsList(List<String>? images, List<String>? videos) {
    print('1');
    galleryItems.clear();
    images != null && videos == null
        ? {
            for (int i = 0; i < images.length; i++)
              {
                galleryItems.add(
                  GalleryItemModel('',
                      id: images[i], imageUrl: images[i], isVideo: false),
                )
                // print(galleryItems[i].imageUrl);
              }
          }
        : images == null && videos != null
            ? {
                for (int i = 0; i < videos.length; i++)
                  {
                    galleryItems.add(GalleryItemModel(
                      '${videos[i]}',
                      id: videos[i],
                      imageUrl: buildVideoThumbnail(videos[i]),
                      isVideo: true,
                    ))
                    // print(galleryItems[i].imageUrl);
                  }
              }
            : galleryItems.clear();
    // imageUrls.addAll(galleryItems.map((e) => e.imageUrl).toList());
  }
}
