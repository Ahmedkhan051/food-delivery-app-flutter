import 'package:flutter/material.dart';
import 'package:seller_app/authentication/auth_screen.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/earning_screens.dart';
import 'package:seller_app/mainScreens/history_screen.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/mainScreens/new_orders_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF1565C0);
    const Color mediumBlue = Color(0xFF42A5F5);
    const Color lightBlue = Color(0xFF90CAF9);

    final String sellerName =
    sharedPreferences?.getString("name")?.trim().isNotEmpty == true
        ? sharedPreferences!.getString("name")!.trim()
        : "FoodHub Seller";

    final String photoUrl =
        sharedPreferences?.getString("PhotoUrl")?.trim() ?? "";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  lightBlue,
                  mediumBlue,
                  darkBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(80),
                  ),
                  elevation: 8,
                  child: Container(
                    height: 140,
                    width: 140,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ClipOval(
                      child: photoUrl.isNotEmpty
                          ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return const Icon(
                            Icons.person,
                            size: 80,
                            color: mediumBlue,
                          );
                        },
                      )
                          : const Icon(
                        Icons.person,
                        size: 80,
                        color: mediumBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  sellerName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "FoodHub Seller",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          _drawerItem(
            context: context,
            icon: Icons.home,
            title: "Home",
            color: darkBlue,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),

          _drawerDivider(),

          _drawerItem(
            context: context,
            icon: Icons.account_balance_wallet,
            title: "My Earnings",
            color: darkBlue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EarningScreen(),
                ),
              );
            },
          ),

          _drawerDivider(),

          _drawerItem(
            context: context,
            icon: Icons.shopping_bag,
            title: "New Orders",
            color: darkBlue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewOrdersScreen(),
                ),
              );
            },
          ),

          _drawerDivider(),

          _drawerItem(
            context: context,
            icon: Icons.local_shipping,
            title: "Order History",
            color: darkBlue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),

          _drawerDivider(),

          _drawerItem(
            context: context,
            icon: Icons.logout,
            title: "Sign Out",
            color: darkBlue,
            onTap: () async {
              await firebaseAuth.signOut();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
                    (route) => false,
              );
            },
          ),

          _drawerDivider(),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 26,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 2,
      ),
      onTap: onTap,
    );
  }

  Widget _drawerDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFE0E0E0),
    );
  }
}