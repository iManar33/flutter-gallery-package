class GalleryItemModel {
  GalleryItemModel(this.videoUrl, {required this.id, required this.imageUrl, required this.isVideo});
// id image (image url) to use in hero animation
  final String id;
  // image url
  final String imageUrl;
  final bool isVideo;
  String videoUrl;
}