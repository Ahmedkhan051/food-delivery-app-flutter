import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/models/sellers.dart';

import '../widgets/sellers_design.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? restaurantsDocumentsList;
  String sellerNameText = "";

  // =========================================================
  // NORMALIZE SEARCH TEXT
  // =========================================================

  String normalizeSearchText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(
      RegExp(r'[^a-z0-9]'),
      '',
    );
  }

  // =========================================================
  // SEARCH RESTAURANTS
  // =========================================================

  void initSearchingRestaurants(String textEntered) {
    final String searchText = textEntered.trim();

    if (searchText.isEmpty) {
      setState(() {
        restaurantsDocumentsList = null;
      });
      return;
    }

    setState(() {
      restaurantsDocumentsList = FirebaseFirestore.instance
          .collection("sellers")
          .limit(50)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: TextField(
          onChanged: (textEntered) {
            sellerNameText = textEntered;
            initSearchingRestaurants(textEntered);
          },
          onSubmitted: (textEntered) {
            initSearchingRestaurants(textEntered);
          },
          decoration: InputDecoration(
            hintText: "Search restaurant here...",
            hintStyle: const TextStyle(
              color: Colors.white70,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: () {
                initSearchingRestaurants(
                  sellerNameText,
                );
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: restaurantsDocumentsList == null
          ? const Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 60,
              color: Color(0xFF90CAF9),
            ),
            SizedBox(height: 12),
            Text(
              "Search for a restaurant",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : FutureBuilder<QuerySnapshot>(
        future: restaurantsDocumentsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1976D2),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Unable to search restaurants.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No restaurant found.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          // =================================================
          // FILTER RESTAURANTS LOCALLY
          // =================================================

          final String normalizedSearch =
          normalizeSearchText(
            sellerNameText,
          );

          final List<Sellers> matchingRestaurants =
          [];

          for (final QueryDocumentSnapshot document
          in snapshot.data!.docs) {
            try {
              final Map<String, dynamic> data =
              document.data()
              as Map<String, dynamic>;

              final Sellers model =
              Sellers.fromJson(data);

              final String normalizedName =
              normalizeSearchText(
                model.sellerName ?? "",
              );

              final String normalizedEmail =
              normalizeSearchText(
                model.sellerEmail ?? "",
              );

              if (normalizedName.contains(
                normalizedSearch,
              ) ||
                  normalizedEmail.contains(
                    normalizedSearch,
                  )) {
                matchingRestaurants.add(
                  model,
                );
              }
            } catch (_) {
              // Ignore malformed seller documents
              // and continue with the remaining sellers.
            }
          }

          // =================================================
          // NO MATCH
          // =================================================

          if (matchingRestaurants.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No restaurant found.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          // =================================================
          // SHOW RESULTS
          // =================================================

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 20,
            ),
            itemCount:
            matchingRestaurants.length,
            itemBuilder: (
                context,
                index,
                ) {
              final Sellers model =
              matchingRestaurants[index];

              return SellersDesignWidget(
                model: model,
                context: context,
              );
            },
          );
        },
      ),
    );
  }
}