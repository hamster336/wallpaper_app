import 'package:flutter/material.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

class WallpaperCard extends StatelessWidget {
  final WallpaperEntity wallpaper;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: onTap, // Open detail screen
        child: Stack(
          children: [
            Image.network(wallpaper.imageUrl),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: onFavoriteTap, // Add/remove favorite
              ),
            ),
          ],
        ),
      ),
    );
  }
}
