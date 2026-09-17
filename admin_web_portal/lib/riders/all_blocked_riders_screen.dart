import 'package:admin_web_portal/widgets/simple_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllBlockedRidersScreen extends StatefulWidget {
  const AllBlockedRidersScreen({super.key});

  @override
  State<AllBlockedRidersScreen> createState() =>
      _AllBlockedRidersScreenState();
}

class _AllBlockedRidersScreenState
    extends State<AllBlockedRidersScreen> {
  // ---------------------------------------------------------
  // UNBLOCK RIDER
  // ---------------------------------------------------------

  Future<void> unblockRider(String riderId) async {
    try {
      await FirebaseFirestore.instance
          .collection("riders")
          .doc(riderId)
          .update({
        "status": "Approved",
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Rider account unblocked successfully.",
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
                "Unable to unblock rider.",
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to unblock rider.",
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------
  // CONFIRM UNBLOCK
  // ---------------------------------------------------------

  Future<void> showUnblockDialog(
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
            "Unblock Rider",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          content: Text(
            "Do you want to unblock \"$riderName\"?",
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
                backgroundColor:
                Colors.green,
                foregroundColor:
                Colors.white,
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
      await unblockRider(riderId);
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
        backgroundColor:
        Color(0xFFE3F2FD),
        child: Icon(
          Icons.person,
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
      backgroundColor:
      Color(0xFFE3F2FD),
      child: Icon(
        Icons.person,
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
        title: "Blocked Riders",
      ),
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("riders")
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
                  "Unable to load blocked riders.\n\n"
                      "${snapshot.error}",
                  textAlign:
                  TextAlign.center,
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
                    Icons
                        .person_off_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No blocked riders found.",
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
            padding:
            const EdgeInsets.all(15),
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
                  BorderRadius.circular(
                    15,
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          riderImage(avatar),

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
                                  riderName,
                                  style:
                                  const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  riderEmail,
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors
                                        .black54,
                                  ),
                                ),

                                const SizedBox(
                                  height: 3,
                                ),

                                Text(
                                  riderPhone,
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors
                                        .black54,
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
                        width:
                        double.infinity,
                        height: 48,
                        child:
                        ElevatedButton
                            .icon(
                          onPressed: () {
                            showUnblockDialog(
                              riders[index].id,
                              riderName,
                            );
                          },
                          icon:
                          const Icon(
                            Icons
                                .person_add_alt_1,
                          ),
                          label: const Text(
                            "Unblock Rider",
                            style:
                            TextStyle(
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            Colors
                                .green,
                            foregroundColor:
                            Colors
                                .white,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
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