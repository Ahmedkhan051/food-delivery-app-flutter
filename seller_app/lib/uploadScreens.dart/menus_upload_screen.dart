import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/widgets/error_Dialog.dart';
import 'package:seller_app/widgets/progress_bar.dart';

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({
    super.key,
  });

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenuOption {
  final String title;
  final String description;
  final String image;

  const _MenuOption({
    required this.title,
    required this.description,
    required this.image,
  });
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFF90CAF9);

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController shortInfoController =
  TextEditingController();

  bool uploading = false;

  String uniqueIdName =
  DateTime.now().millisecondsSinceEpoch.toString();

  _MenuOption? selectedMenu;

  final List<_MenuOption> menuOptions = const [
    _MenuOption(
      title: "Pizza",
      description:
      "Delicious fresh pizzas with a variety of tasty toppings.",
      image: "assets/images/pizza1.jpeg",
    ),
    _MenuOption(
      title: "Burger",
      description:
      "Juicy and delicious burgers made with fresh ingredients.",
      image: "assets/images/burger1.jpeg",
    ),
    _MenuOption(
      title: "Cake",
      description:
      "Fresh and delicious cakes for every occasion.",
      image: "assets/images/cake.jpeg",
    ),
    _MenuOption(
      title: "Chocolate",
      description:
      "Sweet and delicious chocolate treats.",
      image: "assets/images/chokolate.jpeg",
    ),
    _MenuOption(
      title: "Vegetarian",
      description:
      "Fresh and tasty vegetarian food.",
      image: "assets/images/veg1.jpeg",
    ),
    _MenuOption(
      title: "Non-Vegetarian",
      description:
      "Delicious non-vegetarian dishes prepared fresh.",
      image: "assets/images/non-veg.jpeg",
    ),
    _MenuOption(
      title: "Pastries",
      description:
      "Freshly prepared soft and delicious pastries.",
      image: "assets/images/pastries.jpeg",
    ),
    _MenuOption(
      title: "Samosa",
      description:
      "Crispy and delicious samosas with tasty filling.",
      image: "assets/images/samosa.jpeg",
    ),
    _MenuOption(
      title: "Momos",
      description:
      "Hot and delicious momos with flavorful fillings.",
      image: "assets/images/momos.jpeg",
    ),
    _MenuOption(
      title: "Shakes",
      description:
      "Refreshing and creamy shakes in different flavors.",
      image: "assets/images/shake.jpeg",
    ),
    _MenuOption(
      title: "Gulab Jamun",
      description:
      "Soft and delicious traditional Indian sweet.",
      image: "assets/images/gulabjamun.jpeg",
    ),
    _MenuOption(
      title: "Jalebi",
      description:
      "Crispy and juicy traditional Indian sweet.",
      image: "assets/images/jalebi.jpeg",
    ),
    _MenuOption(
      title: "Kaju Barfi",
      description:
      "Rich and delicious cashew-based Indian sweet.",
      image: "assets/images/kajubarfi.jpeg",
    ),
    _MenuOption(
      title: "Laddoo",
      description:
      "Traditional sweet and delicious laddoos.",
      image: "assets/images/laddoo.jpeg",
    ),
    _MenuOption(
      title: "Soft Drinks",
      description:
      "Refreshing cold drinks and beverages.",
      image: "assets/images/softdrink.jpeg",
    ),
    _MenuOption(
      title: "Fruits",
      description:
      "Fresh and healthy fruits.",
      image: "assets/images/fruit.png",
    ),
  ];

  void selectMenu(_MenuOption menu) {
    setState(() {
      selectedMenu = menu;
      titleController.text = menu.title;
      shortInfoController.text = menu.description;
    });
  }

  String get selectedImagePath {
    return selectedMenu?.image ??
        "assets/images/homefood.jpeg";
  }

  Future<void> validateUploadForm() async {
    if (selectedMenu == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message: "Please choose a menu first.",
          );
        },
      );
      return;
    }

    if (titleController.text.trim().isEmpty ||
        shortInfoController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Please enter the menu title and information.",
          );
        },
      );
      return;
    }

    final String? sellerUID =
    sharedPreferences?.getString("uid");

    if (sellerUID == null || sellerUID.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Seller information is not available.",
          );
        },
      );
      return;
    }

    if (!mounted) return;

    setState(() {
      uploading = true;
    });

    try {
      await saveInfo(
        selectedImagePath,
        sellerUID,
      );

      if (!mounted) return;

      setState(() {
        titleController.clear();
        shortInfoController.clear();
        selectedMenu = null;
        uniqueIdName =
            DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        uploading = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message:
            "Unable to add menu: $error",
          );
        },
      );
    }
  }

  Future<void> saveInfo(
      String imagePath,
      String sellerUID,
      ) async {
    final Map<String, dynamic> menuData = {
      "menuId": uniqueIdName,
      "sellerUID": sellerUID,
      "menuInfo": shortInfoController.text.trim(),
      "menuTitle": titleController.text.trim(),
      "publishedDate": DateTime.now(),
      "status": "available",

      // LOCAL ASSET PATH.
      // No Firebase Storage is used.
      "thumbnailUrl": imagePath,
    };

    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .collection("menus")
        .doc(uniqueIdName)
        .set(menuData);
  }

  Widget menuSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: DropdownButtonFormField<_MenuOption>(
        value: selectedMenu,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "Choose Menu",
          labelStyle: const TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: const Icon(
            Icons.restaurant_menu,
            color: darkBlue,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: mediumBlue,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: darkBlue,
              width: 2,
            ),
          ),
        ),
        hint: const Text(
          "Select a menu category",
        ),
        items: menuOptions.map(
              (menu) {
            return DropdownMenuItem<_MenuOption>(
              value: menu,
              child: Text(
                menu.title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (menu) {
          if (menu != null) {
            selectMenu(menu);
          }
        },
      ),
    );
  }

  Widget menusUploadFormScreen() {
    return Scaffold(
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
        title: const Text(
          "Add New Menu",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: "Lobster",
          ),
        ),
        actions: [
          TextButton(
            onPressed: uploading
                ? null
                : validateUploadForm,
            child: const Text(
              "ADD",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          bottom: 30,
        ),
        children: [
          if (uploading) linearProgress(),

          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                selectedImagePath,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    height: 230,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 75,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            "Choose a menu and the name, description and image will be filled automatically.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          menuSelector(),

          const SizedBox(height: 15),

          const Divider(
            color: mediumBlue,
            thickness: 2,
          ),

          ListTile(
            leading: const Icon(
              Icons.title,
              color: darkBlue,
            ),
            title: TextField(
              controller: titleController,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "Menu Title",
                labelStyle: TextStyle(
                  color: darkBlue,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          const Divider(
            color: mediumBlue,
            thickness: 2,
          ),

          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: darkBlue,
            ),
            title: TextField(
              controller: shortInfoController,
              maxLines: 3,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "Menu Information",
                labelStyle: TextStyle(
                  color: darkBlue,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          const Divider(
            color: mediumBlue,
            thickness: 2,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius:
                BorderRadius.circular(12),
                border: Border.all(
                  color: mediumBlue,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: darkBlue,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "The selected menu uses a built-in FoodHub image. No gallery or Firebase Storage is required.",
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    shortInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return menusUploadFormScreen();
  }
}