import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/model/items.dart';
import 'package:seller_app/uploadScreens.dart/items_upload_screen.dart';
import 'package:seller_app/widgets/items_design.dart';
import 'package:seller_app/widgets/my_drower.dart';
import 'package:seller_app/widgets/progress_bar.dart';

import '../model/menus.dart';
import '../widgets/text_widget_header.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;

  const ItemsScreen({
    super.key,
    this.model,
  });

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
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

    final String? menuId = widget.model?.menuId;

    final String menuTitle =
        widget.model?.menuTitle?.toString() ?? "Menu";

    if (widget.model == null || menuId == null || menuId.isEmpty) {
      return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
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
        ),
        body: const Center(
          child: Text(
            "Menu information is not available.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

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
                  builder: (context) => ItemsUploadScreen(
                    model: widget.model,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.library_add,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: sellerUID.isEmpty
          ? const Center(
        child: Text(
          "Seller information is not available.",
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
              title: "My $menuTitle's Items",
            ),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sellerUID)
                .collection("menus")
                .doc(menuId)
                .collection("items")
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
                        "Unable to load items.\n\n${snapshot.error}",
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
                            Icons.fastfood_outlined,
                            size: 60,
                            color: mediumBlue,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No items added yet",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Tap the + button to add an item.",
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

                  final Items itemModel =
                  Items.fromJson(data);

                  return ItemDesignWidget(
                    model: itemModel,
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