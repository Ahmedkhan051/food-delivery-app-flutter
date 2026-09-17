import 'package:flutter/material.dart';
import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/mainScreens/address_screen.dart';
import 'package:user_app/mainScreens/history_screen.dart';
import 'package:user_app/mainScreens/home_screen.dart';
import 'package:user_app/mainScreens/my_orders_screen.dart';
import 'package:user_app/mainScreens/search_screen.dart';
import 'package:user_app/notifications/notifications_screen.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    final String userName =
        sharedPreferences?.getString("name") ?? "FoodHub User";

    final String userPhoto =
        sharedPreferences?.getString("photo") ?? "";

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                15,
                15,
                15,
                18,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF90CAF9),
                    Color(0xFF42A5F5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      tooltip: "Close",
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.white,
                      backgroundImage: userPhoto.isNotEmpty
                          ? NetworkImage(userPhoto)
                          : null,
                      child: userPhoto.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 58,
                              color: Color(0xFF42A5F5),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  const Text(
                    "Welcome to FoodHub",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.home_outlined,
                    title: "Home",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HomeScreen(),
                        ),
                      );
                    },
                  ),

                  _buildDrawerItem(
                    context: context,
                    icon: Icons.receipt_long_outlined,
                    title: "My Orders",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyOrdersScreen(),
                        ),
                      );
                    },
                  ),

                  _buildDrawerItem(
                    context: context,
                    icon: Icons.history,
                    title: "History",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const HistoryScreen(),
                        ),
                      );
                    },
                  ),

                  // Notifications
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotificationsScreen(),
                        ),
                      );
                    },
                  ),

                  _buildDrawerItem(
                    context: context,
                    icon: Icons.search,
                    title: "Search",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SearchScreen(),
                        ),
                      );
                    },
                  ),

                  _buildDrawerItem(
                    context: context,
                    icon: Icons.location_on_outlined,
                    title: "Add New Address",
                    onTap: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AddressScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  const Divider(
                    thickness: 1,
                    color: Colors.black12,
                  ),

                  const SizedBox(height: 5),

                  _buildDrawerItem(
                    context: context,
                    icon: Icons.logout,
                    title: "Sign Out",
                    iconColor: Colors.redAccent,
                    titleColor: Colors.redAccent,
                    onTap: () async {
                      try {
                        await firebaseAuth.signOut();
                      } catch (error) {
                        debugPrint(
                          "Firebase sign out error: $error",
                        );
                      }

                      if (sharedPreferences != null) {
                        await sharedPreferences!.setBool(
                          "isLoggedIn",
                          false,
                        );
                      }

                      if (!context.mounted) return;

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AuthScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      "FoodHub",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = darkBlue,
    Color titleColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 27,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}