import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_mate/controllers/theme_controller.dart';
import 'package:movie_mate/enums/movie_category_enum.dart';
import 'package:movie_mate/services/tmdp_Service.dart';
import 'package:movie_mate/views/movie_details_screen.dart';
import 'package:movie_mate/views/see_all_movies_screen.dart';
import 'package:movie_mate/widgets/side_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.dashboard),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        title: Text(
          'app_title'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                themeController.toggleTheme();
              },
              icon: Icon(
                themeController.themeMode.value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.wb_sunny,
              ),
            ),
          ),
        ],
      ),
      drawer: SideBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            // 🔹 Trending Movies Carousel
            _buildTrendingMoviesCarousel(theme),

            // 🔹 Movie Sections
            movieSection(
              title: 'top_rated'.tr,
              category: MovieCategory.topRated,
              theme: theme,
            ),
            movieSection(
              title: 'recent_movies'.tr,
              category: MovieCategory.recent,
              theme: theme,
            ),
            movieSection(
              title: 'action'.tr,
              category: MovieCategory.action,
              theme: theme,
            ),
            movieSection(
              title: 'horror'.tr,
              category: MovieCategory.horror,
              theme: theme,
            ),
            movieSection(
              title: 'drama'.tr,
              category: MovieCategory.drama,
              theme: theme,
            ),
            movieSection(
              title: 'romance'.tr,
              category: MovieCategory.romance,
              theme: theme,
            ),
            movieSection(
              title: 'thriller'.tr,
              category: MovieCategory.thriller,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Trending Movies Carousel
  Widget _buildTrendingMoviesCarousel(ThemeData theme) {
    return FutureBuilder(
      future: TMDBService().fetchMovies(MovieCategory.trending),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error loading trending movies"));
        }

        List movies = snapshot.data as List;
        List trendingMovies =
            movies.take(4).toList(); // ✅ Get only top 4 movies

        return SizedBox(
          height: 220, // ✅ Ensure a fixed height
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
            ),
            items:
                trendingMovies.map((movie) {
                  return _buildCarouselMovieCard(movie, theme);
                }).toList(),
          ),
        );
      },
    );
  }

  // 📌 Single Movie Card in Carousel with Rating & Star
  Widget _buildCarouselMovieCard(Map<String, dynamic> movie, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MovieDetailsScreen(movie: movie));
      },
      child: Stack(
        children: [
          // ✅ Movie Backdrop Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500${movie['backdrop_path']}",
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(child: Icon(Icons.broken_image, size: 50)),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  // 📌 Movie Section with Horizontal ListView
  Widget movieSection({
    required String title,
    required MovieCategory category,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            children: [
              Container(width: 5, height: 25, color: theme.colorScheme.primary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Get.to(
                    () => SeeAllMoviesScreen(
                      categoryTitle: title,
                      movieCategory: category,
                    ),
                  );
                },
                label: Text('see_all'.tr),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 🔹 Movie List
        FutureBuilder(
          future: TMDBService().fetchMovies(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error loading movies"));
            }

            List movies = snapshot.data as List;

            return SizedBox(
              height: 300, // ✅ Fixed height for ListView
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return _buildMovieCard(movies[index], theme);
                },
              ),
            );
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  // 📌 Single Movie Card in Horizontal List with Rating
  Widget _buildMovieCard(Map<String, dynamic> movie, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MovieDetailsScreen(movie: movie));
      },
      child: Stack(
        children: [
          // ✅ Movie Poster
          Container(
            width: 150,
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(
                  "https://image.tmdb.org/t/p/w500${movie['poster_path']}",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ⭐ Movie Rating Overlay
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 14),
                  SizedBox(width: 4),
                  Text(
                    movie['vote_average'].toStringAsFixed(1),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
