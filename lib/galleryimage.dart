library galleryimage;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:galleryimage/gallery_image_view_wrapper.dart';
import 'package:galleryimage/gallery_item_model.dart';
import 'package:galleryimage/gallery_item_thumbnail.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GridViewImages extends StatefulWidget {
  final List<String> urls;
  final bool isVideo;
  final double spacing;
  final int numOfShowItems;
  // final  Future<void>? onPressed;

  GridViewImages(
      // this.onPressed,
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
    String image = 'https://img.youtube.com/vi/$videoID/hqdefault.jpg';
    print(image);
    return image;
  }



  @override
  Widget build(BuildContext context) {
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
                crossAxisCount: galleryItems.length != 1 ? 2 : 1,
                mainAxisSpacing: widget.spacing,
                crossAxisSpacing: widget.spacing,
              childAspectRatio: 1,

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


                          link(galleryItem: galleryItems[index]),
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
              link(galleryItem: galleryItems[index]),
              // Link(
              //     uri: Uri.parse(galleryItems[index].videoUrl),
              //     builder: (context, followLink) => OutlinedButton(
              //           onPressed: followLink,
              //           child: Image(image: AssetImage('images/youtube_icon.png', package: 'galleryimage')),
              //         )),
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

class link extends StatelessWidget {
  const link({
    Key? key,
    required this.galleryItem,
  }) : super(key: key);

  final GalleryItemModel galleryItem;

  /// safe launch for urls that doesn't contain scheme
  Future<void> launchUrl(String url) async {
    if (!(url.startsWith('https://') || url.startsWith('http://'))) {
      url = 'https://$url';
    }
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  }
  @override
  Widget build(BuildContext context) {
    return Link(
        uri: Uri.parse(galleryItem.videoUrl),
        builder: (context, followLink) => OutlinedButton(
              onPressed: ()  =>   launchUrl(galleryItem.videoUrl),
              child:
              Image(image: AssetImage('images/youtube_icon.png', package: 'galleryimage')),
            ));
  }
}

