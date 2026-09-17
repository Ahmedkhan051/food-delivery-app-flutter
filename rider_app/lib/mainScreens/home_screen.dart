import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:rider_app/global/global.dart';
import 'package:rider_app/mainScreens/earning_screens.dart';
import 'package:rider_app/mainScreens/history_screen.dart';
import 'package:rider_app/mainScreens/new_orders_screen.dart';
import 'package:rider_app/mainScreens/not_yet_delivered_screen.dart';
import 'package:rider_app/mainScreens/parcel_in_progress.dart';

import '../../authentication/auth_screen.dart';
import '../assistant_methods/get_current_location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  // ---------------------------------------------------------
  // GET RIDER UID
  // ---------------------------------------------------------

  String? get riderUID {
    return firebaseAuth.currentUser?.uid ??
        sharedPreferences?.getString("uid");
  }

  // ---------------------------------------------------------
  // GET RIDER NAME
  // ---------------------------------------------------------

  String get riderName {
    return sharedPreferences?.getString("name") ??
        firebaseAuth.currentUser?.displayName ??
        "Rider";
  }

  // ---------------------------------------------------------
  // LOAD RIDER DATA
  // ---------------------------------------------------------

  Future<void> loadRiderData() async {
    try {
      final String? uid = riderUID;

      if (uid == null || uid.isEmpty) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        return;
      }

      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection("riders")
          .doc(uid)
          .get();

      if (snapshot.exists) {
        final Map<String, dynamic> data = snapshot.data() ?? {};

        final dynamic earnings = data["earnings"];

        if (earnings != null) {
          previousRidersEarnings = earnings.toString();
        }
      }

      await getPerParcelDeliveryAmount();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ---------------------------------------------------------
  // GET DELIVERY AMOUNT
  // ---------------------------------------------------------

  Future<void> getPerParcelDeliveryAmount() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection("perDelivery")
          .doc("alizeb438")
          .get();

      if (snapshot.exists) {
        final Map<String, dynamic> data = snapshot.data() ?? {};

        final dynamic amount = data["amount"];

        if (amount != null) {
          perParcelDeliveryAmount = amount.toString();
        }
      }
    } catch (_) {
      // Keep existing/default value.
    }
  }

  // ---------------------------------------------------------
  // UPDATE RIDER LOCATION
  // ---------------------------------------------------------

  Future<void> updateRiderLocation() async {
    final UserLocation userLocation = UserLocation();

    final bool success =
    await userLocation.getCurrentLocation();

    if (!mounted) return;

    if (success && position != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Rider location updated successfully.",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to update location. "
                "Please enable GPS permission.",
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------

  Future<void> _logout() async {
    await firebaseAuth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthScreen(),
      ),
          (route) => false,
    );
  }

  // ---------------------------------------------------------
  // OPEN DRAWER SCREEN
  // ---------------------------------------------------------

  void openDrawerScreen(Widget screen) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  // ---------------------------------------------------------
  // DRAWER ITEM
  // ---------------------------------------------------------

  Widget buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: danger
            ? Colors.red
            : const Color(0xFF1565C0),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: danger
              ? Colors.red
              : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

  // ---------------------------------------------------------
  // DASHBOARD CARD
  // ---------------------------------------------------------

  Widget makeDashboardItems(
      String title,
      IconData iconData,
      int index,
      ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NewOrdersScreen(),
                ),
              );
              break;

            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ParcelInProgress(),
                ),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                  const NotYetDeliveredScreen(),
                ),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
              break;

            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EarningScreen(),
                ),
              );
              break;

            case 5:
              _logout();
              break;
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1565C0),
                Color(0xFF42A5F5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 42,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // INIT
  // ---------------------------------------------------------

  @override
  void initState() {
    super.initState();

    final UserLocation userLocation =
    UserLocation();

    userLocation.getCurrentLocation();

    loadRiderData();
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ======================================================
      // DRAWER
      // ======================================================

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [

              // ------------------------------------------------
              // DRAWER HEADER
              // ------------------------------------------------

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  30,
                  20,
                  25,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF42A5F5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.delivery_dining,
                        size: 45,
                        color: Color(0xFF1565C0),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      riderName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      "FoodHub Rider",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // DRAWER MENU
              // ------------------------------------------------

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [

                    buildDrawerItem(
                      icon: Icons.home,
                      title: "Home",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    buildDrawerItem(
                      icon: Icons.assignment,
                      title: "New Available Orders",
                      onTap: () {
                        openDrawerScreen(
                          const NewOrdersScreen(),
                        );
                      },
                    ),

                    buildDrawerItem(
                      icon: Icons.local_shipping,
                      title: "Parcel in Progress",
                      onTap: () {
                        openDrawerScreen(
                          const ParcelInProgress(),
                        );
                      },
                    ),

                    buildDrawerItem(
                      icon: Icons.location_on,
                      title: "To Be Delivered",
                      onTap: () {
                        openDrawerScreen(
                          const NotYetDeliveredScreen(),
                        );
                      },
                    ),

                    const Divider(),

                    buildDrawerItem(
                      icon: Icons.history,
                      title: "Order History",
                      onTap: () {
                        openDrawerScreen(
                          const HistoryScreen(),
                        );
                      },
                    ),

                    buildDrawerItem(
                      icon: Icons.account_balance_wallet,
                      title: "Earnings",
                      onTap: () {
                        openDrawerScreen(
                          const EarningScreen(),
                        );
                      },
                    ),

                    buildDrawerItem(
                      icon: Icons.my_location,
                      title: "Update My Location",
                      onTap: () async {
                        Navigator.pop(context);
                        await updateRiderLocation();
                      },
                    ),

                    const Divider(),

                    buildDrawerItem(
                      icon: Icons.logout,
                      title: "Logout",
                      danger: true,
                      onTap: _logout,
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // DRAWER FOOTER
              // ------------------------------------------------

              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "FoodHub Rider",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1565C0),
                Color(0xFF42A5F5),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),

        title: Text(
          "Welcome $riderName",
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE3F2FD),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1565C0),
          ),
        )
            : GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,

          children: [
            makeDashboardItems(
              "New Available Orders",
              Icons.assignment,
              0,
            ),

            makeDashboardItems(
              "Parcel in Progress",
              Icons.local_shipping,
              1,
            ),

            makeDashboardItems(
              "Not Yet Delivered",
              Icons.location_on,
              2,
            ),

            makeDashboardItems(
              "History",
              Icons.history,
              3,
            ),

            makeDashboardItems(
              "Total Earnings",
              Icons.account_balance_wallet,
              4,
            ),

            makeDashboardItems(
              "Logout",
              Icons.logout,
              5,
            ),
          ],
        ),
      ),
    );
  }
}