import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:movie_mate/helpers/snackbar_helper.dart';
import 'package:movie_mate/services/tmdp_Service.dart';
import 'package:movie_mate/enums/movie_category_enum.dart';
import 'package:movie_mate/views/movie_details_screen.dart';

class SeeAllMoviesScreen extends StatefulWidget {
  final MovieCategory movieCategory;
  final String categoryTitle;

  const SeeAllMoviesScreen({
    super.key,
    required this.movieCategory,
    required this.categoryTitle,
  });

  @override
  State<SeeAllMoviesScreen> createState() => _SeeAllMoviesScreenState();
}

class _SeeAllMoviesScreenState extends State<SeeAllMoviesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List movies = [];
  List filteredMovies = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchMovies();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMore &&
          !isSearching) {
        fetchMovies();
      }
    });
  }

  // 📌 Fetch Movies from API (instead of just filtering locally)
  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredMovies = List.from(movies); // Reset to original list
      });
      return;
    }

    setState(() {
      isSearching = true;
      isLoading = true;
    });

    try {
      List newMovies = await TMDBService().searchMovies(query);
      setState(() {
        filteredMovies = newMovies;
      });
    } catch (e) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: "search_failed",
        isSuccess: false,
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> fetchMovies() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    try {
      List newMovies = await TMDBService().fetchMovies(
        widget.movieCategory,
        page: currentPage,
      );

      if (newMovies.isEmpty) {
        hasMore = false;
      } else {
        setState(() {
          movies.addAll(newMovies);
          filteredMovies = movies;
          currentPage++;
        });
      }
    } catch (e) {
      SnackbarHelper.showCustomSnackbar(
        title: "error",
        message: "load_more_failed",
        isSuccess: false,
      );
    }

    setState(() => isLoading = false);
  }

  // 📌 Function to Filter Movies Based on Search Query
  void filterMovies(String query) {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredMovies = List.from(movies); // Reset to original movie list
      });
      return;
    }

    setState(() {
      isSearching = true;
      filteredMovies =
          movies
              .where(
                (movie) =>
                    movie['title'].toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged:
                  (query) => _searchMovies(query), // Call API when typing
              decoration: InputDecoration(
                hintText: 'search_movies'.tr,
                prefixIcon: Icon(
                  Icons.search,
                  color: theme.colorScheme.primary,
                ),
                filled: true,
                fillColor: theme.colorScheme.secondaryContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🔹 Movies Grid
          Expanded(
            child:
                filteredMovies.isEmpty && isLoading
                    ? Center(
                      child: SpinKitWave(
                        color: theme.colorScheme.primary,
                        size: 50,
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount:
                            filteredMovies.length +
                            (hasMore && !isSearching ? 1 : 0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, index) {
                          if (index == filteredMovies.length &&
                              hasMore &&
                              !isSearching) {
                            return Center(
                              child: SpinKitThreeBounce(
                                color: theme.colorScheme.primary,
                                size: 20,
                              ),
                            );
                          }
                          return movieGridItem(filteredMovies[index], theme);
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget movieGridItem(Map<String, dynamic> movie, ThemeData theme) {
    String? posterPath = movie['poster_path'];
    String imageUrl =
        posterPath != null
            ? "https://image.tmdb.org/t/p/w500$posterPath"
            : "assets/images/placeholder.jpg"; // Correct asset path

    return InkWell(
      onTap: () {
        Get.to(() => MovieDetailsScreen(movie: movie));
      },
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                posterPath != null
                    ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/placeholder.jpg", // Correct asset image
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      },
                    )
                    : Image.asset(
                      "assets/images/placeholder.jpg", // Load directly from assets
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              movie['title'] ?? "No Title",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
