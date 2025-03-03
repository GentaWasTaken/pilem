import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/screens/detail_screen.dart';
import 'package:pilem/services/api_services.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResult = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchMovie);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchMovie);
    _searchController.dispose();
    super.dispose();
  }

  void _searchMovie() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResult.clear();
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final List<Map<String, dynamic>> searchData =
      await ApiServices().searchMovie(_searchController.text);
      setState(() {
        _searchResult = searchData.map((e) => Movie.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint("Error fetching search results: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search movies...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
            Expanded(
              child: _searchResult.isEmpty
                  ? const Center(
                child: Text("No movies found."),
              )
                  : ListView.builder(
                itemCount: _searchResult.length,
                itemBuilder: (context, index) {
                  final movie = _searchResult[index];
                  return ListTile(
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
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
