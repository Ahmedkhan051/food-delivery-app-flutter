import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/mainScreens/home_screen.dart';
import 'package:seller_app/model/menus.dart';
import 'package:seller_app/widgets/error_Dialog.dart';
import 'package:seller_app/widgets/progress_bar.dart';

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;

  const ItemsUploadScreen({
    super.key,
    this.model,
  });

  @override
  State<ItemsUploadScreen> createState() =>
      _ItemsUploadScreenState();
}

class _FoodOption {
  final String title;
  final String shortInfo;
  final String description;
  final String image;

  const _FoodOption({
    required this.title,
    required this.shortInfo,
    required this.description,
    required this.image,
  });
}

class _ItemsUploadScreenState
    extends State<ItemsUploadScreen> {
  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFF90CAF9);

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController shortInfoController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();

  final TextEditingController priceController =
  TextEditingController();

  bool uploading = false;

  String uniqueIdName =
  DateTime.now().millisecondsSinceEpoch.toString();

  _FoodOption? selectedFood;

  final List<_FoodOption> foodOptions = const [
    _FoodOption(
      title: "Chicken Burger",
      shortInfo: "Juicy chicken burger",
      description:
      "Juicy chicken burger prepared with fresh ingredients and tasty sauces.",
      image: "assets/images/burger1.jpeg",
    ),
    _FoodOption(
      title: "Veg Burger",
      shortInfo: "Fresh vegetarian burger",
      description:
      "Delicious vegetarian burger prepared with fresh vegetables and sauces.",
      image: "assets/images/burger2.jpeg",
    ),
    _FoodOption(
      title: "Cheese Burger",
      shortInfo: "Burger with melted cheese",
      description:
      "Juicy burger topped with delicious melted cheese and fresh ingredients.",
      image: "assets/images/burger6.jpeg",
    ),
    _FoodOption(
      title: "Pizza",
      shortInfo: "Fresh delicious pizza",
      description:
      "Freshly prepared pizza with delicious toppings and melted cheese.",
      image: "assets/images/pizza1.jpeg",
    ),
    _FoodOption(
      title: "Veg Pizza",
      shortInfo: "Fresh vegetable pizza",
      description:
      "Delicious pizza loaded with fresh vegetables and melted cheese.",
      image: "assets/images/pizza2.jpeg",
    ),
    _FoodOption(
      title: "Cheese Pizza",
      shortInfo: "Cheesy delicious pizza",
      description:
      "Hot and delicious pizza covered with rich melted cheese.",
      image: "assets/images/pizza5.jpeg",
    ),
    _FoodOption(
      title: "Chocolate Cake",
      shortInfo: "Soft chocolate cake",
      description:
      "Soft and delicious chocolate cake prepared with rich chocolate flavor.",
      image: "assets/images/cake1.jpeg",
    ),
    _FoodOption(
      title: "Fresh Cake",
      shortInfo: "Fresh cream cake",
      description:
      "Freshly prepared soft cake with delicious cream and decoration.",
      image: "assets/images/cake.jpeg",
    ),
    _FoodOption(
      title: "Veg Special",
      shortInfo: "Fresh vegetarian dish",
      description:
      "Fresh and tasty vegetarian food prepared with quality ingredients.",
      image: "assets/images/veg1.jpeg",
    ),
    _FoodOption(
      title: "Paneer Special",
      shortInfo: "Delicious paneer dish",
      description:
      "Delicious paneer dish prepared with fresh ingredients and flavorful spices.",
      image: "assets/images/veg2.jpeg",
    ),
    _FoodOption(
      title: "Chicken Special",
      shortInfo: "Delicious chicken dish",
      description:
      "Tender chicken prepared with delicious spices and fresh ingredients.",
      image: "assets/images/nonveg1.jpeg",
    ),
    _FoodOption(
      title: "Samosa",
      shortInfo: "Crispy spicy samosa",
      description:
      "Crispy golden samosa filled with a delicious spicy filling.",
      image: "assets/images/samosa.jpeg",
    ),
    _FoodOption(
      title: "Momos",
      shortInfo: "Hot steamed momos",
      description:
      "Hot and delicious momos filled with flavorful ingredients.",
      image: "assets/images/momos.jpeg",
    ),
    _FoodOption(
      title: "Chocolate Pastry",
      shortInfo: "Soft chocolate pastry",
      description:
      "Soft and delicious pastry with rich chocolate flavor.",
      image: "assets/images/pastries1.jpeg",
    ),
    _FoodOption(
      title: "Fresh Shake",
      shortInfo: "Refreshing creamy shake",
      description:
      "Refreshing and creamy shake prepared with fresh ingredients.",
      image: "assets/images/shake.jpeg",
    ),
    _FoodOption(
      title: "Gulab Jamun",
      shortInfo: "Soft Indian sweet",
      description:
      "Soft and delicious gulab jamun served with traditional sweet syrup.",
      image: "assets/images/gulabjamun.jpeg",
    ),
    _FoodOption(
      title: "Jalebi",
      shortInfo: "Crispy sweet jalebi",
      description:
      "Crispy and juicy traditional jalebi prepared fresh.",
      image: "assets/images/jalebi.jpeg",
    ),
    _FoodOption(
      title: "Kaju Barfi",
      shortInfo: "Rich cashew sweet",
      description:
      "Rich and delicious cashew-based traditional Indian sweet.",
      image: "assets/images/kajubarfi.jpeg",
    ),
    _FoodOption(
      title: "Laddoo",
      shortInfo: "Traditional Indian sweet",
      description:
      "Traditional soft and delicious laddoo prepared with quality ingredients.",
      image: "assets/images/laddoo.jpeg",
    ),
    _FoodOption(
      title: "Soft Drink",
      shortInfo: "Refreshing cold drink",
      description:
      "Refreshing chilled soft drink, perfect with your meal.",
      image: "assets/images/softdrink.jpeg",
    ),
    _FoodOption(
      title: "Fresh Fruits",
      shortInfo: "Fresh healthy fruits",
      description:
      "Fresh and healthy fruits selected for great taste and nutrition.",
      image: "assets/images/fruit.png",
    ),
  ];

  void selectFood(_FoodOption food) {
    setState(() {
      selectedFood = food;

      titleController.text = food.title;
      shortInfoController.text = food.shortInfo;
      descriptionController.text = food.description;
    });
  }

  String get selectedImagePath {
    return selectedFood?.image ??
        "assets/images/homefood.jpeg";
  }

  Widget buildFoodImage() {
    return Padding(
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
              width: double.infinity,
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
    );
  }

  Widget foodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: DropdownButtonFormField<_FoodOption>(
        value: selectedFood,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: "Choose Food Item",
          labelStyle: const TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: const Icon(
            Icons.fastfood,
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
          "Select a food item",
        ),
        items: foodOptions.map(
              (food) {
            return DropdownMenuItem<_FoodOption>(
              value: food,
              child: Text(
                food.title,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          },
        ).toList(),
        onChanged: (food) {
          if (food != null) {
            selectFood(food);
          }
        },
      ),
    );
  }

  Widget addFoodFormScreen() {
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
          "Add Food Item",
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

          buildFoodImage(),

          const SizedBox(height: 12),

          const Text(
            "Choose a food item and the name, information, description and image will be filled automatically.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: darkBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 18),

          foodSelector(),

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
              decoration:
              const InputDecoration(
                labelText: "Item Title",
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
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration:
              const InputDecoration(
                labelText: "Short Information",
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
              Icons.description_outlined,
              color: darkBlue,
            ),
            title: TextField(
              controller: descriptionController,
              maxLines: 3,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration:
              const InputDecoration(
                labelText: "Description",
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
              Icons.currency_rupee,
              color: darkBlue,
            ),
            title: TextField(
              controller: priceController,
              keyboardType:
              TextInputType.number,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration:
              const InputDecoration(
                labelText: "Price",
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
            padding:
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Container(
              padding:
              const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                const Color(0xFFE3F2FD),
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
                      "Select a food item to automatically fill its name, information, description and image. Only the price needs to be entered.",
                      style: TextStyle(
                        color: darkBlue,
                        fontSize: 14,
                        fontWeight:
                        FontWeight.w500,
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

  Future<void> validateUploadForm() async {
    if (selectedFood == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Please choose a food item first.",
          );
        },
      );
      return;
    }

    if (titleController.text
        .trim()
        .isEmpty ||
        shortInfoController.text
            .trim()
            .isEmpty ||
        descriptionController.text
            .trim()
            .isEmpty ||
        priceController.text
            .trim()
            .isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Please enter all food details and price.",
          );
        },
      );
      return;
    }

    final int? price = int.tryParse(
      priceController.text.trim(),
    );

    if (price == null || price < 0) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Please enter a valid price.",
          );
        },
      );
      return;
    }

    final String? sellerUID =
    sharedPreferences?.getString("uid");

    final String? menuId =
        widget.model?.menuId;

    if (sellerUID == null ||
        sellerUID.isEmpty ||
        menuId == null ||
        menuId.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Seller or menu information is missing.",
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
        menuId,
        price,
      );

      if (!mounted) return;

      setState(() {
        titleController.clear();
        shortInfoController.clear();
        descriptionController.clear();
        priceController.clear();
        selectedFood = null;
        uniqueIdName =
            DateTime.now()
                .millisecondsSinceEpoch
                .toString();
        uploading = false;
      });

      Fluttertoast.showToast(
        msg: "Food item added successfully",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const HomeScreen(),
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
            "Unable to add food item: $error",
          );
        },
      );
    }
  }

  Future<void> saveInfo(
      String imagePath,
      String sellerUID,
      String menuId,
      int price,
      ) async {
    final String sellerName =
        sharedPreferences?.getString(
          "name",
        ) ??
            "";

    final Map<String, dynamic> itemData = {
      "itemId": uniqueIdName,
      "menuId": menuId,
      "sellerUID": sellerUID,
      "sellerName": sellerName,
      "shortInfo":
      shortInfoController.text.trim(),
      "longDescription":
      descriptionController.text.trim(),
      "price": price,
      "title":
      titleController.text.trim(),
      "publishedDate": DateTime.now(),
      "status": "available",

      // Local asset path.
      "thumbnailUrl": imagePath,
    };

    final CollectionReference menuItemsRef =
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(sellerUID)
        .collection("menus")
        .doc(menuId)
        .collection("items");

    await menuItemsRef
        .doc(uniqueIdName)
        .set(itemData);

    await FirebaseFirestore.instance
        .collection("items")
        .doc(uniqueIdName)
        .set(itemData);
  }

  @override
  void dispose() {
    titleController.dispose();
    shortInfoController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return addFoodFormScreen();
  }
}