import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/constants/global_variables.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/bloc/wallpaper_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/alert_dialog.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallapaper_shimmer_card.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<WallpaperBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<WallpaperBloc, WallpaperState>(
        listener: (context, state) {
          if (state is WallpaperError) {
            customAlertBox(context, 'Could not load wallpapers :(');
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('Wallpapers', style: GlobalVariables.titleText),
              backgroundColor: Colors.white,
              surfaceTintColor: null,
              floating: true,
              snap: true,
              scrolledUnderElevation: 0,
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SearchBar(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 20),
                  ),
                  elevation: WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
                  leading: Icon(Icons.search, color: Colors.grey.shade600),
                  hintText: "Search People, Mood, Fashion",
                  hintStyle: WidgetStatePropertyAll(
                    TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 20)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: .start,
                  children: [
                    const Text(
                      'My Favorites',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Spacer(),

                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisSize: .min,
                        children: [
                          const Text(
                            'See all',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 10)),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: BlocBuilder<WallpaperBloc, WallpaperState>(
                  builder: (context, state) {
                    if (state is WallpaperLoading) {
                      // return Center(child: const Text('Abhi data nahi hai :('));
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ListView(
                          scrollDirection: .horizontal,
                          children: [
                            WallpaperShimmerCard(),
                            WallpaperShimmerCard(),
                            WallpaperShimmerCard(),
                            WallpaperShimmerCard(),
                          ],
                        ),
                      );
                    } else if (state is WallpaperLoaded) {
                      final favorites = state.wallpapers;

                      if (favorites.isEmpty) {
                        return const Text('No favorites :(');
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          return WallpaperCard(
                            wallpaper: favorites[index],
                            onTap: () {},
                            onFavoriteTap: () {},
                          );
                        },
                      );
                    } else if (state is WallpaperError) {
                      return Center(child: const Text('Error occured :('));
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 10)),

            BlocBuilder<WallpaperBloc, WallpaperState>(
              builder: (context, state) {
                return WallpaperGrid(
                  wallpapers: [],
                  isLoading: true,
                  onCardTap: null,
                  onFavoriteTap: null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
