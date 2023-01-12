import 'package:json_annotation/json_annotation.dart';

part 'movie_data_model.g.dart';

@JsonSerializable()
class MovieDataModel {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'original_title')
  final String? originalTitle;
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'original_language')
  final String? originalLanguage;
  @JsonKey(name: 'popularity')
  final double? popularity;
  @JsonKey(name: 'overview', includeIfNull: false)
  final String? overview;
  @JsonKey(name: 'release_date', includeIfNull: false)
  final String? releaseDate;
  @JsonKey(name: 'vote_count', includeIfNull: false)
  final int? voteCount;

  MovieDataModel({
    this.backdropPath,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.popularity,
    this.posterPath,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
    this.voteCount,
  });

  factory MovieDataModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDataModelToJson(this);
}
