import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

abstract class WallpaperRepository {
  Future<List<WallpaperEntity>> searchWallpaper(String query, {int page = 1});

  Future<List<WallpaperEntity>> curatedWallpaper({int page = 1});
}
