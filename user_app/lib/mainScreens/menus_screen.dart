import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:user_app/models/menus.dart';
import 'package:user_app/widgets/menus_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/text_widget_header.dart';

import '../models/sellers.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;

  const MenusScreen({
    super.key,
    this.model,
  });

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // GET SELECTED RESTAURANT UID
    // ----------------------------------------------------------

    final String sellerUID =
        widget.model?.sellerUID?.trim() ?? '';

    // ----------------------------------------------------------
    // INVALID RESTAURANT
    // ----------------------------------------------------------

    if (sellerUID.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: mediumBlue,
          foregroundColor: Colors.white,
          title: const Text(
            'FoodHub',
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Restaurant information is not available.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // MAIN SCREEN
    // ----------------------------------------------------------

    return Scaffold(
      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: mediumBlue,
        elevation: 3,

        flexibleSpace: Container(
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
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          tooltip: 'Back',
        ),

        title: const Text(
          'FoodHub',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      // ========================================================
      // MENU BODY
      // ========================================================

      body: CustomScrollView(
        slivers: [
          // ----------------------------------------------------
          // RESTAURANT MENU HEADER
          // ----------------------------------------------------

          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              title:
              '${widget.model?.sellerName ?? 'Restaurant'} Menus',
            ),
          ),

          // ----------------------------------------------------
          // LOAD MENU FOR SELECTED RESTAURANT
          // ----------------------------------------------------

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(sellerUID)
                .collection('menus')
                .orderBy(
              'publishedDate',
              descending: true,
            )
                .snapshots(),

            builder: (context, snapshot) {
              // =================================================
              // LOADING
              // =================================================

              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: circularProgress(),
                    ),
                  ),
                );
              }

              // =================================================
              // ERROR
              // =================================================

              if (snapshot.hasError) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'Unable to load menu.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }

              // =================================================
              // NO MENU ITEMS
              // =================================================

              if (!snapshot.hasData ||
                  snapshot.data!.docs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No food items available.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }

              // =================================================
              // MENU LIST
              // =================================================

              return SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,

                staggeredTileBuilder: (context) =>
                const StaggeredTile.fit(1),

                itemCount: snapshot.data!.docs.length,

                itemBuilder: (context, index) {
                  // ------------------------------------------------
                  // CONVERT FIRESTORE DOCUMENT TO MENU MODEL
                  // ------------------------------------------------

                  final Menus menuModel = Menus.fromJson(
                    snapshot.data!.docs[index].data()
                    as Map<String, dynamic>,
                  );

                  // ------------------------------------------------
                  // ASSIGN SELECTED RESTAURANT UID
                  //
                  // The restaurant UID comes from the Sellers
                  // model. Assigning it here ensures that the
                  // correct restaurant ownership is maintained
                  // even if the menu document does not contain
                  // sellerUID.
                  // ------------------------------------------------

                  menuModel.sellerUID = sellerUID;

                  // ------------------------------------------------
                  // MENU DESIGN WIDGET
                  // ------------------------------------------------

                  return MenusDesignWidget(
                    model: menuModel,
                    context: context,
                    sellerUID: sellerUID,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}