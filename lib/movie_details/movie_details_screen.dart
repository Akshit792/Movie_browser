import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/movie_details/bloc/movie_details_bloc.dart';
import 'package:movie_browser/movie_details/bloc/movie_details_event.dart';
import 'package:movie_browser/movie_details/bloc/movie_details_state.dart';
import 'package:movie_browser/navigator/bloc/navigator_bloc.dart';
import 'package:movie_browser/navigator/bloc/navigator_event.dart';
import 'package:movie_browser/utils/models/movie_data_model.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({Key? key}) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieDataModel? movieDetails;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        if (state is InitialMovieDetailsState) {
          _fetchMovieDetails();
        }
        if (state is LoadingMovieDetailsState) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 45, 45, 45),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 2.5,
            ),
          );
        }

        if (state is LoadedMovieDetailsState) {
          movieDetails =
              BlocProvider.of<MovieDetailsBloc>(context).movieDetails;
          return Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
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
                                'https://image.tmdb.org/t/p/original/${movieDetails!.backdropPath}',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25, left: 8),
                        child: IconButton(
                            onPressed: () {
                              BlocProvider.of<NavigatorBloc>(context)
                                  .add(NavigatorActionPop());
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.red,
                              size: 28,
                            )),
                      ),
                    ],
                  ),
                  Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Text(
                        '${movieDetails!.title}'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Release date',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          '${movieDetails!.releaseDate}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Votes',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          '${movieDetails!.voteCount}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      'Plot Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 22),
                    child: Text(
                      '${movieDetails!.overview}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color.fromARGB(255, 45, 45, 45),
            alignment: Alignment.center,
            child: const Text(
              'An Error Occurred',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ));
      },
    );
  }

  void _fetchMovieDetails() {
    BlocProvider.of<MovieDetailsBloc>(context).add(FetchMovieDetailsEvent(
      context: context,
    ));
  }
}
