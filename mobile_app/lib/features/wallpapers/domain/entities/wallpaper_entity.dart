class WallpaperEntity {
  final int id;
  final int width;
  final int height;
  final String imageUrl;           
  final String photographer;
  final String photographerUrl;
  final String title;              
  final bool liked;

  WallpaperEntity({
    required this.id,
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.photographer,
    required this.photographerUrl,
    required this.title,
    required this.liked,
  });
}