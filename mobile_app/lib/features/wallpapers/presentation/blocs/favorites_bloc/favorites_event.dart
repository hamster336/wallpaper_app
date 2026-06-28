part of 'favorites_bloc.dart';

sealed class FavoritesEvent {}

final class LoadFavorites extends FavoritesEvent {}

final class ToggleFavorite extends FavoritesEvent {
  final WallpaperEntity wallpaper;

  ToggleFavorite({required this.wallpaper});
}

final class AddFavorite extends FavoritesEvent {
  final WallpaperEntity wallpaper;

  AddFavorite({required this.wallpaper});
}

final class RemoveFavorite extends FavoritesEvent{
  final int wallpaperId;

  RemoveFavorite({required this.wallpaperId});
}
