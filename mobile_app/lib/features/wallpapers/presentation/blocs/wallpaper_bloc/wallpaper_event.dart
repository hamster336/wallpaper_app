part of 'wallpaper_bloc.dart';

sealed class WallpaperEvent {}

final class SearchWallpaper extends WallpaperEvent {
  final String query;
  final int page;

  SearchWallpaper({required this.query, required this.page});
}

final class CuratedWallpaper extends WallpaperEvent {}

final class CategoryWallpaper extends WallpaperEvent {
  final String query;

  CategoryWallpaper({required this.query});
}
