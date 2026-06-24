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
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                bottom: 2,
              ), // ← Reduce padding
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: 22),
              ),
            ),
            leadingWidth: 40,
            title: Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 2),
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
                leading: Icon(Icons.search, size: 18),
                hintText: "Search People, Mood, Fashion",
                hintStyle: WidgetStatePropertyAll(TextStyle(fontSize: 14)),
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

                if (wallpapers.isEmpty && state.searched) {
                  return SliverToBoxAdapter(
                    child: Expanded(
                      child: Center(
                        child: const Text('No wallpapers found :('),
                      ),
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
    );
  }
}
