part of 'wallpaper_action_bloc.dart';

sealed class WallpaperActionEvent {}

final class SetWallpaper extends WallpaperActionEvent {
  final WallpaperType type;
  final WallpaperEntity wallpaper;

  SetWallpaper({required this.type, required this.wallpaper});
}
