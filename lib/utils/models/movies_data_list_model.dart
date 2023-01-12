import 'package:json_annotation/json_annotation.dart';
import 'package:movie_browser/utils/models/movie_data_model.dart';

part 'movies_data_list_model.g.dart';

@JsonSerializable()
class MoviesDataListModel {
  @JsonKey(name: 'page')
  final int pageNumber;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;
  @JsonKey(name: 'results')
  final List<MovieDataModel> results;

  MoviesDataListModel({
    required this.pageNumber,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MoviesDataListModel.fromJson(Map<String, dynamic> json) =>
      _$MoviesDataListModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoviesDataListModelToJson(this);
}
