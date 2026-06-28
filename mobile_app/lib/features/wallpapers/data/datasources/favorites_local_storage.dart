import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

class FavoritesServices {
  static const String _boxName = 'liked_wallpapers';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WallpaperEntityAdapter());
    await Hive.openBox<WallpaperEntity>(_boxName);
  }

  static Future<Box<WallpaperEntity>> _getBox() async {
    return await Hive.openBox<WallpaperEntity>(_boxName);
  }

  static Future<void> addLike(WallpaperEntity wallpaper) async {
    final box = await _getBox();
    if (!box.containsKey(wallpaper.id)) {
      await box.put(wallpaper.id, wallpaper);
    }
  }

  static Future<void> removeLike(int wallpaperId) async {
    final box = await _getBox();
    await box.delete(wallpaperId);
  }

  static Future<bool> isLiked(int wallpaperId) async {
    final box = await _getBox();
    return box.containsKey(wallpaperId);
  }

  static Future<List<WallpaperEntity>> getAllLiked() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> removeAllLiked() async {
    final box = await _getBox();
    await box.clear();
  }
}
