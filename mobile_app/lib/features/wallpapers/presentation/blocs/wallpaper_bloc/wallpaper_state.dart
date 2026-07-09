part of 'wallpaper_bloc.dart';

sealed class WallpaperState {}

final class WallpaperInitial extends WallpaperState {}

final class WallpaperLoading extends WallpaperState {}

final class WallpaperLoaded extends WallpaperState {
  final bool searched;
  final List<WallpaperEntity> categoryWallpapers;
  final List<WallpaperEntity> searchWallpapers;
  final bool isLoadingMore;
  final bool hasReachedMax;

  WallpaperLoaded({
    this.searched = false,
    this.categoryWallpapers = const [],
    this.searchWallpapers = const [],
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  WallpaperLoaded copyWith({
    bool? searched,
    List<WallpaperEntity>? categoryWallpapers,
    List<WallpaperEntity>? searchWallpapers,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return WallpaperLoaded(
      searched: searched ?? this.searched,
      categoryWallpapers: categoryWallpapers ?? this.categoryWallpapers,
      searchWallpapers: searchWallpapers ?? this.searchWallpapers,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }
}

final class WallpaperError extends WallpaperState {
  final String message;

  WallpaperError({required this.message});
}

final class DownloadWallpaper extends WallpaperState {}
