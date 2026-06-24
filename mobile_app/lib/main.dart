import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/wallpapers/data/datasources/wallpaper_remote_datasoruce.dart';
import 'package:mobile_app/features/wallpapers/data/repositories/wallpaper_repository_impl.dart';
import 'package:mobile_app/features/wallpapers/presentation/blocs/bloc/wallpaper_bloc.dart';
import 'package:mobile_app/features/wallpapers/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wallpaper App',
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
            ),
            colorScheme: .fromSeed(seedColor: Colors.blue),
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
