import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/wallpaper_bloc/wallpaper_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/notifiers/liked_wallpaper_notifier.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/detail_page.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/favorites_page.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/search_page.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/alert_dialog.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallapaper_shimmer_card.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late LikedWallpapersNotifier likedNotifier;
  final List<String> categories = [
    'For you',
    'Trending',
    'Abstract',
    'Architecture',
    'Nature',
    'Moody',
    'Space',
    'Dark',
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_onTabChange);

    likedNotifier = context.read<FavoritesBloc>().likedNotifier;
    context.read<WallpaperBloc>().add(CuratedWallpaper());
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  void _onTabChange() {
    final selectedCategory = categories[_tabController.index];
    log(selectedCategory);
    context.read<WallpaperBloc>().add(
      CategoryWallpaper(query: selectedCategory.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<WallpaperBloc, WallpaperState>(
            listenWhen: (previous, current) {
              return previous is! WallpaperError && current is WallpaperError;
            },
            listener: (context, state) {
              if (state is WallpaperError) {
                customAlertBox(context, state.message);
              }
            },
          ),

          BlocListener<FavoritesBloc, FavoritesState>(
            listenWhen: (previous, current) {
              return previous is! FavoritesError && current is FavoritesError;
            },
            listener: (context, state) {
              if (state is FavoritesError) {
                customAlertBox(context, state.message);
              }
            },
          ),
        ],
        child: CustomScrollView(
          slivers: [
            // appBar
            SliverAppBar(
              title: Text(
                'Wallpapers',
                style: TextStyle(
                  color: Colors.red.shade600,
                  letterSpacing: 0.2,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              surfaceTintColor: null,
              floating: true,
              snap: true,
              elevation: 0,
              scrolledUnderElevation: 0,
            ),

            // search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchPage()),
                  ),
                  child: IgnorePointer(
                    child: SearchBar(
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 20),
                      ),
                      elevation: WidgetStatePropertyAll(0),
                      leading: Icon(
                        Icons.search,
                        // color: Colors.grey.shade600,
                        size: 18,
                      ),
                      hintText: "Search People, Mood, Fashion",
                      hintStyle: WidgetStatePropertyAll(
                        TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 10)),

            // favorite wallpapers
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FavoritesPage(likedNotifier: likedNotifier),
                        ),
                      ),
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
                child: BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    if (state is FavoritesLoading) {
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
                    } else if (state is FavoritesLoaded) {
                      final favorites = state.favorites;

                      if (favorites.isEmpty) {
                        return Center(
                          child: const Text('Your favorites will appear here.'),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.only(right: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: (favorites.length <= 5)
                            ? favorites.length
                            : 6,
                        itemBuilder: (context, index) {
                          if (index == 5) {
                            return Container(
                              margin: EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: Colors.white,
                              ),
                            );
                          }

                          final favorite = favorites[index];
                          return WallpaperCard(
                            wallpaper: favorite,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WallpaperDetailPage(
                                  wallpaper: favorite,
                                  likedNotifier: likedNotifier,
                                ),
                              ),
                            ),
                            likedNotifier: likedNotifier,
                            showLike: false,
                          );
                        },
                      );
                    } else if (state is FavoritesError) {
                      return Center(child: const Text('Error occured :('));
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 10)),

            // tab Bar
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                padding: .zero,
                scrollDirection: .horizontal,
                child: TabBar(
                  controller: _tabController,
                  dividerHeight: 0,
                  dividerColor: null,
                  isScrollable: true,
                  indicatorColor: Colors.red,
                  indicatorWeight: 2,
                  indicatorAnimation: TabIndicatorAnimation.elastic,
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  tabs: categories.map((c) => Tab(text: c)).toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 10)),

            BlocBuilder<WallpaperBloc, WallpaperState>(
              builder: (context, state) {
                if (state is WallpaperLoading) {
                  return WallpaperGrid(
                    wallpapers: [],
                    isLoading: true,
                    onCardTap: null,
                  );
                } else if (state is WallpaperLoaded) {
                  final wallpapers = state.categoryWallpapers;

                  if (wallpapers.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: const Text('No wallpapers found :('),
                      ),
                    );
                  }
                  return WallpaperGrid(
                    wallpapers: wallpapers,
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
                  );
                } else if (state is WallpaperError) {
                  return SliverToBoxAdapter(
                    child: Center(child: const Text('Error :(')),
                  );
                }

                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),

            BlocBuilder<WallpaperBloc, WallpaperState>(
              builder: (context, state) {
                if (state is WallpaperLoaded &&
                    state.categoryWallpapers.isNotEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: const Text(
                        'Explore more using the search bar....',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 10)),
          ],
        ),
      ),
    );
  }
}
