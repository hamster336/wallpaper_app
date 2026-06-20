part of 'wallpaper_bloc.dart';

sealed class WallpaperState {}

final class WallpaperInitial extends WallpaperState {}

final class WallpaperLoading extends WallpaperState {}

final class WallpaperLoaded extends WallpaperState {
  final List<WallpaperEntity> wallpapers;

  WallpaperLoaded({required this.wallpapers});
}

final class WallpaperError extends WallpaperState {
  final String message;

  WallpaperError({required this.message});
}

final class DownloadWallpaper extends WallpaperState {}
