import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';

class WallpaperCard extends StatefulWidget {
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
  State<WallpaperCard> createState() => _WallpaperCardState();
}

class _WallpaperCardState extends State<WallpaperCard> {
  bool isLiked = false;

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
                child: CachedNetworkImage(
                  imageUrl: widget.wallpaper.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[300]),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error), // ← Optional: customize cache
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: (isLiked)
                        ? Colors.red.shade600
                        : Colors.grey.shade300,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  }, // Add/remove favorite
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
