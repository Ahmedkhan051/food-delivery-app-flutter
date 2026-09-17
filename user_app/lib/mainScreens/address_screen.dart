import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:user_app/mainScreens/save_address_screen.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/address_design.dart';
import 'package:user_app/widgets/progress_bar.dart';
import 'package:user_app/widgets/simple_Appbar.dart';

import '../assistant_methods/address_changer.dart';
import '../global/global.dart';

class AddressScreen extends StatefulWidget {
  final double? totolAmmount;
  final String? sellerUID;

  const AddressScreen({
    super.key,
    this.totolAmmount,
    this.sellerUID,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    final String uid =
        sharedPreferences?.getString("uid") ?? "";

    return Scaffold(
      appBar: SimpleAppBar(
        title: "FoodHub",
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SaveAddressScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(
          Icons.add_location,
          color: Colors.white,
        ),
        label: const Text(
          "Add New Address",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Select Address",
                style: TextStyle(
                  color: Color(0xFF1565C0),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          if (uid.isEmpty)
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "User session not found.\nPlease log in again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Consumer<AddressChanger>(
                builder: (context, address, child) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("userAddress")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: circularProgress(),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Unable to load saved addresses.",
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
                              'No saved address found.\n'
                                  'Tap "Add New Address" to add one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          bottom: 90,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot document =
                          snapshot.data!.docs[index];

                          return AddressDesign(
                            currentIndex: address.count,
                            value: index,
                            addressID: document.id,
                            totolAmmount: widget.totolAmmount,
                            sellerUID: widget.sellerUID,
                            model: Address.fromJson(
                              document.data()!
                              as Map<String, dynamic>,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}