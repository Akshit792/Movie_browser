import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:movie_browser/movie_search/bloc/movie_search_event.dart';
import 'package:movie_browser/movie_search/bloc/movie_search_state.dart';
import 'package:movie_browser/utils/models/movies_data_list_model.dart';
import 'package:movie_browser/utils/repositories/movie_browser_repository.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  MoviesDataListModel? searchedMovies;
  int pageNumber = 1;
  bool canLoadMore = true;

  MovieSearchBloc() : super(InitialMovieSearchState()) {
    on<SearchDataMovieSearchEvent>((event, emit) async {
      try {
        emit(LoadingMovieSearchState());
        await searchMovies(
            context: event.context,
            query: event.query,
            pagenumber: event.pageNumber);
        emit(LoadedMovieDetailsState());
      } catch (e, s) {
        Logger().e('$e Search Data Movie Search Event $s');
      }
    });
  }

  Future<void> searchMovies({
    required BuildContext context,
    required String query,
    int? pagenumber,
  }) async {
    MoviesDataListModel? _searchedMovies;

    var movieBrowserRepo =
        RepositoryProvider.of<MovieBrowserRepository>(context);

    if (query.isNotEmpty && query.trim().isNotEmpty) {
      pageNumber = pagenumber ?? pageNumber;

      _searchedMovies = await movieBrowserRepo.searchMovies(
        query: query,
        pageNumber: pageNumber,
      );

      if (pageNumber == 1) {
        searchedMovies = _searchedMovies;
      }

      if (pageNumber > 1) {
        searchedMovies!.results.addAll(_searchedMovies.results);
      }

      canLoadMore =
          searchedMovies!.totalResults > searchedMovies!.results.length
              ? true
              : false;
    }
  }

  void nextPage() {
    pageNumber = pageNumber + 1;
  }
}
