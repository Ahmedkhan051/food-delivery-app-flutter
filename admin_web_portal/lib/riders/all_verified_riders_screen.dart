import 'package:admin_web_portal/widgets/simple_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllVerifiedRidersScreen extends StatefulWidget {
  const AllVerifiedRidersScreen({super.key});

  @override
  State<AllVerifiedRidersScreen> createState() =>
      _AllVerifiedRidersScreenState();
}

class _AllVerifiedRidersScreenState
    extends State<AllVerifiedRidersScreen> {
  // ---------------------------------------------------------
  // BLOCK RIDER
  // ---------------------------------------------------------

  Future<void> blockRider(String riderId) async {
    try {
      await FirebaseFirestore.instance
          .collection("riders")
          .doc(riderId)
          .update({
        "status": "Blocked",
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Rider account blocked successfully.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    } on FirebaseException catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message ??
                "Unable to block rider.",
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to block rider.",
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------
  // CONFIRM BLOCK
  // ---------------------------------------------------------

  Future<void> showBlockDialog(
      String riderId,
      String riderName,
      ) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Block Rider",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          content: Text(
            "Do you want to block \"$riderName\"?",
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
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Block",
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await blockRider(
        riderId,
      );
    }
  }

  // ---------------------------------------------------------
  // RIDER IMAGE
  // ---------------------------------------------------------

  Widget riderImage(String? imageUrl) {
    final String image =
        imageUrl?.trim() ?? "";

    if (image.isEmpty) {
      return const CircleAvatar(
        radius: 32,
        backgroundColor: Color(0xFFE3F2FD),
        child: Icon(
          Icons.person,
          color: Color(0xFF1565C0),
          size: 36,
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
        Icons.person,
        color: Color(0xFF1565C0),
        size: 36,
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
        title: "Verified Riders",
      ),
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("riders")
            .where(
          "status",
          isEqualTo: "Approved",
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
                  "Unable to load verified riders.\n\n"
                      "${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final riders =
              snapshot.data?.docs ?? [];

          if (riders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delivery_dining,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No verified riders found.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: riders.length,
            itemBuilder: (context, index) {
              final rider =
              riders[index].data();

              final String riderName =
                  rider["riderName"]
                      ?.toString() ??
                      "Unknown Rider";

              final String riderEmail =
                  rider["riderEmail"]
                      ?.toString() ??
                      "No email";

              final String riderPhone =
                  rider["phone"]
                      ?.toString() ??
                      "No phone";

              final String riderAddress =
                  rider["address"]
                      ?.toString() ??
                      "No address";

              final String avatar =
                  rider["riderAvtar"]
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
                          riderImage(avatar),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                  riderName,
                                  style:
                                  const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 7,
                                ),

                                Text(
                                  riderEmail,
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
                                  riderPhone,
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
                                  riderAddress,
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

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton
                            .icon(
                          onPressed: () {
                            showBlockDialog(
                              riders[index].id,
                              riderName,
                            );
                          },
                          icon: const Icon(
                            Icons.block,
                          ),
                          label: const Text(
                            "Block Rider",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.red,
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