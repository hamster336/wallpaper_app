import 'package:mobile_app/features/wallpapers/data/datasources/wallpaper_remote_datasoruce.dart';
import 'package:mobile_app/features/wallpapers/data/models/wallpaper_model.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:mobile_app/features/wallpapers/domain/repositories/wallpaper_repository.dart';

class WallpaperRepositoryImpl extends WallpaperRepository {
  final WallpaperRemoteDataSourceImpl remoteDataSource;

  WallpaperRepositoryImpl({required this.remoteDataSource});

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

  @override
  Future<List<WallpaperEntity>> searchWallpaper(
    String query, {
    int page = 1,
  }) async {
    final response = await remoteDataSource.searchWallpapers(query, page: page);
    return response.map((model) => modelToEntity(model)).toList();
  }

  @override
  Future<List<WallpaperEntity>> curatedWallpaper({int page = 1}) {
    // TODO: implement curatedWallpaper
    throw UnimplementedError();
  }
}
