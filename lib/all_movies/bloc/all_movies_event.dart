import 'package:flutter/material.dart';

abstract class AllMoviesEvent {}

class FetchAllMoviesDataEvent extends AllMoviesEvent {
  final BuildContext context;
  final String filterType;
  final int? pageNumber;

  FetchAllMoviesDataEvent({
    required this.context,
    required this.filterType,
    this.pageNumber,
  });
}
