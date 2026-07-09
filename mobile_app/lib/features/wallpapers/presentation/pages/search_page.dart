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
  final _textController = TextEditingController(); // for the search field
  final _scrollController =
      ScrollController(); // to track the screen postion for pagination
  final FocusNode focusNode = FocusNode(); // search bar focuNode
  late WallpaperBloc _wallpaperBloc;
  String searchQuery = ''; // to track the search query for pagination
  DateTime? _lastLoadMoreTime; // track last load time
  static const Duration _loadMoreDelay = Duration(
    seconds: 5,
  ); // mimimum delay of 5 seconds between each load more wallpapers request.

  @override
  void initState() {
    _wallpaperBloc = context.read<WallpaperBloc>();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _wallpaperBloc.add(ClearSearch());
    _textController.dispose();
    _scrollController.dispose();
  }

  void _onScroll() {
    final state = _wallpaperBloc.state;

    if (state is WallpaperLoaded && state.isLoadingMore) return;
    if (state is WallpaperLoaded && state.hasReachedMax) return;

    final now = DateTime.now();
    if (_lastLoadMoreTime != null &&
        now.difference(_lastLoadMoreTime!) < _loadMoreDelay) {
      return; // do not request load more if the last request was made less than _loadMoreDelay
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _lastLoadMoreTime = now; // record the time for the last load more request
      _wallpaperBloc.add(SearchWallpaperLoadMore(query: searchQuery));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
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
                        focusNode: focusNode,
                        controller: _textController,
                        autoFocus: true,
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            searchQuery = value.trim();
                            _wallpaperBloc.add(SearchWallpaper(query: value));
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
                    // show no wallpapers only if user searches
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
                      // When returning from detail page, remvove focus from search bar
                      focusNode.unfocus();

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

            BlocBuilder<WallpaperBloc, WallpaperState>(
              builder: (context, state) {
                if (state is WallpaperLoaded && state.isLoadingMore) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          width: 35,
                          height: 35,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
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
