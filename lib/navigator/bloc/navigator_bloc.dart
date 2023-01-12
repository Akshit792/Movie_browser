import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/movie_details/bloc/movie_details_bloc.dart';
import 'package:movie_browser/movie_details/movie_details_screen.dart';
import 'package:movie_browser/movie_search/bloc/movie_search_bloc.dart';
import 'package:movie_browser/movie_search/movie_search_screen.dart';
import 'package:movie_browser/navigator/bloc/navigator_event.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorBloc({required this.navigatorKey}) : super(0) {
    on<NavigateToMovieDetailsScreen>((event, emit) {
      _navigatePush(BlocProvider<MovieDetailsBloc>(
        create: (BuildContext context) =>
            MovieDetailsBloc(movieId: event.movieId),
        child: const MovieDetailsScreen(),
      ));
    });
    on<NavigateToMovieSearchScreen>((event, emit) {
      _navigatePush(BlocProvider<MovieSearchBloc>(
        create: (BuildContext context) => MovieSearchBloc(),
        child: const MovieSearchScreen(),
      ));
    });
    on<NavigatorActionPop>((event, emit) {
      _navigatePop();
    });
  }

  _navigatePush(Widget widget) async {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }

  _navigatePop() async {
    navigatorKey.currentState!.pop();
  }
}
