import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_mate/enums/movie_category_enum.dart';

class TMDBService {
  final String apiKey = "790535f3c38db2b2703ad9d56cde1104";
  final String baseUrl = "https://api.themoviedb.org/3";

  Future<List<dynamic>> fetchMovies(
    MovieCategory category, {
    int page = 1,
  }) async {
    String url = "$baseUrl/movie/popular?api_key=$apiKey&page=$page";

    switch (category) {
      case MovieCategory.topRated:
        url = "$baseUrl/movie/top_rated?api_key=$apiKey&page=$page";
        break;
      case MovieCategory.recent:
        url = "$baseUrl/movie/now_playing?api_key=$apiKey&page=$page";
        break;
      case MovieCategory.trending:
        url = "$baseUrl/trending/movie/week?api_key=$apiKey&page=$page";
        break;
      case MovieCategory.action:
        url =
            "$baseUrl/discover/movie?api_key=$apiKey&with_genres=28&page=$page";
        break;
      case MovieCategory.horror:
        url =
            "$baseUrl/discover/movie?api_key=$apiKey&with_genres=27&page=$page";
        break;
      case MovieCategory.drama:
        url =
            "$baseUrl/discover/movie?api_key=$apiKey&with_genres=18&page=$page";
        break;
      case MovieCategory.romance:
        url =
            "$baseUrl/discover/movie?api_key=$apiKey&with_genres=10749&page=$page";
        break;
      case MovieCategory.thriller:
        url =
            "$baseUrl/discover/movie?api_key=$apiKey&with_genres=53&page=$page";
        break;
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)["results"] ?? [];

      // 🔹 Filter out movies with no poster path
      return data.where((movie) => movie['poster_path'] != null).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }

  // 🔹 Fetch Movie Cast
  Future<List<String>> fetchMovieCast(int movieId) async {
    final url = "$baseUrl/movie/$movieId/credits?api_key=$apiKey";
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200
        ? (json.decode(response.body)['cast'] as List)
            .take(5)
            .map((actor) => actor['name'] as String)
            .toList()
        : [];
  }

  // 🔹 Fetch YouTube Trailer Key
  Future<String?> fetchMovieTrailerKey(int movieId) async {
    final url = "$baseUrl/movie/$movieId/videos?api_key=$apiKey";
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200
        ? (json
            .decode(response.body)["results"]
            .firstWhere(
              (video) =>
                  video['type'] == 'Trailer' && video['site'] == 'YouTube',
              orElse: () => null,
            )?['key'])
        : null;
  }

  Future<String?> fetchTrailer(int movieId) async {
    String url =
        "$baseUrl/movie/$movieId/videos?api_key=$apiKey&language=en-US";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> videos = data["results"];

      var trailer = videos.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );

      return trailer != null
          ? "https://www.youtube.com/watch?v=${trailer['key']}"
          : null;
    } else {
      throw Exception("Failed to load trailer");
    }
  }

  // 🔍 Search Movies on TMDB API
  Future<List<dynamic>> searchMovies(String query, {int page = 1}) async {
    if (query.isEmpty) return [];

    final url =
        "$baseUrl/search/movie?api_key=$apiKey&query=${Uri.encodeComponent(query)}&page=$page";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["results"] ?? [];
    } else {
      throw Exception("Failed to search movies");
    }
  }
}
