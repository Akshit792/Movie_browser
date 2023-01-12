// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDataModel _$MovieDataModelFromJson(Map<String, dynamic> json) =>
    MovieDataModel(
      backdropPath: json['backdrop_path'] as String?,
      id: json['id'] as int?,
      originalLanguage: json['original_language'] as String?,
      originalTitle: json['original_title'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      posterPath: json['poster_path'] as String?,
      title: json['title'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      overview: json['overview'] as String?,
      releaseDate: json['release_date'] as String?,
      voteCount: json['vote_count'] as int?,
    );

Map<String, dynamic> _$MovieDataModelToJson(MovieDataModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'backdrop_path': instance.backdropPath,
    'title': instance.title,
    'original_title': instance.originalTitle,
    'vote_average': instance.voteAverage,
    'poster_path': instance.posterPath,
    'original_language': instance.originalLanguage,
    'popularity': instance.popularity,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('overview', instance.overview);
  writeNotNull('release_date', instance.releaseDate);
  writeNotNull('vote_count', instance.voteCount);
  return val;
}
