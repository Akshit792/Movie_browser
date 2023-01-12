import 'package:flutter/material.dart';

abstract class MovieSearchEvent {}

class SearchDataMovieSearchEvent extends MovieSearchEvent {
  final BuildContext context;
  final String query;
  final int pageNumber;

  SearchDataMovieSearchEvent({
    required this.context,
    required this.query,
    required this.pageNumber,
  });
}
