import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/constants/required_enums.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:wallpaper/wallpaper.dart';

part 'wallpaper_action_event.dart';
part 'wallpaper_action_state.dart';

class WallpaperActionBloc
    extends Bloc<WallpaperActionEvent, WallpaperActionState> {
  WallpaperActionBloc() : super(WallpaperActionInitial()) {
    on<SetWallpaper>(_setWallpaper);
  }

  // set wallpaper
  Future<void> _setWallpaper(
    SetWallpaper event,
    Emitter<WallpaperActionState> emit,
  ) async {
    emit(WallpaperSetLoading());

    try {
      Wallpaper.imageDownloadProgress(
        event.wallpaper.imageUrl,
        location: DownloadLocation.applicationDirectory,
      );

      switch (event.type) {
        case WallpaperType.home:
          await Wallpaper.homeScreen(
            location: DownloadLocation.applicationDirectory,
            options: RequestSizeOptions.resizeFit,
          );
        case WallpaperType.lock:
          await Wallpaper.lockScreen(
            location: DownloadLocation.applicationDirectory,
            options: RequestSizeOptions.resizeFit,
          );
        case WallpaperType.both:
          await Wallpaper.bothScreen(
            location: DownloadLocation.applicationDirectory,
            options: RequestSizeOptions.resizeFit,
          );
      }
      emit(WallpaperSetSuccess());
    } catch (e) {
      emit(WallpaperSetFailure(message: e.toString()));
    }
  }
}
