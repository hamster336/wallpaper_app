import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/constants/global_variables.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/bloc/wallpaper_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/search_page.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/alert_dialog.dart';
// import 'package:mobile_app/features/wallpapers/presentation/widgets/wallapaper_shimmer_card.dart';
// import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_card.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = [
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
    context.read<WallpaperBloc>().add(CategoryWallpaper(query: 'trending'));
  }

  void _onTabChange() {
    // Fetch wallpapers based on selected category
    final selectedCategory = categories[_tabController.index];
    context.read<WallpaperBloc>().add(
      CategoryWallpaper(query: selectedCategory.toLowerCase()),
    );
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
            // appBar
            SliverAppBar(
              title: Text('Wallpapers', style: GlobalVariables.titleText),
              backgroundColor: Colors.white,
              surfaceTintColor: null,
              floating: true,
              snap: true,
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
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.grey.shade200,
                      ),
                      leading: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 18,
                      ),
                      hintText: "Search People, Mood, Fashion",
                      hintStyle: WidgetStatePropertyAll(
                        TextStyle(color: Colors.black54, fontSize: 14),
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
                    return Center(child: const Text('Abhi data nahi hai :('));
                    // if (state is WallpaperLoading) {
                    //   return Padding(
                    //     padding: const EdgeInsets.only(right: 10),
                    //     child: ListView(
                    //       scrollDirection: .horizontal,
                    //       children: [
                    //         WallpaperShimmerCard(),
                    //         WallpaperShimmerCard(),
                    //         WallpaperShimmerCard(),
                    //         WallpaperShimmerCard(),
                    //       ],
                    //     ),
                    //   );
                    // } else if (state is WallpaperLoaded) {
                    // final favorites = state.favoriteWallpapers;

                    //   if (favorites.isEmpty) {
                    //     return const Text('No favorites :(');
                    //   }
                    //   return ListView.builder(
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: favorites.length,
                    //     itemBuilder: (context, index) {
                    //       return WallpaperCard(
                    //         wallpaper: favorites[index],
                    //         onTap: () {},
                    //         onFavoriteTap: () {},
                    //       );
                    //     },
                    //   );
                    // } else if (state is WallpaperError) {
                    //   return Center(child: const Text('Error occured :('));
                    // } else {
                    //   return SizedBox.shrink();
                    // }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 10)),

            //
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
                  indicatorWeight: 3,
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
                    onFavoriteTap: null,
                  );
                } else if (state is WallpaperLoaded) {
                  final wallpapers = state.homeWallpapers;

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
                    onCardTap: null,
                    onFavoriteTap: null,
                  );
                } else if (state is WallpaperError) {
                  return SliverToBoxAdapter(
                    child: Center(child: const Text('Error :(')),
                  );
                }

                return SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
