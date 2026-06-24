import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final WallpaperRepositoryImpl repo;

  WallpaperBloc({required this.repo}) : super(WallpaperInitial()) {
    on<LoadFavorites>(_loadFavorites);
    on<SearchWallpaper>(_searchWallpaper);
    on<CategoryWallpaper>(_categoryWallpaper);
  }

  final Map<String, List<WallpaperEntity>> cache = {};

  // load favorites
  Future<void> _loadFavorites(
    LoadFavorites event,
    Emitter<WallpaperState> emit,
  ) async {
    try {
      emit(WallpaperLoading());
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
    }
  }

  // search wallpapers
  Future<void> _searchWallpaper(
    SearchWallpaper event,
    Emitter<WallpaperState> emit,
  ) async {
    try {
      final currentState = state;

      emit(WallpaperLoading());
      final wallpapers = await repo.searchWallpaper(
        event.query,
        page: event.page,
      );
      if (currentState is WallpaperLoaded) {
        emit(
          currentState.copyWith(searchWallpapers: wallpapers, searched: true),
        );
      } else {
        emit(WallpaperLoaded(searchWallpapers: wallpapers, searched: true));
      }
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
    }
  }

  // for the categories, show wallpapers with temp caching
  Future<void> _categoryWallpaper(
    CategoryWallpaper event,
    Emitter<WallpaperState> emit,
  ) async {
    final currentState = state;

    final key = event.query.toLowerCase();

    if (cache.containsKey(key)) {
      if (currentState is WallpaperLoaded) {
        emit(
          currentState.copyWith(
            homeWallpapers: cache[key]!,
            searchWallpapers: [],
          ),
        );
      } else {
        emit(
          WallpaperLoaded(homeWallpapers: cache[key]!, searchWallpapers: []),
        );
      }
      return;
    }

    try {
      emit(WallpaperLoading());
      final wallpapers = await repo.searchWallpaper(event.query);
      cache[key] = wallpapers;
      if (currentState is WallpaperLoaded) {
        emit(
          currentState.copyWith(
            homeWallpapers: wallpapers,
            searchWallpapers: [],
          ),
        );
      } else {
        emit(WallpaperLoaded(homeWallpapers: wallpapers, searchWallpapers: []));
      }
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
    }
  }
}
