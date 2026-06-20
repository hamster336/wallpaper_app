import 'package:flutter/material.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_card.dart';

class WallpaperGrid extends StatelessWidget {
  final List<WallpaperEntity> wallpapers;
  final VoidCallback Function(WallpaperEntity) onCardTap;
  final VoidCallback Function(WallpaperEntity) onFavoriteTap;

  const WallpaperGrid({
    super.key,
    required this.wallpapers,
    required this.onCardTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
      ),
      itemCount: wallpapers.length,
      itemBuilder: (context, index) {
        return WallpaperCard(
          wallpaper: wallpapers[index],
          onTap: () => onCardTap(wallpapers[index]),
          onFavoriteTap: () => onFavoriteTap(wallpapers[index]),
        );
      },
    );
  }
}
