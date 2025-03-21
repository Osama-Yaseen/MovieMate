import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_mate/controllers/auth_controller.dart';
import 'package:movie_mate/views/favorite_screen.dart';
import 'package:movie_mate/views/language_screen.dart';
import 'package:movie_mate/views/profile_screen.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme colors

    return Drawer(
      backgroundColor:
          theme.colorScheme.secondaryContainer, // Muted Teal background
      child: Column(
        children: [
          // 🔹 Custom Drawer Header (Enhanced)
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 70, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.secondary, // Terracotta Red
                  theme.colorScheme.primary.withValues(
                    alpha: 0.85,
                  ), // Subtle variation
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15), // Rounded bottom for smooth look
              ),
            ),
            child: Column(
              children: [
                // 🔹 Profile Image
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.secondary, // Muted Teal border
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl:
                          AuthController.instance.userData.value.imagePath ??
                          '',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                      placeholder:
                          (context, url) => CircleAvatar(
                            radius: 45,
                            backgroundColor:
                                Colors.grey[300], // Placeholder color
                            child: Icon(
                              Icons.person,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => CircleAvatar(
                            radius: 45,
                            backgroundImage: AssetImage(
                              'assets/images/user_avatar.png',
                            ),
                          ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // 🔹 User Name (Enhanced)
                Text(
                  AuthController.instance.userData.value.userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Sidebar Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildDrawerItem(context, Icons.home, "home".tr, () {
                  Get.back();
                }),
                _buildDrawerItem(context, Icons.person, "profile".tr, () {
                  Get.back();
                  Get.to(() => ProfileScreen());
                }),
                _buildDrawerItem(context, Icons.favorite, "favorites".tr, () {
                  Get.back();
                  Get.to(() => FavoritesScreen());
                }),

                _buildDrawerItem(context, Icons.language, "language".tr, () {
                  Get.back();
                  Get.to(() => LanguageScreen());
                }),

                // Custom Stylish Divider
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.3,
                    ), // Subtle divider
                    thickness: 1.5,
                    height: 25,
                  ),
                ),

                _buildDrawerItem(context, Icons.logout, "logout".tr, () {
                  AuthController.instance.signOut();
                }),
              ],
            ),
          ),

          // Footer Section
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Movie Mate © 2025",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ), // Softer text
                fontSize: 14, // Slightly larger footer text
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create stylish menu items
  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 6.0,
      ), // Adjust padding
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(
              alpha: 0.1,
            ), // Subtle background
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            leading: Icon(
              icon,
              color: theme.colorScheme.primary, // Terracotta Red
              size: 26, // Larger icon
            ),
            title: Text(
              title.tr,
              style: TextStyle(
                color: theme.colorScheme.onSurface, // Dark text
                fontSize: 16, // Larger font
                fontWeight: FontWeight.w600, // Slightly bolder text
                letterSpacing: 0.5, // Elegant spacing
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios, // Arrow for navigation
              color: theme.colorScheme.primary.withValues(
                alpha: 0.7,
              ), // Faded Terracotta Red
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
