import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  final WallpaperRepositoryImpl repo;

  WallpaperBloc({required this.repo}) : super(WallpaperInitial()) {
    on<SearchWallpaper>(_searchWallpaper);
    on<SearchWallpaperLoadMore>(_searchWallpaperLoadMore);
    on<CategoryWallpaper>(_categoryWallpaper);
    on<ClearSearch>(_clearSearch);
  }

  int _currentPage = 1;
  final Map<String, List<WallpaperEntity>> cache =
      {}; // cache the category wallpapers
  WallpaperLoaded? _lastLoadedState;

  WallpaperLoaded _getLastLoadedState(WallpaperState state) {
    if (state is WallpaperLoaded) {
      return state;
    }

    return _lastLoadedState ?? WallpaperLoaded();
  }

  // search wallpapers
  Future<void> _searchWallpaper(
    SearchWallpaper event,
    Emitter<WallpaperState> emit,
  ) async {
    try {
      final previousState = _getLastLoadedState(state);

      emit(WallpaperLoading());

      _currentPage = 1;

      final wallpapers = await repo.searchWallpaper(
        query: event.query,
        page: _currentPage,
      );

      final nextState = previousState.copyWith(
        searchWallpapers: wallpapers,
        searched: true,
      );
      _lastLoadedState = nextState;
      emit(nextState);
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
    }
  }

  // to load more wallpapers as user scorlls
  Future<void> _searchWallpaperLoadMore(
    SearchWallpaperLoadMore event,
    Emitter<WallpaperState> emit,
  ) async {
    if (state is! WallpaperLoaded) return;

    final currentState = state as WallpaperLoaded;

    final nextPage = _currentPage + 1;
    try {
      emit(currentState.copyWith(isLoadingMore: true));

      final wallpapers = await repo.searchWallpaper(
        query: event.query,
        page: nextPage,
      );

      _currentPage = nextPage; // change to the nextPage only after success

      final combined = [...currentState.searchWallpapers, ...wallpapers];

      emit(
        currentState.copyWith(
          searchWallpapers: combined,
          searched: true,
          isLoadingMore: false,
          hasReachedMax: wallpapers.isEmpty,
        ),
      );
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
      emit(
        currentState,
      ); // on error, restore the previous state so user does not see a blank screen
    }
  }

  // for the categories
  Future<void> _categoryWallpaper(
    CategoryWallpaper event,
    Emitter<WallpaperState> emit,
  ) async {
    final previousState = _getLastLoadedState(state);

    emit(WallpaperLoading());

    final key = event.query.trim().toLowerCase();

    if (cache.containsKey(key)) {
      final nextState = previousState.copyWith(
        categoryWallpapers: cache[key]!,
        searchWallpapers: [],
        searched: false,
      );
      _lastLoadedState = nextState;
      emit(nextState);
      return;
    }

    try {
      final wallpapers = (key == "for you")
          ? await repo.curatedWallpaper()
          : await repo.searchWallpaper(query: event.query, page: 1);

      cache[key] = wallpapers;
      final nextState = previousState.copyWith(
        categoryWallpapers: wallpapers,
        searchWallpapers: [],
        searched: false,
      );
      _lastLoadedState = nextState;
      emit(nextState);
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
    }
  }

  // clear search
  Future<void> _clearSearch(
    ClearSearch event,
    Emitter<WallpaperState> emit,
  ) async {
    final previousState = _getLastLoadedState(state);

    final nextState = previousState.copyWith(
      searchWallpapers: [],
      searched: false,
    );
    _lastLoadedState = nextState;
    emit(nextState);
    log('search cleared');
  }
}
