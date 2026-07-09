import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:mobile_app/features/wallpapers/presentation/notifiers/liked_wallpaper_notifier.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final WallpaperRepositoryImpl repo;
  final LikedWallpapersNotifier likedNotifier;

  FavoritesBloc({required this.repo, required this.likedNotifier})
    : super(FavoritesInitial()) {
    on<LoadFavorites>(_loadFavorites);
    on<ToggleFavorite>(_toggleFavorite);
  }

  List<WallpaperEntity> _favorites = [];

  Future<void> _toggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final isLiked = likedNotifier.isLiked(event.wallpaper.id);

      if (isLiked) {
        await repo.removeFromFavorite(event.wallpaper.id);
        likedNotifier.removeLiked(event.wallpaper.id);
        _favorites.removeWhere((w) => w.id == event.wallpaper.id);
      } else {
        final wallpaper = WallpaperEntity(
          id: event.wallpaper.id,
          width: event.wallpaper.width,
          height: event.wallpaper.height,
          imageUrl: event.wallpaper.imageUrl,
          photographer: event.wallpaper.photographer,
          photographerUrl: event.wallpaper.photographerUrl,
          title: event.wallpaper.title,
          likedAt: DateTime.now(),
        );

        await repo.addToFavorite(wallpaper);
        likedNotifier.addLiked(wallpaper.id);

        _favorites.add(wallpaper);
      }

      _favorites.sort(
        (a, b) => (b.likedAt ?? DateTime(1970)).compareTo(
          a.likedAt ?? DateTime(1970),
        ),
      );

      emit(FavoritesLoaded(favorites: _favorites));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  // load favorites
  Future<void> _loadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final favorites = await repo.getFavorites();
      favorites.sort(
        (a, b) => (b.likedAt ?? DateTime(1970)).compareTo(
          a.likedAt ?? DateTime(1970),
        ),
      );

      _favorites = favorites;
      likedNotifier.value = {for (var fav in favorites) fav.id};

      emit(FavoritesLoaded(favorites: _favorites));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }
}
