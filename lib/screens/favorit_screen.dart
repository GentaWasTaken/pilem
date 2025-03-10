import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';
import 'detail_screen.dart';
class FavoritScreen extends StatefulWidget {
  const FavoritScreen({super.key});

  @override
  State<FavoritScreen> createState() => _FavoritScreenState();
}

class _FavoritScreenState extends State<FavoritScreen> {
  List<Movie> _favoriteMovies = [];
  Future<void> _loadFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> favoriteMovieIds = prefs.getKeys().where((m_key) => m_key.startsWith('movie_')).toList();
    setState(() {
      _favoriteMovies = favoriteMovieIds.map((id){
        final String? movieJson = prefs.getString(id);
        if(movieJson != null && movieJson.isNotEmpty) {
          final Map<String, dynamic> movieData = jsonDecode(movieJson);
          return Movie.fromJson(movieData);
        } else{
          return null;
        }
      }).where((movie) => movie != null).cast<Movie>().toList();
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFavoriteMovies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = _favoriteMovies[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Image.network(
                'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                width: 50,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
              title: Text(movie.title),
              subtitle: Text("Rating: ${movie.voteAverage}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailScreen(movie: movie),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
