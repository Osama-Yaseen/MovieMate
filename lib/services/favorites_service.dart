import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // 🔹 Add Movie to Favorites
  Future<void> addToFavorites(Map<String, dynamic> movie) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("favorites")
          .doc(movie['id'].toString())
          .set(movie);
    } catch (e) {
      Get.snackbar('error', "Error adding to favorites");
    }
  }

  // 🔹 Remove Movie from Favorites
  Future<void> removeFromFavorites(int movieId) async {
    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("favorites")
          .doc(movieId.toString())
          .delete();
    } catch (e) {
      Get.snackbar('error', "Error removing from favorites: $e");
    }
  }

  // 🔹 Check if Movie is in Favorites
  Future<bool> isFavorite(int movieId) async {
    var doc =
        await _firestore
            .collection("users")
            .doc(userId)
            .collection("favorites")
            .doc(movieId.toString())
            .get();
    return doc.exists;
  }

  // 🔹 Get User's Favorite Movies
  Stream<List<Map<String, dynamic>>> getFavorites() {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("favorites")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
