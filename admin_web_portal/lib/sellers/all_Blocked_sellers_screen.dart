import 'package:admin_web_portal/widgets/simple_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllBlockedSellersScreen extends StatefulWidget {
  const AllBlockedSellersScreen({super.key});

  @override
  State<AllBlockedSellersScreen> createState() =>
      _AllBlockedSellersScreenState();
}

class _AllBlockedSellersScreenState
    extends State<AllBlockedSellersScreen> {
  // ---------------------------------------------------------
  // UNBLOCK SELLER
  // ---------------------------------------------------------

  Future<void> unblockSeller(String sellerId) async {
    try {
      await FirebaseFirestore.instance
          .collection("sellers")
          .doc(sellerId)
          .update({
        "status": "Approved",
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Seller account unblocked successfully.",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ??
                "Unable to unblock seller.",
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to unblock seller.",
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------
  // CONFIRM UNBLOCK
  // ---------------------------------------------------------

  Future<void> showUnblockDialog(
      String sellerId,
      String sellerName,
      ) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Unblock Seller",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          content: Text(
            "Do you want to unblock \"$sellerName\"?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Unblock",
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await unblockSeller(sellerId,);
    }
  }

  // ---------------------------------------------------------
  // SELLER IMAGE
  // ---------------------------------------------------------

  Widget sellerImage(String? imageUrl) {
    final String image =
        imageUrl?.trim() ?? "";

    if (image.isEmpty) {
      return const CircleAvatar(
        radius: 32,
        backgroundColor: Color(0xFFE3F2FD),
        child: Icon(
          Icons.storefront,
          color: Color(0xFF1565C0),
          size: 35,
        ),
      );
    }

    if (image.startsWith("assets/")) {
      return CircleAvatar(
        radius: 32,
        backgroundColor:
        const Color(0xFFE3F2FD),
        backgroundImage:
        AssetImage(image),
      );
    }

    if (image.startsWith("http://") ||
        image.startsWith("https://")) {
      return CircleAvatar(
        radius: 32,
        backgroundColor:
        const Color(0xFFE3F2FD),
        backgroundImage:
        NetworkImage(image),
      );
    }

    return const CircleAvatar(
      radius: 32,
      backgroundColor: Color(0xFFE3F2FD),
      child: Icon(
        Icons.storefront,
        color: Color(0xFF1565C0),
        size: 35,
      ),
    );
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Blocked Sellers",
      ),
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("sellers")
            .where(
          "status",
          isEqualTo: "Blocked",
        )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1565C0),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),
                child: Text(
                  "Unable to load blocked sellers.\n\n"
                      "${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final sellers =
              snapshot.data?.docs ?? [];

          if (sellers.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.store_mall_directory_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No blocked sellers found.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: sellers.length,
            itemBuilder: (context, index) {
              final seller =
              sellers[index].data();

              final String sellerName =
                  seller["sellerName"]
                      ?.toString() ??
                      "Unknown Seller";

              final String sellerEmail =
                  seller["sellerEmail"]
                      ?.toString() ??
                      "No email";

              final String sellerPhone =
                  seller["phone"]
                      ?.toString() ??
                      "No phone";

              final String sellerAddress =
                  seller["address"]
                      ?.toString() ??
                      "No address";

              final String avatar =
                  seller["sellerAvtar"]
                      ?.toString() ??
                      "";

              return Card(
                elevation: 4,
                margin:
                const EdgeInsets.only(
                  bottom: 15,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          sellerImage(avatar),

                          const SizedBox(
                            width: 15,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  sellerName,
                                  style:
                                  const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  sellerEmail,
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.black54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  sellerPhone,
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.black54,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  sellerAddress,
                                  maxLines: 2,
                                  overflow:
                                  TextOverflow
                                      .ellipsis,
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child:
                        ElevatedButton.icon(
                          onPressed: () {
                            showUnblockDialog(
                              sellers[index].id,
                              sellerName,
                            );
                          },
                          icon: const Icon(
                            Icons.lock_open,
                          ),
                          label: const Text(
                            "Unblock Seller",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            Colors.green,
                            foregroundColor:
                            Colors.white,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}