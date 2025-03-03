import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pilem/services/api_services.dart';

import '../models/movie.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _allMovies = [], _trendingMovie = [], _popularMovie = [];

  Future<void> _loadMovie() async {
    final List<Map<String, dynamic>> allMovieData =
        await ApiServices().getAllMovie();
    final List<Map<String, dynamic>> allTrendingData =
        await ApiServices().getAllMovie();
    final List<Map<String, dynamic>> allPopularData =
        await ApiServices().getAllMovie();

    setState(() {
      _allMovies = allMovieData.map((e) => Movie.fromJson(e)).toList();
      _trendingMovie = allTrendingData.map((e) => Movie.fromJson(e)).toList();
      _popularMovie = allPopularData.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMovie();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilem"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMovieList("All movies", _allMovies),
            _buildMovieList("Popular", _popularMovie),
            _buildMovieList("Trending", _trendingMovie),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext ctx, int idx) {
              final Movie movie = movies[idx];

              return GestureDetector(
                onTap: () {
                  // Handle movie tap (e.g., navigate to details page)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        width: 100,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.title.length > 14
                            ? '${movie.title.substring(0, 10)}...'
                            : movie.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }


}
