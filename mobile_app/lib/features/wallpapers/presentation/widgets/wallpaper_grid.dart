import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallapaper_shimmer_card.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

class WallpaperGrid extends StatelessWidget {
  final List<WallpaperEntity>? wallpapers;
  final bool isLoading;
  final Function(WallpaperEntity)? onCardTap;
  final bool showLike;

  const WallpaperGrid({
    super.key,
    required this.wallpapers,
    required this.isLoading,
    this.onCardTap,
    this.showLike = true,
  });

  @override
  Widget build(BuildContext context) {
    // Show shimmer while loading
    if (isLoading) {
      return SliverPadding(
        padding: EdgeInsetsGeometry.only(right: 10),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => WallpaperShimmerCard(),
            childCount: 10,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 2,
            mainAxisSpacing: 8,
          ),
        ),
      );
    }

    // Show actual wallpapers
    return SliverPadding(
      padding: EdgeInsetsGeometry.only(right: 10, bottom: 10),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final wallpaper = wallpapers![index];
          return WallpaperCard(
            wallpaper: wallpaper,
            onTap: () => onCardTap!(wallpaper),
            likedNotifier: context.read<FavoritesBloc>().likedNotifier,
            showLike: showLike,
          );
        }, childCount: wallpapers?.length ?? 0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 2,
          mainAxisSpacing: 8,
        ),
      ),
    );
  }
}
