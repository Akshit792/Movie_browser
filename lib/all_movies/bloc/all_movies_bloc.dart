import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:movie_browser/all_movies/bloc/all_movies_event.dart';
import 'package:movie_browser/all_movies/bloc/all_movies_state.dart';
import 'package:movie_browser/utils/models/movies_data_list_model.dart';
import 'package:movie_browser/utils/repositories/movie_browser_repository.dart';

class AllMoviesBloc extends Bloc<AllMoviesEvent, AllMoviesState> {
  MoviesDataListModel? allMovies;
  bool canLoadMore = true;
  int pageNumber = 1;

  AllMoviesBloc() : super(InitialAllMoviesState()) {
    on<FetchAllMoviesDataEvent>((event, emit) async {
      try {
        emit(LoadingAllMoviesState());
        final movieBrowserRepo =
            RepositoryProvider.of<MovieBrowserRepository>(event.context);
        await fetchMovies(
            movieBrowserRepo: movieBrowserRepo,
            filterType: event.filterType,
            pagenumber: event.pageNumber);
        emit(LoadedAllMoviesState());
      } catch (e, s) {
        Logger().e('$e Fetch All Movies Data Event $s');
      }
    });
  }

  Future<void> fetchMovies(
      {required MovieBrowserRepository movieBrowserRepo,
      required String filterType,
      required int? pagenumber}) async {
    pageNumber = pagenumber ?? pageNumber;

    MoviesDataListModel? _allMovies;
    _allMovies = await movieBrowserRepo.fetchAllMovies(
      filterType: filterType,
      pageNumber: pageNumber,
    );

    if (pageNumber == 1) {
      allMovies = _allMovies;
    }
    if (pageNumber > 1) {
      allMovies!.results.addAll(_allMovies.results);
    }

    canLoadMore =
        allMovies!.totalResults > allMovies!.results.length ? true : false;
  }

  void nextPage() {
    pageNumber = pageNumber + 1;
  }
}
