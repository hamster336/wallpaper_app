import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/wallpaper_bloc/wallpaper_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/detail_page.dart';
import 'package:mobile_app/features/wallpapers/presentation/widgets/wallpaper_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = TextEditingController();
  bool autoFocus = true;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, size: 22),
                    ),

                    const SizedBox(width: 10),

                    Flexible(
                      child: SearchBar(
                        controller: controller,
                        autoFocus: autoFocus,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            context.read<WallpaperBloc>().add(
                              SearchWallpaper(query: value, page: 1),
                            );
                          }
                        },
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 20),
                        ),
                        elevation: WidgetStatePropertyAll(0),
                        leading: Icon(Icons.search, size: 18),
                        hintText: "Search People, Mood, Fashion",
                        hintStyle: WidgetStatePropertyAll(
                          TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 10)),

            BlocBuilder<WallpaperBloc, WallpaperState>(
              builder: (context, state) {
                if (state is WallpaperLoading) {
                  return WallpaperGrid(
                    wallpapers: null,
                    isLoading: true,
                    onCardTap: null,
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
                    onCardTap: (wallpaper) {
                      // When returning from detail page, set autoFocus to false
                      setState(() => autoFocus = false);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WallpaperDetailPage(
                            wallpaper: wallpaper,
                            likedNotifier: context
                                .read<FavoritesBloc>()
                                .likedNotifier,
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
          ],
        ),
      ),
    );
  }
}
