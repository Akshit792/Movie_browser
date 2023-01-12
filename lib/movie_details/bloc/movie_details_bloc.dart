import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:movie_browser/movie_details/bloc/movie_details_event.dart';
import 'package:movie_browser/movie_details/bloc/movie_details_state.dart';
import 'package:movie_browser/utils/models/movie_data_model.dart';
import 'package:movie_browser/utils/repositories/movie_browser_repository.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final int movieId;
  MovieDataModel? movieDetails;

  MovieDetailsBloc({required this.movieId})
      : super(InitialMovieDetailsState()) {
    on<FetchMovieDetailsEvent>((event, emit) async {
      try {
        emit(LoadingMovieDetailsState());
        final movieBrowserRepo =
            RepositoryProvider.of<MovieBrowserRepository>(event.context);
        movieDetails = await movieBrowserRepo.fetchMovieDetails(id: movieId);
        emit(LoadedMovieDetailsState());
      } catch (e, s) {
        Logger().e('$e Fetch Movie Details Event $s');
      }
    });
  }
}
