import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loadmore/loadmore.dart';
import 'package:movie_browser/movie_search/bloc/movie_search_bloc.dart';
import 'package:movie_browser/movie_search/bloc/movie_search_event.dart';
import 'package:movie_browser/movie_search/bloc/movie_search_state.dart';
import 'package:movie_browser/navigator/bloc/navigator_bloc.dart';
import 'package:movie_browser/navigator/bloc/navigator_event.dart';
import 'package:movie_browser/utils/models/debouncer.dart';
import 'package:movie_browser/utils/models/movie_data_model.dart';
import 'package:movie_browser/utils/models/prefil_text_editing_controller.dart';
import 'package:movie_browser/utils/widgets/load_more_delegate.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({Key? key}) : super(key: key);

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  List<MovieDataModel> searchedMovies = [];
  String searchText = '';
  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            autofocus: false,
            controller: PrefilTextEditingController.from(
              searchText,
            ),
            onChanged: (text) {
              searchText = text;
              _debouncer.run(
                () {
                  _searchedMovies();
                },
              );
            },
            textAlignVertical: TextAlignVertical.center,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(4),
              ),
              isDense: true,
              isCollapsed: true,
              filled: true,
              fillColor: Colors.grey,
              hintText: "Search Movies...",
              hintStyle: const TextStyle(
                color: Colors.white,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MovieSearchBloc, MovieSearchState>(
          builder: (context, state) {
        if (state is LoadingMovieSearchState) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 2.5,
            ),
          );
        }

        if (state is LoadedMovieDetailsState ||
            state is InitialMovieSearchState) {
          var movieSearchBloc = BlocProvider.of<MovieSearchBloc>(context);

          if (movieSearchBloc.searchedMovies != null) {
            searchedMovies = movieSearchBloc.searchedMovies!.results;
          }

          if (searchedMovies.isNotEmpty) {
            return LoadMore(
              onLoadMore: _loadMoreSearchMovies,
              delegate: MbLoadMoreDelegate(),
              isFinish:
                  !(BlocProvider.of<MovieSearchBloc>(context).canLoadMore),
              child: ListView.builder(
                  itemCount: searchedMovies.length,
                  itemBuilder: (context, index) {
                    return buildSearchedMovieItem(
                        movieDetails: searchedMovies[index]);
                  }),
            );
          } else {
            return Container(
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Type in the search box to search movies.....',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
        }

        return Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text(
            'An Error Ocuured',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }

  Widget buildSearchedMovieItem({required MovieDataModel movieDetails}) {
    return InkWell(
      onTap: () {
        BlocProvider.of<NavigatorBloc>(context)
            .add(NavigateToMovieDetailsScreen(movieId: movieDetails.id!));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FadeInImage.assetNetwork(
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder_image.jpeg',
                      fit: BoxFit.fill,
                    );
                  },
                  placeholder: 'assets/images/placeholder_image.jpeg',
                  image:
                      'https://image.tmdb.org/t/p/original/${movieDetails.backdropPath}',
                  fit: BoxFit.fill,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white, width: 2)),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${movieDetails.title}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Plot summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${movieDetails.overview}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey[400]!),
          color: Colors.grey[200],
        ),
      ),
    );
  }

  void _searchedMovies() {
    BlocProvider.of<MovieSearchBloc>(context).add(SearchDataMovieSearchEvent(
        context: context, query: searchText, pageNumber: 1));
  }

  Future<bool> _loadMoreSearchMovies() async {
    var movieSearchBloc = BlocProvider.of<MovieSearchBloc>(context);
    if (movieSearchBloc.canLoadMore) {
      movieSearchBloc.nextPage();
      await movieSearchBloc.searchMovies(context: context, query: searchText);
      if (mounted) setState(() {});
      return true;
    }
    return false;
  }
}
