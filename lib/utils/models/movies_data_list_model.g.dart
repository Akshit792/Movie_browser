// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_data_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoviesDataListModel _$MoviesDataListModelFromJson(Map<String, dynamic> json) =>
    MoviesDataListModel(
      pageNumber: json['page'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['total_pages'] as int,
      totalResults: json['total_results'] as int,
    );

Map<String, dynamic> _$MoviesDataListModelToJson(
        MoviesDataListModel instance) =>
    <String, dynamic>{
      'page': instance.pageNumber,
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
      'results': instance.results,
    };
