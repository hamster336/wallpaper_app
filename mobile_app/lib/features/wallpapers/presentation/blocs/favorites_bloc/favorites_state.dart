part of 'favorites_bloc.dart';

sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesLoaded extends FavoritesState {
  final List<WallpaperEntity> favorites;

  FavoritesLoaded({required this.favorites});
}

final class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError({required this.message});
}
