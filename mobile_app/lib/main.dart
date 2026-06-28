import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/wallpapers/data/datasources/favorites_local_storage.dart';
import 'package:mobile_app/features/wallpapers/data/datasources/wallpaper_remote_datasoruce.dart';
import 'package:mobile_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/wallpaper_bloc/wallpaper_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/notifiers/liked_wallpaper_notifier.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([.portraitUp]);

  await FavoritesServices.init();

  final likedNotifier = LikedWallpapersNotifier();
  
  // Load all liked wallpapers into notifier at startup
  final favorites = await FavoritesServices.getAllLiked();
  likedNotifier.value = {for (var fav in favorites) fav.id};

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final likedNotifier = LikedWallpapersNotifier();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => WallpaperRepositoryImpl(
            remoteDataSource: WallpaperRemoteDataSourceImpl(
              httpClient: http.Client(),
            ),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                WallpaperBloc(repo: context.read<WallpaperRepositoryImpl>()),
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(
              repo: context.read<WallpaperRepositoryImpl>(),
              likedNotifier: likedNotifier,
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wallpaper App',
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: .fromSeed(seedColor: Colors.blue),
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
