import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:user_app/models/items.dart';
import 'package:user_app/models/menus.dart';
import 'package:user_app/widgets/app_bar.dart';
import 'package:user_app/widgets/items_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/text_widget_header.dart';

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
  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // GET RESTAURANT UID
    // ----------------------------------------------------------

    final String sellerUID =
        widget.model?.sellerUID?.trim() ?? '';

    // ----------------------------------------------------------
    // GET MENU UID
    // ----------------------------------------------------------

    final String menuId =
        widget.model?.menuId?.trim() ?? '';

    // ----------------------------------------------------------
    // VALIDATE RESTAURANT AND MENU
    // ----------------------------------------------------------

    if (widget.model == null ||
        sellerUID.isEmpty ||
        menuId.isEmpty) {
      return Scaffold(
        appBar: MyAppbar(
          sellerUID: sellerUID,
        ),
        body: const Center(
          child: Text(
            'Restaurant or menu information is not available.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // MAIN SCREEN
    // ----------------------------------------------------------

    return Scaffold(
      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------

      appBar: MyAppbar(
        sellerUID: sellerUID,
      ),

      // --------------------------------------------------------
      // BODY
      // --------------------------------------------------------

      body: CustomScrollView(
        slivers: [
          // ----------------------------------------------------
          // MENU HEADER
          // ----------------------------------------------------

          SliverPersistentHeader(
            delegate: TextWidgetHeader(
              title:
              "Items's of ${widget.model!.menuTitle ?? 'Menu'}",
            ),
          ),

          // ----------------------------------------------------
          // LOAD ITEMS FROM SELECTED RESTAURANT + MENU
          // ----------------------------------------------------

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(sellerUID)
                .collection('menus')
                .doc(menuId)
                .collection('items')
                .orderBy(
              'publishedDate',
              descending: true,
            )
                .snapshots(),

            builder: (context, snapshot) {
              // ------------------------------------------------
              // ERROR
              // ------------------------------------------------

              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Unable to load items.\n\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              // ------------------------------------------------
              // LOADING
              // ------------------------------------------------

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

              // ------------------------------------------------
              // NO DATA
              // ------------------------------------------------

              if (!snapshot.hasData) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'No items available.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }

              // ------------------------------------------------
              // EMPTY ITEMS
              // ------------------------------------------------

              if (snapshot.data!.docs.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'No items available.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }

              // ------------------------------------------------
              // ITEMS LIST
              // ------------------------------------------------

              return SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,

                staggeredTileBuilder: (context) =>
                const StaggeredTile.fit(1),

                itemCount: snapshot.data!.docs.length,

                itemBuilder: (context, index) {
                  // --------------------------------------------
                  // CONVERT FIRESTORE DOCUMENT TO ITEM MODEL
                  // --------------------------------------------

                  final Items itemModel = Items.fromJson(
                    snapshot.data!.docs[index].data()
                    as Map<String, dynamic>,
                  );

                  // --------------------------------------------
                  // PRESERVE EXACT RESTAURANT UID
                  //
                  // The sellerUID comes from the selected
                  // restaurant, not from an individual item
                  // document.
                  // --------------------------------------------

                  itemModel.sellerUID = sellerUID;

                  // --------------------------------------------
                  // ITEM DESIGN
                  // --------------------------------------------

                  return ItemsDesignWidget(
                    model: itemModel,
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