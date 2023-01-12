import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/all_movies/bloc/all_movies_bloc.dart';
import 'package:movie_browser/all_movies/bloc/all_movies_event.dart';
import 'package:movie_browser/all_movies/bloc/all_movies_state.dart';
import 'package:movie_browser/navigator/bloc/navigator_bloc.dart';
import 'package:movie_browser/navigator/bloc/navigator_event.dart';
import 'package:movie_browser/utils/models/movie_data_model.dart';
import 'package:loadmore/loadmore.dart';
import 'package:movie_browser/utils/repositories/movie_browser_repository.dart';
import 'package:movie_browser/utils/widgets/load_more_delegate.dart';

class AllMoviesScreen extends StatefulWidget {
  const AllMoviesScreen({Key? key}) : super(key: key);

  @override
  State<AllMoviesScreen> createState() => _AllMoviesScreenState();
}

class _AllMoviesScreenState extends State<AllMoviesScreen> {
  String filterType = 'now_playing';
  final List<String> movieFilter = [
    'now_playing',
    'popular',
    'top_rated',
    'upcoming'
  ];
  List<MovieDataModel> allMovies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 45, 45, 45),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'All Movies',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<NavigatorBloc>(context)
                    .add(NavigateToMovieSearchScreen());
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                showMovieFilterBottomSheet();
              },
              icon: const Icon(Icons.filter_list))
        ],
      ),
      body:
          BlocBuilder<AllMoviesBloc, AllMoviesState>(builder: (context, state) {
        if (state is InitialAllMoviesState) {
          _fetchMovies();
        }
        if (state is LoadingAllMoviesState) {
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
        if (state is LoadedAllMoviesState) {
          allMovies =
              BlocProvider.of<AllMoviesBloc>(context).allMovies!.results;
          return LoadMore(
            onLoadMore: _loadMoreMovies,
            delegate: MbLoadMoreDelegate(),
            isFinish: !(BlocProvider.of<AllMoviesBloc>(context).canLoadMore),
            child: ListView(
              children: [
                // load more does not supports grid view
                GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding:
                        const EdgeInsets.only(left: 10, top: 15, right: 10),
                    crossAxisCount: 3,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 20.0,
                    childAspectRatio: 2 / 3.2,
                    children: List.generate(allMovies.length, (index) {
                      return buildgridViewItem(
                          context: context, movieData: allMovies[index]);
                    })),
              ],
            ),
          );
        }
        return Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text('An Error Occurred.....'),
        );
      }),
    );
  }

  Widget buildgridViewItem(
      {required BuildContext context, required MovieDataModel movieData}) {
    return Column(children: [
      InkWell(
        onTap: () {
          BlocProvider.of<NavigatorBloc>(context)
              .add(NavigateToMovieDetailsScreen(movieId: movieData.id!));
        },
        child: Container(
          height: 140,
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
                  'https://image.tmdb.org/t/p/original/${movieData.backdropPath}',
              fit: BoxFit.fill,
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.white, width: 2)),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                '${movieData.title} ',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      )
    ]);
  }

  void showMovieFilterBottomSheet() {
    showModalBottomSheet(
        backgroundColor: const Color.fromARGB(255, 45, 45, 45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        context: context,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              bottomSheetTopDivider(context),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                child: const Text(
                  'SELECT MOVIE FILTER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // all filters
              for (String filter in movieFilter)
                InkWell(
                  onTap: () {
                    filterType = filter;
                    _fetchMovies();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      filter.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        color: filter == filterType ? Colors.red : Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color:
                              filter == filterType ? Colors.red : Colors.white,
                        )),
                  ),
                ),
            ],
          );
        });
  }

  Widget bottomSheetTopDivider(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        height: 5.0,
        width: 50,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(2.5),
            bottomRight: Radius.circular(2.5),
            topLeft: Radius.circular(2.5),
            topRight: Radius.circular(2.5),
          ),
        ),
      ),
    );
  }

  Future<bool> _loadMoreMovies() async {
    final movieBrowserRepo =
        RepositoryProvider.of<MovieBrowserRepository>(context);
    final allMoviesBloc = BlocProvider.of<AllMoviesBloc>(context);
    if (allMoviesBloc.canLoadMore) {
      allMoviesBloc.nextPage();
      await allMoviesBloc.fetchMovies(
          movieBrowserRepo: movieBrowserRepo,
          filterType: filterType,
          pagenumber: null);
      if (mounted) setState(() {});
      return true;
    }
    return false;
  }

  void _fetchMovies() {
    BlocProvider.of<AllMoviesBloc>(context).add(FetchAllMoviesDataEvent(
      context: context,
      filterType: filterType,
      pageNumber: 1,
    ));
  }
}
