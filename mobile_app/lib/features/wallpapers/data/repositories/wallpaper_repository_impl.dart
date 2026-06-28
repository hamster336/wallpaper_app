import 'package:mobile_app/features/wallpapers/data/datasources/favorites_local_storage.dart';
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
      title: model.alt,
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
  Future<List<WallpaperEntity>> curatedWallpaper() async{
    final response = await remoteDataSource.getCuratedWallpapers();
    return response.map((model) => modelToEntity(model)).toList();
  }
  
  @override
  Future<List<WallpaperEntity>> getFavorites() async{
    try {
      final favorites = await FavoritesServices.getAllLiked();
      return favorites;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<void> addToFavorite(WallpaperEntity wallpaper) async{
    try {
      await FavoritesServices.addLike(wallpaper);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<void> removeFromFavorite(int id) async{
    try {
      await FavoritesServices.removeLike(id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
