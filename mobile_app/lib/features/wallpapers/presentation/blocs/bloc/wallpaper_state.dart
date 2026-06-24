part of 'wallpaper_bloc.dart';

sealed class WallpaperState {}

final class WallpaperInitial extends WallpaperState {}

final class WallpaperLoading extends WallpaperState {}

final class WallpaperLoaded extends WallpaperState {
  final bool searched;
  final List<WallpaperEntity> homeWallpapers;
  final List<WallpaperEntity> searchWallpapers;
  final List<WallpaperEntity> favoriteWallpapers;

  WallpaperLoaded({
    this.searched = false,
    this.homeWallpapers = const [],
    this.searchWallpapers = const [],
    this.favoriteWallpapers = const [],
  });

  WallpaperLoaded copyWith({
    bool? searched,
    List<WallpaperEntity>? homeWallpapers,
    List<WallpaperEntity>? searchWallpapers,
    List<WallpaperEntity>? favoriteWallpapers,
  }) {
    return WallpaperLoaded(
      searched: searched ?? this.searched,
      homeWallpapers: homeWallpapers ?? this.homeWallpapers,
      searchWallpapers: searchWallpapers ?? this.searchWallpapers,
      favoriteWallpapers: favoriteWallpapers ?? this.favoriteWallpapers,
    );
  }
}

final class WallpaperError extends WallpaperState {
  final String message;

  WallpaperError({required this.message});
}

final class DownloadWallpaper extends WallpaperState {}
