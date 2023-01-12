import 'package:movie_browser/utils/api_client.dart';
import 'package:movie_browser/utils/models/movie_data_model.dart';
import 'package:movie_browser/utils/models/movies_data_list_model.dart';

class MovieBrowserRepository {
  final ApiClient mbApiClient;
  final String apiKey = '751201b224832a3ee1c3b0327a5096f5';

  Future<MoviesDataListModel> fetchAllMovies({
    required String filterType,
    required int pageNumber,
  }) async {
    final MoviesDataListModel movies;
    var response =
        await mbApiClient.getResource('movie/$filterType', queryParams: {
      'api_key': apiKey,
      'page': pageNumber.toString(),
    });
    movies = MoviesDataListModel.fromJson(response);
    return movies;
  }

  Future<MovieDataModel> fetchMovieDetails({required int id}) async {
    final MovieDataModel? movieDetails;
    var response = await mbApiClient.getResource('movie/$id', queryParams: {
      'api_key': apiKey,
    });
    movieDetails = MovieDataModel.fromJson(response);
    return movieDetails;
  }

  Future<MoviesDataListModel> searchMovies({
    required String query,
    required int pageNumber,
  }) async {
    MoviesDataListModel? searchedMovies;
    var response = await mbApiClient.getResource('/search/movie', queryParams: {
      'api_key': apiKey,
      'query': query,
      'page': pageNumber.toString()
    });
    searchedMovies = MoviesDataListModel.fromJson(response);
    return searchedMovies;
  }

  MovieBrowserRepository({required this.mbApiClient});
}
