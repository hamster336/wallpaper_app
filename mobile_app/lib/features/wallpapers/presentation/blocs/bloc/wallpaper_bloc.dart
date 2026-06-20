import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  WallpaperBloc() : super(WallpaperInitial()) {
    on<LoadFavorites>(_loadFavorites);
  }

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
}
