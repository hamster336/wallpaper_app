import 'package:hive_ce/hive.dart';

part 'wallpaper_entity.g.dart';

@HiveType(typeId: 0)
class WallpaperEntity extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int width;
  @HiveField(2)
  final int height;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final String photographer;
  @HiveField(5)
  final String photographerUrl;
  @HiveField(6)
  final String title;
  @HiveField(7)
  final DateTime? likedAt;

  WallpaperEntity({
    required this.id,
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.photographer,
    required this.photographerUrl,
    required this.title,
    this.likedAt,
  });
}
