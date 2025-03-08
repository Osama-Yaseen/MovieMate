import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_mate/services/favorites_service.dart';
import 'package:movie_mate/services/tmdp_Service.dart';
import 'package:movie_mate/services/translation_service.dart';
import 'package:movie_mate/views/trailer_screen.dart';
import 'package:share_plus/share_plus.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  List<String> cast = [];
  bool isLoadingCast = true;
  String? trailerKey;
  bool isLoadingTrailer = true;
  bool isFavorite = false;
  bool isTranslating = false;

  final FavoritesService _favoritesService = FavoritesService();

  String translatedTitle = "";
  String translatedOverview = "";
  List<String> translatedCast = [];

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  void fetchMovieDetails() async {
    await fetchCast(); // 🔹 First, fetch cast
    await fetchMovieTrailer();
    await checkIfFavorite();

    translateContent(); // 🔹 Now translate everything only ONCE
  }

  Future<void> fetchCast() async {
    final fetchedCast = await TMDBService().fetchMovieCast(widget.movie['id']);

    if (mounted) {
      setState(() {
        cast = fetchedCast;
        isLoadingCast = false;
      });
    }
  }

  Future<void> fetchMovieTrailer() async {
    final key = await TMDBService().fetchMovieTrailerKey(widget.movie['id']);
    if (mounted) {
      setState(() {
        trailerKey = key;
        isLoadingTrailer = false;
      });
    }
  }

  Future<void> checkIfFavorite() async {
    bool favoriteStatus = await _favoritesService.isFavorite(
      widget.movie['id'],
    );
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  void toggleFavorite() async {
    if (isFavorite) {
      await _favoritesService.removeFromFavorites(widget.movie['id']);
    } else {
      await _favoritesService.addToFavorites(widget.movie);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void shareMovie() {
    String movieTitle = widget.movie['title'];
    String movieLink = "https://www.themoviedb.org/movie/${widget.movie['id']}";
    Share.share("Check out this movie: $movieTitle\n$movieLink");
  }

  Future<void> translateContent() async {
    if (Get.locale?.languageCode == "ar") {
      setState(() => isTranslating = true);

      try {
        // 🔹 Run all translations in parallel
        final titleFuture = TranslationService.translateText(
          widget.movie['title'],
          "ar",
        );
        final overviewFuture = TranslationService.translateText(
          widget.movie['overview'],
          "ar",
        );
        final castFutures =
            cast
                .map((name) => TranslationService.translateText(name, "ar"))
                .toList();

        // 🔹 Wait for all translations to complete
        final List<dynamic> results = await Future.wait([
          titleFuture,
          overviewFuture,
          ...castFutures, // Spread cast futures directly into the list
        ]);

        setState(() {
          translatedTitle = results[0] as String;
          translatedOverview = results[1] as String;
          translatedCast =
              results.sublist(2).cast<String>(); // Ensure correct type
          isTranslating = false;
        });
      } catch (e) {
        setState(() {
          isTranslating = false;
        });
        debugPrint("Translation failed: $e"); // 🔹 Log the error
      }
    } else {
      // 🔹 Use original content if not Arabic
      translatedTitle = widget.movie['title'];
      translatedOverview = widget.movie['overview'];
      translatedCast = List.from(cast);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String backdropUrl =
        "https://image.tmdb.org/t/p/w780${widget.movie['backdrop_path']}";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isTranslating ? "translating".tr : translatedTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        actions: [
          IconButton(onPressed: shareMovie, icon: Icon(Icons.share)),
          IconButton(
            onPressed: toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 28,
              color:
                  isFavorite
                      ? const Color.fromARGB(255, 240, 111, 79)
                      : theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: backdropUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 350,
              placeholder:
                  (context, url) => Center(
                    child: SpinKitFadingCircle(
                      color: theme.colorScheme.primary,
                      size: 50,
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Image.asset(
                    "assets/images/placeholder.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎥 Watch Trailer Button (Inside Release Date Row)
                  ElevatedButton(
                    onPressed:
                        trailerKey != null
                            ? () => Get.to(
                              () => TrailerScreen(trailerKey: trailerKey!),
                            )
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.8,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 3, // Adds depth to the button
                      shadowColor: const Color.fromARGB(66, 207, 14, 14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.play_circle_fill,
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'watch_trailer'.tr,
                          style: GoogleFonts.nunito(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // 📅 Release Date and ⭐ Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 📅 Release Date
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: theme.colorScheme.primary,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "${'release_date'.tr} ${widget.movie['release_date'] ?? 'Unknown'}",
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),

                      // ⭐ Rating (Under Release Date)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ), // ⭐ Star Icon
                            SizedBox(width: 5),
                            Text(
                              widget.movie['vote_average'].toStringAsFixed(
                                1,
                              ), // 🎬 Movie Rating
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(Icons.description, color: theme.colorScheme.primary),
                      SizedBox(width: 8),
                      Text(
                        "overview".tr,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    isTranslating ? "translating".tr : translatedOverview,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.8,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(Icons.people, color: theme.colorScheme.primary),
                      SizedBox(width: 8),
                      Text(
                        "cast".tr,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  isLoadingCast
                      ? SpinKitThreeBounce(
                        color: theme.colorScheme.primary,
                        size: 20,
                      )
                      : Wrap(
                        spacing: 10,
                        children:
                            (isTranslating
                                    ? cast
                                    : translatedCast.isEmpty
                                    ? cast
                                    : translatedCast)
                                .map(
                                  (actor) => Chip(
                                    shadowColor: theme.colorScheme.primary,
                                    backgroundColor: theme.colorScheme.primary
                                        .withValues(alpha: 0.8),
                                    label: Text(
                                      actor,
                                      style: GoogleFonts.nunito(
                                        color: theme.colorScheme.onPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
