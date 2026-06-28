import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/notifiers/liked_wallpaper_notifier.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/detail_page.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_grid.dart';

class FavoritesPage extends StatelessWidget {
  final LikedWallpapersNotifier likedNotifier;

  const FavoritesPage({super.key, required this.likedNotifier});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(weight: 600, color: Colors.red),
            title: Text(
              'Favorites',
              style: TextStyle(
                color: Colors.red.shade600,
                letterSpacing: 0.2,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            surfaceTintColor: null,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            floating: true,
            snap: true,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),

          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state is FavoritesLoading) {
                return WallpaperGrid(
                  wallpapers: [],
                  isLoading: true,
                  onCardTap: null,
                );
              } else if (state is FavoritesLoaded) {
                final favorites = state.favorites;

                if (favorites.isEmpty) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: size.height * 0.8,
                      child: Center(
                        child: const Text('Your favorites will appear here.'),
                      ),
                    ),
                  );
                }
                return WallpaperGrid(
                  wallpapers: favorites,
                  isLoading: false,
                  onCardTap: (wallpaper) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WallpaperDetailPage(
                          wallpaper: wallpaper,
                          likedNotifier: likedNotifier,
                        ),
                      ),
                    );
                  },
                  showLike: false,
                );
              } else if (state is FavoritesError) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: size.height * 0.8,
                    child: Center(child: const Text('Error occured :(')),
                  ),
                );
              } else {
                return SliverToBoxAdapter(child: SizedBox.shrink());
              }
            },
          ),
        ],
      ),
    );
  }
}
