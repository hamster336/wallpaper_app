part of 'wallpaper_action_bloc.dart';

sealed class WallpaperActionState {}

final class WallpaperActionInitial extends WallpaperActionState {}

final class WallpaperSetLoading extends WallpaperActionState {}

final class WallpaperSetSuccess extends WallpaperActionState {}

final class WallpaperSetFailure extends WallpaperActionState {
  final String message;

  WallpaperSetFailure({required this.message});
}
