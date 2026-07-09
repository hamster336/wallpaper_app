part of 'wallpaper_bloc.dart';

sealed class WallpaperEvent {}

final class SearchWallpaper extends WallpaperEvent {
  final String query;

  SearchWallpaper({required this.query});
}

final class SearchWallpaperLoadMore extends WallpaperEvent {
  final String query;

  SearchWallpaperLoadMore({required this.query});
}

final class CategoryWallpaper extends WallpaperEvent {
  final String query;

  CategoryWallpaper({required this.query});
}

final class ClearSearch extends WallpaperEvent {}