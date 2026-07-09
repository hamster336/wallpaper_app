part of 'favorites_bloc.dart';

sealed class FavoritesEvent {}

final class LoadFavorites extends FavoritesEvent {}

final class ToggleFavorite extends FavoritesEvent {
  final WallpaperEntity wallpaper;

  ToggleFavorite({required this.wallpaper});
}
