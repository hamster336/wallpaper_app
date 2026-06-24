import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/bloc/wallpaper_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            scrolledUnderElevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                child: SearchBar(
                  controller: controller,
                  onSubmitted: (value) {
                    context.read<WallpaperBloc>().add(
                      SearchWallpaper(query: value, page: 1),
                    );
                  },
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 20),
                  ),
                  elevation: WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
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
                final wallpapers = state.searchWallpapers;

                // if (wallpapers.isEmpty) {
                //   return SliverToBoxAdapter(
                //     child: Expanded(
                //       child: Center(
                //         child: const Text('No wallpapers found :('),
                //       ),
                //     ),
                //   );
                // }
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
    );
  }
}
