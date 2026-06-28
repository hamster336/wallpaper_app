import 'package:http/http.dart' as http;
import 'package:mobile_app/config/api_config.dart';
import 'dart:convert';

import 'package:mobile_app/features/wallpapers/data/models/wallpaper_model.dart';

abstract class WallpaperRemoteDatasoruce {
  Future<List<Wallpaper>> searchWallpapers(String query, {int page = 1});
  Future<List<Wallpaper>> getCuratedWallpapers();
}

class WallpaperRemoteDataSourceImpl extends WallpaperRemoteDatasoruce {
  final http.Client httpClient;

  WallpaperRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<Wallpaper>> searchWallpapers(String query, {int page = 1}) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/api/wallpapers/search?query=$query&page=$page',
      );

      final response = await httpClient.get(uri).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<Wallpaper> wallpapers = (jsonData['photos'] as List)
            .map((wallpaper) => Wallpaper.fromJson(wallpaper))
            .toList();
        return wallpapers;
      } else {
        throw Exception('Failed to load wallpapers');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  @override
  Future<List<Wallpaper>> getCuratedWallpapers() async {
    try {
      final response = await httpClient
          .get(
            Uri.parse(
              '${ApiConfig.baseUrl}/api/wallpapers/curated',
            ),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<Wallpaper> wallpapers = (jsonData['photos'] as List)
            .map((wallpaper) => Wallpaper.fromJson(wallpaper))
            .toList();
        return wallpapers;
      } else {
        throw Exception('Failed to load curated wallpapers');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
