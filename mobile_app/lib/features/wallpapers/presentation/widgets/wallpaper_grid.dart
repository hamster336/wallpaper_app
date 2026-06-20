import 'package:flutter/material.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallapaper_shimmer_card.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

class WallpaperGrid extends StatelessWidget {
  final List<WallpaperEntity>? wallpapers;
  final bool isLoading;
  final VoidCallback Function(WallpaperEntity)? onCardTap;
  final VoidCallback Function(WallpaperEntity)? onFavoriteTap;

  const WallpaperGrid({
    super.key,
    required this.wallpapers,
    required this.isLoading,
    this.onCardTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    // Show shimmer while loading
    if (isLoading) {
      return SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => WallpaperShimmerCard(),
          childCount: 10,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
      );
    }

    // Show actual wallpapers
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        return WallpaperCard(
          wallpaper: wallpapers![index],
          onTap: () => {},
          onFavoriteTap: () => {},
          // onTap: () =>  onCardTap(wallpapers![index]),
          // onFavoriteTap: () => onFavoriteTap(wallpapers![index]),
        );
      }, childCount: wallpapers?.length ?? 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
    );
  }
}
