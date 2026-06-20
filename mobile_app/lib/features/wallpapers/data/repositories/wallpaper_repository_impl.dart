import 'package:mobile_app/features/wallpapers/data/models/wallpaper_model.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:mobile_app/features/wallpapers/domain/repositories/wallpaper_repository.dart';

class WallpaperRepositoryImpl extends WallpaperRepository {
  // @override
  // Future<List<WallpaperEntity>> searchWallpapers(String query) async {
  //   final response = await remoteDataSource.searchWallpapers(query);
  //   return response.map((model) => _modelToEntity(model)).toList();
  // }

  WallpaperEntity modelToEntity(Wallpaper model) {
    return WallpaperEntity(
      id: model.id,
      width: model.width,
      height: model.height,
      imageUrl: model.src.portrait, // extract portrait for mobile
      photographer: model.photographer,
      photographerUrl: model.photographerUrl,
      title: model.alt, // rename alt to title
      liked: model.liked,
    );
  }
}
