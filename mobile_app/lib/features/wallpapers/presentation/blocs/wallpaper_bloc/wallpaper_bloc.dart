import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final WallpaperRepositoryImpl repo;

  WallpaperBloc({required this.repo}) : super(WallpaperInitial()) {
    on<SearchWallpaper>(_searchWallpaper);
    on<CategoryWallpaper>(_categoryWallpaper);
    on<CuratedWallpaper>(_curatedWallpaper);
  }

  final Map<String, List<WallpaperEntity>> cache =
      {}; // to show live changes in UI

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

  // for the 'For you' category, show curated wallpaper
  Future<void> _curatedWallpaper(
    CuratedWallpaper event,
    Emitter<WallpaperState> emit,
  ) async {
    final currentState = state;
    emit(WallpaperLoading());

    final key = 'for you';

    try {
      final wallpapers = await repo.curatedWallpaper();
      cache[key] = wallpapers;
      if (currentState is WallpaperLoaded) {
        emit(
          currentState.copyWith(
            categoryWallpapers: wallpapers,
            searchWallpapers: [],
          ),
        );
      } else {
        emit(
          WallpaperLoaded(categoryWallpapers: wallpapers, searchWallpapers: []),
        );
      }
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
    }
  }

  // for rest of the categories
  Future<void> _categoryWallpaper(
    CategoryWallpaper event,
    Emitter<WallpaperState> emit,
  ) async {
    final currentState = state;
    emit(WallpaperLoading());

    final key = event.query.trim().toLowerCase();

    if (cache.containsKey(key)) {
      if (currentState is WallpaperLoaded) {
        emit(currentState.copyWith(categoryWallpapers: cache[key]!));
      } else {
        emit(WallpaperLoaded(categoryWallpapers: cache[key]!));
      }
      return;
    }

    try {
      List<WallpaperEntity> wallpapers = [];
      if (event.query == "for you") {
        wallpapers = await repo.curatedWallpaper();
      } else {
        wallpapers = await repo.searchWallpaper(event.query);
      }

      cache[key] = wallpapers;
      if (currentState is WallpaperLoaded) {
        emit(
          currentState.copyWith(
            categoryWallpapers: wallpapers,
            searchWallpapers: [],
          ),
        );
      } else {
        emit(
          WallpaperLoaded(categoryWallpapers: wallpapers, searchWallpapers: []),
        );
      }
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
    }
  }
}
