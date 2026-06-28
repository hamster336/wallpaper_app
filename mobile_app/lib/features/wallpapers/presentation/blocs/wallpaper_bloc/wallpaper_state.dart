part of 'wallpaper_bloc.dart';

sealed class WallpaperState {}

final class WallpaperInitial extends WallpaperState {}

final class WallpaperLoading extends WallpaperState {}

final class WallpaperLoaded extends WallpaperState {
  final bool searched;
  final List<WallpaperEntity> categoryWallpapers;
  final List<WallpaperEntity> searchWallpapers;

  WallpaperLoaded({
    this.searched = false,
    this.categoryWallpapers = const [],
    this.searchWallpapers = const [],
  });

  WallpaperLoaded copyWith({
    bool? searched,
    List<WallpaperEntity>? categoryWallpapers,
    List<WallpaperEntity>? searchWallpapers,
    List<WallpaperEntity>? favoriteWallpapers,
  }) {
    return WallpaperLoaded(
      searched: searched ?? this.searched,
      categoryWallpapers: categoryWallpapers ?? this.categoryWallpapers,
      searchWallpapers: searchWallpapers ?? this.searchWallpapers,
    );
  }
}

final class WallpaperError extends WallpaperState {
  final String message;

  WallpaperError({required this.message});
}

final class DownloadWallpaper extends WallpaperState {}
