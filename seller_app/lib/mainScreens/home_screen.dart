import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/model/menus.dart';
import 'package:seller_app/uploadScreens.dart/menus_upload_screen.dart';
import 'package:seller_app/widgets/info_design.dart';
import 'package:seller_app/widgets/my_drower.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:seller_app/widgets/text_widget_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFF90CAF9);

  @override
  Widget build(BuildContext context) {
    final String sellerName =
    sharedPreferences?.getString("name")?.trim().isNotEmpty == true
        ? sharedPreferences!.getString("name")!
        : "FoodHub Seller";

    final String sellerUID =
        sharedPreferences?.getString("uid") ?? "";

    return Scaffold(
      drawer: MyDrawer(),

      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: true,

        flexibleSpace: Container(
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
        ),

        title: Text(
          sellerName,
          style: const TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontFamily: "Lobster",
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MenusUploadScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.post_add,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: sellerUID.isEmpty
          ? const Center(
        child: Text(
          "Seller information not available.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      )
          : CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: TextWidgetHeader(
              title: "My Menus",
            ),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sellerUID)
                .collection("menus")
                .orderBy(
              "publishedDate",
              descending: true,
            )
                .snapshots(),

            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: circularProgress(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "Unable to load menus.\n\n${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 60,
                            color: mediumBlue,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No menus added yet",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Tap the + button to add your first menu.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,

                staggeredTileBuilder: (context) =>
                const StaggeredTile.fit(1),

                itemBuilder: (context, index) {
                  final Map<String, dynamic> data =
                  snapshot.data!.docs[index].data()
                  as Map<String, dynamic>;

                  final Menus model =
                  Menus.fromJson(data);

                  return InfoDesignWidget(
                    model: model,
                    context: context,
                  );
                },

                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ],
      ),
    );
  }
}