import 'package:flutter/material.dart';

abstract class MovieDetailsEvent {}

class FetchMovieDetailsEvent extends MovieDetailsEvent {
  final BuildContext context;

  FetchMovieDetailsEvent({
    required this.context,
  });
}
