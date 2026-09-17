import 'package:admin_web_portal/widgets/simple_Appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllBlockedUsersScreen extends StatefulWidget {
  const AllBlockedUsersScreen({super.key});

  @override
  State<AllBlockedUsersScreen> createState() =>
      _AllBlockedUsersScreenState();
}

class _AllBlockedUsersScreenState
    extends State<AllBlockedUsersScreen> {
  // ---------------------------------------------------------
  // UNBLOCK USER
  // ---------------------------------------------------------

  Future<void> unblockUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .update({
        "status": "Approved",
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "User account unblocked successfully.",
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
                "Unable to unblock user.",
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to unblock user.",
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------
  // CONFIRM UNBLOCK
  // ---------------------------------------------------------

  Future<void> showUnblockDialog(
      String userId,
      String userName,
      ) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Unblock User",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          content: Text(
            "Do you want to unblock \"$userName\"?",
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
      await unblockUser(userId);
    }
  }

  // ---------------------------------------------------------
  // USER IMAGE
  // ---------------------------------------------------------

  Widget userImage(String? imageUrl) {
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
        title: "Blocked Users",
      ),
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
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
                  "Unable to load blocked users.\n\n"
                      "${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final users =
              snapshot.data?.docs ?? [];

          if (users.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No blocked users found.",
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
            itemCount: users.length,
            itemBuilder:
                (context, index) {
              final user =
              users[index].data();

              final String userName =
                  user["name"]?.toString() ??
                      "Unknown User";

              final String userEmail =
                  user["email"]?.toString() ??
                      "No email";

              final String userPhone =
                  user["phone"]?.toString() ??
                      "No phone";

              final String userAddress =
                  user["address"]?.toString() ??
                      "No address";

              final String avatar =
                  user["photo"]?.toString() ??
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
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          userImage(avatar),

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
                                  userName,
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
                                  userEmail,
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
                                  userPhone,
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
                                  userAddress,
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
                        width:
                        double.infinity,
                        height: 48,
                        child:
                        ElevatedButton.icon(
                          onPressed: () {
                            showUnblockDialog(
                              users[index].id,
                              userName,
                            );
                          },
                          icon: const Icon(
                            Icons.lock_open,
                          ),
                          label: const Text(
                            "Unblock User",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          style:
                          ElevatedButton.styleFrom(
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