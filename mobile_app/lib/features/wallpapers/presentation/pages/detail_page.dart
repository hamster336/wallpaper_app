import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/constants/required_enums.dart';
import 'package:mobile_app/features/wallpapers/domain/entities/wallpaper_entity.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/wallpaper_action_bloc/wallpaper_action_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/notifiers/liked_wallpaper_notifier.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/alert_dialog.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/custom_snack_bar.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/custom_text_button.dart';

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
    void setWallpaper(WallpaperEntity wallpaper) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Set Wallpaper for'),
          actions: [
            customTextButton(context, 'Home Screen', () {
              Navigator.pop(context);
              context.read<WallpaperActionBloc>().add(
                SetWallpaper(wallpaper: wallpaper, type: WallpaperType.home),
              );
            }),
            customTextButton(context, 'Lock Screen', () {
              Navigator.pop(context);
              context.read<WallpaperActionBloc>().add(
                SetWallpaper(wallpaper: wallpaper, type: WallpaperType.lock),
              );
            }),
            customTextButton(context, 'Both', () {
              Navigator.pop(context);
              context.read<WallpaperActionBloc>().add(
                SetWallpaper(wallpaper: wallpaper, type: WallpaperType.both),
              );
            }),
          ],
        ),
      );
    }

    return Scaffold(
      body: BlocListener<WallpaperActionBloc, WallpaperActionState>(
        listener: (context, state) {
          if (state is WallpaperSetFailure) {
            customAlertBox(context, state.message);
          }
          if (state is WallpaperSetSuccess) {
            customSnackBar(context, "Wallpaper set successfully!");
          }
          if (state is WallpaperSetFailure) {
            customSnackBar(context, "Could not set Wallpaper!");
          }
        },
        child: CustomScrollView(
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

                    SizedBox(height: 20),

                    // Resolution info
                    Text(
                      '${wallpaper.width} x ${wallpaper.height}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(height: 20),

                    if (wallpaper.likedAt != null)
                      Text(
                        'Liked on: ${DateFormat("hh:mm a, dd MMM, y").format(wallpaper.likedAt!)}',
                      ),
                    if (wallpaper.likedAt != null) SizedBox(height: 20),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child:
                              BlocBuilder<
                                WallpaperActionBloc,
                                WallpaperActionState
                              >(
                                builder: (context, state) {
                                  return SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () => setWallpaper(wallpaper),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: (state is WallpaperSetLoading)
                                          ? Center(
                                              child: SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            )
                                          : Text(
                                              'Set as Wallpaper',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                              ),
                                            ),
                                    ),
                                  );
                                },
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
      ),
    );
  }
}
