import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/notifiers/liked_wallpaper_notifier.dart';

class WallpaperDetailPage extends StatelessWidget {
  final WallpaperEntity wallpaper;
  final LikedWallpapersNotifier likedNotifier;

  const WallpaperDetailPage({
    super.key,
    required this.wallpaper,
    required this.likedNotifier,
  });

  @override
  Widget build(BuildContext context) {
    log(wallpaper.imageUrl);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Full-screen image AppBar
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height,
            floating: false,
            pinned: true,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: 
                  // Image.network(wallpaper.imageUrl),
                  CachedNetworkImage(
                    imageUrl: wallpaper.imageUrl,

                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[300]),
                  ),
                  collapseMode: CollapseMode.parallax,
                ),

                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.keyboard_double_arrow_up_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ],
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
          ),

          // Details section (scrollable)
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    wallpaper.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 12),

                  // Photographer
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Photographer',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            wallpaper.photographer,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Resolution info
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${wallpaper.width} x ${wallpaper.height}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Set as wallpaper
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Set as Wallpaper',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: likedNotifier,
                          builder: (context, likedIds, child) {
                            final isLiked = likedIds.contains(wallpaper.id);

                            return IconButton(
                              onPressed: () {
                                context.read<FavoritesBloc>().add(
                                  ToggleFavorite(wallpaper: wallpaper),
                                );
                              },
                              icon: (isLiked)
                                  ? Icon(Icons.favorite, color: Colors.red)
                                  : Icon(
                                      Icons.favorite_outline,
                                      color: Colors.red,
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
