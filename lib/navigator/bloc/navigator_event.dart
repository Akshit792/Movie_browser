abstract class NavigatorEvent {}

class NavigateToMovieDetailsScreen extends NavigatorEvent {
  final int movieId;
  NavigateToMovieDetailsScreen({required this.movieId});
}

class NavigateToMovieSearchScreen extends NavigatorEvent {}

class NavigatorActionPop extends NavigatorEvent {}
