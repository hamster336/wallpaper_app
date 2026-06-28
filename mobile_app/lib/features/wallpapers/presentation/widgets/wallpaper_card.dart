import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/notifiers/liked_wallpaper_notifier.dart';

class WallpaperCard extends StatefulWidget {
  final WallpaperEntity wallpaper;
  final VoidCallback onTap;
  final LikedWallpapersNotifier likedNotifier;
  final bool showLike;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    required this.onTap,
    required this.likedNotifier,
    this.showLike = true,
  });

  @override
  State<WallpaperCard> createState() => _WallpaperCardState();
}

class _WallpaperCardState extends State<WallpaperCard> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: GestureDetector(
        onTap: widget.onTap, // Open detail screen
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: .circular(15),
                child:
                    // Image.network(widget.wallpaper.imageUrl),
                    CachedNetworkImage(
                      imageUrl: widget.wallpaper.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[300]),
                      // errorWidget: (context, url, error) =>
                      //     Icon(Icons.error), // ← Optional: customize cache
                      errorWidget: (context, url, error) {
                        log('Image load error: $error');
                        log('URL: $url');
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      },
                      httpHeaders: {'User-Agent': 'Mozilla/5.0'},
                    ),
              ),

              if (widget.showLike)
                Positioned(
                  top: 8,
                  right: 8,
                  child: ValueListenableBuilder<Set<int>>(
                    valueListenable: widget.likedNotifier,
                    builder: (context, likedIds, child) {
                      final isLiked = likedIds.contains(widget.wallpaper.id);

                      return IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked
                              ? Colors.red.shade600
                              : Colors.grey.shade300,
                        ),
                        onPressed: () {
                          context.read<FavoritesBloc>().add(
                            ToggleFavorite(wallpaper: widget.wallpaper),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
