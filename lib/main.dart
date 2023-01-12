import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/all_movies/all_movies_screen.dart';
import 'package:movie_browser/all_movies/bloc/all_movies_bloc.dart';
import 'package:movie_browser/navigator/bloc/navigator_bloc.dart';
import 'package:movie_browser/utils/api_client.dart';
import 'package:movie_browser/utils/models/context_holder.dart';
import 'package:movie_browser/utils/repositories/movie_browser_repository.dart';
import 'package:http/http.dart' as http;

void main() {
  final ApiClient mbApiClient = ApiClient(httpClient: http.Client());
  runApp(RepositoryProvider(
    create: (context) => MovieBrowserRepository(mbApiClient: mbApiClient),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigatorBloc>(
            create: (BuildContext context) => NavigatorBloc(
                  navigatorKey: ContextHolder.key,
                )),
        BlocProvider<AllMoviesBloc>(
          create: (BuildContext context) => AllMoviesBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: ContextHolder.key,
        home: const AllMoviesScreen(),
      ),
    );
  }
}
