import 'dart:async';

import 'package:admin_web_portal/authentication/login.dart';
import 'package:admin_web_portal/orders/order_management_screen.dart';
import 'package:admin_web_portal/riders/all_blocked_riders_screen.dart';
import 'package:admin_web_portal/riders/all_verified_riders_screen.dart';
import 'package:admin_web_portal/sellers/all_Blocked_sellers_screen.dart';
import 'package:admin_web_portal/sellers/all_verified_sellers_screen.dart';
import 'package:admin_web_portal/users/all_blocked_users_screen.dart';
import 'package:admin_web_portal/users/all_verified_users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String timeText = "";
  String dateText = "";

  Timer? _timer;

  // ---------------------------------------------------------
  // TIME
  // ---------------------------------------------------------

  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentDate(DateTime date) {
    return DateFormat("dd MMMM, yyyy").format(date);
  }

  void getCurrentLiveTime() {
    if (!mounted) return;

    final DateTime now = DateTime.now();

    setState(() {
      timeText = formatCurrentLiveTime(now);
      dateText = formatCurrentDate(now);
    });
  }

  // ---------------------------------------------------------
  // INIT
  // ---------------------------------------------------------

  @override
  void initState() {
    super.initState();

    final DateTime now = DateTime.now();

    timeText = formatCurrentLiveTime(now);
    dateText = formatCurrentDate(now);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => getCurrentLiveTime(),
    );
  }

  // ---------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------
  // OPEN PAGE
  // ---------------------------------------------------------

  void openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  // ---------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  // ---------------------------------------------------------
  // DASHBOARD BUTTON
  // ---------------------------------------------------------

  Widget dashboardButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 250,
      height: 125,

      child: ElevatedButton.icon(
        onPressed: onPressed,

        icon: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),

        label: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFE3F2FD),

      appBar: AppBar(
        title: const Text(
          "FoodHub Admin Web Portal",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),

        centerTitle: true,
        elevation: 3,

        backgroundColor:
        Colors.transparent,

        flexibleSpace:
        Container(
          decoration:
          const BoxDecoration(
            gradient:
            LinearGradient(
              colors: [
                Color(0xFF1565C0),
                Color(0xFF42A5F5),
              ],

              begin:
              Alignment.centerLeft,

              end:
              Alignment.centerRight,
            ),
          ),
        ),
      ),

      body: Center(
        child:
        SingleChildScrollView(
          padding:
          const EdgeInsets.all(30),

          child: Column(
            children: [

              // -------------------------------------------------
              // DATE & TIME
              // -------------------------------------------------

              Card(
                elevation: 4,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                    15,
                  ),
                ),

                child:
                Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 20,
                  ),

                  child:
                  Column(
                    children: [

                      const Text(
                        "Admin Dashboard",
                        style:
                        TextStyle(
                          fontSize: 24,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          Color(
                            0xFF1565C0,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        "$timeText\n$dateText",
                        textAlign:
                        TextAlign.center,

                        style:
                        const TextStyle(
                          fontSize: 18,
                          color:
                          Colors.black54,
                          fontWeight:
                          FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 35,
              ),

              // -------------------------------------------------
              // USERS
              // -------------------------------------------------

              Wrap(
                alignment:
                WrapAlignment.center,

                spacing: 20,
                runSpacing: 20,

                children: [

                  dashboardButton(
                    title:
                    "All Verified Users",

                    icon:
                    Icons.people_alt_outlined,

                    color:
                    const Color(
                      0xFF1565C0,
                    ),

                    onPressed: () {
                      openPage(
                        const AllVerifiedUsersScreen(),
                      );
                    },
                  ),

                  dashboardButton(
                    title:
                    "All Blocked Users",

                    icon:
                    Icons.block,

                    color:
                    const Color(
                      0xFF5C6BC0,
                    ),

                    onPressed: () {
                      openPage(
                        const AllBlockedUsersScreen(),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // -------------------------------------------------
              // SELLERS
              // -------------------------------------------------

              Wrap(
                alignment:
                WrapAlignment.center,

                spacing: 20,
                runSpacing: 20,

                children: [

                  dashboardButton(
                    title:
                    "All Verified Sellers",

                    icon:
                    Icons.storefront_outlined,

                    color:
                    const Color(
                      0xFF1976D2,
                    ),

                    onPressed: () {
                      openPage(
                        const AllVerifiedSellersScreen(),
                      );
                    },
                  ),

                  dashboardButton(
                    title:
                    "All Blocked Sellers",

                    icon:
                    Icons.store_mall_directory_outlined,

                    color:
                    const Color(
                      0xFF3949AB,
                    ),

                    onPressed: () {
                      openPage(
                        const AllBlockedSellersScreen(),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // -------------------------------------------------
              // RIDERS
              // -------------------------------------------------

              Wrap(
                alignment:
                WrapAlignment.center,

                spacing: 20,
                runSpacing: 20,

                children: [

                  dashboardButton(
                    title:
                    "All Verified Riders",

                    icon:
                    Icons.delivery_dining,

                    color:
                    const Color(
                      0xFF1565C0,
                    ),

                    onPressed: () {
                      openPage(
                        const AllVerifiedRidersScreen(),
                      );
                    },
                  ),

                  dashboardButton(
                    title:
                    "All Blocked Riders",

                    icon:
                    Icons.no_transfer,

                    color:
                    const Color(
                      0xFF5C6BC0,
                    ),

                    onPressed: () {
                      openPage(
                        const AllBlockedRidersScreen(),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              // -------------------------------------------------
              // ORDERS
              // -------------------------------------------------

              Wrap(
                alignment:
                WrapAlignment.center,

                spacing: 20,
                runSpacing: 20,

                children: [

                  dashboardButton(
                    title:
                    "Order Management",

                    icon:
                    Icons.receipt_long,

                    color:
                    const Color(
                      0xFF1976D2,
                    ),

                    onPressed: () {
                      openPage(
                        const OrderManagementScreen(),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(
                height: 35,
              ),

              // -------------------------------------------------
              // LOGOUT
              // -------------------------------------------------

              SizedBox(
                width: 250,
                height: 55,

                child:
                ElevatedButton.icon(
                  onPressed: logout,

                  icon:
                  const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),

                  label:
                  const Text(
                    "LOGOUT",
                    style:
                    TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight:
                      FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(
                      0xFF1565C0,
                    ),

                    foregroundColor:
                    Colors.white,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}