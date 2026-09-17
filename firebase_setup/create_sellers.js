const { initializeApp, cert, getApps } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const {
  getFirestore,
  FieldValue,
} = require("firebase-admin/firestore");

const serviceAccount = require("./firebase-admin-key.json");

if (getApps().length === 0) {
  initializeApp({
    credential: cert(serviceAccount),
  });
}

const auth = getAuth();
const db = getFirestore();

const PASSWORD = "123456";
const PHONE = "970285";

const restaurants = [

  // =========================================================
  // 1. PIZZA HUT
  // =========================================================
  {
    email: "pizzahut@gmail.com",
    name: "Pizza Hut",
    menuTitle: "Pizza & Fast Food",
    menuInfo: "Fresh pizzas, sides and refreshing drinks",
    menuImage: "assets/images/pizza1.jpeg",

    items: [
      {
        title: "Margherita Pizza",
        shortInfo: "Cheesy classic pizza",
        description: "Classic pizza topped with tomato sauce and mozzarella cheese.",
        price: 220,
        image: "assets/images/pizza1.jpeg",
      },
      {
        title: "Farmhouse Pizza",
        shortInfo: "Loaded vegetable pizza",
        description: "Delicious pizza loaded with fresh vegetables and cheese.",
        price: 280,
        image: "assets/images/pizza2.jpeg",
      },
      {
        title: "Cheese Pizza",
        shortInfo: "Extra cheesy pizza",
        description: "Hot pizza covered with delicious melted cheese.",
        price: 250,
        image: "assets/images/pizza5.jpeg",
      },
      {
        title: "Veggie Pizza",
        shortInfo: "Fresh vegetable pizza",
        description: "Crispy pizza with fresh vegetables and herbs.",
        price: 260,
        image: "assets/images/pizza6.jpeg",
      },
      {
        title: "Garlic Bread",
        shortInfo: "Buttery garlic bread",
        description: "Soft garlic bread baked with butter and herbs.",
        price: 120,
        image: "assets/images/food1.jpeg",
      },
      {
        title: "Burger",
        shortInfo: "Cheesy loaded burger",
        description: "Freshly prepared burger with cheese and vegetables.",
        price: 180,
        image: "assets/images/burger.png",
      },
      {
        title: "Soft Drink",
        shortInfo: "Chilled soft drink",
        description: "Refreshing chilled soft drink.",
        price: 60,
        image: "assets/images/softdrink.jpeg",
      },
      {
        title: "Chocolate Shake",
        shortInfo: "Creamy chocolate shake",
        description: "Rich and creamy chocolate shake.",
        price: 140,
        image: "assets/images/shake.jpeg",
      },
    ],
  },

  // =========================================================
  // 2. MCDONALD'S
  // =========================================================
  {
    email: "mcdonalds@gmail.com",
    name: "McDonald's",
    menuTitle: "Burgers & Meals",
    menuInfo: "Burgers, fries, snacks and refreshing drinks",
    menuImage: "assets/images/burger.png",

    items: [
      {
        title: "Veg Burger",
        shortInfo: "Crispy vegetable burger",
        description: "Crispy vegetable patty with fresh vegetables and sauce.",
        price: 120,
        image: "assets/images/burger.png",
      },
      {
        title: "Cheese Burger",
        shortInfo: "Classic cheese burger",
        description: "Juicy burger with a creamy cheese slice.",
        price: 150,
        image: "assets/images/burger1.jpeg",
      },
      {
        title: "Double Burger",
        shortInfo: "Double patty burger",
        description: "Loaded burger with double patties and fresh toppings.",
        price: 220,
        image: "assets/images/burger2.jpeg",
      },
      {
        title: "French Fries",
        shortInfo: "Crispy salted fries",
        description: "Golden crispy French fries served hot.",
        price: 100,
        image: "assets/images/food2.webp",
      },
      {
        title: "Chicken Burger",
        shortInfo: "Crispy chicken burger",
        description: "Crispy chicken burger with fresh vegetables and sauce.",
        price: 190,
        image: "assets/images/nonveg1.jpeg",
      },
      {
        title: "Chicken Nuggets",
        shortInfo: "Crispy chicken nuggets",
        description: "Crispy golden chicken nuggets.",
        price: 160,
        image: "assets/images/nonveg2.jpeg",
      },
      {
        title: "Soft Drink",
        shortInfo: "Chilled soft drink",
        description: "Refreshing chilled carbonated drink.",
        price: 60,
        image: "assets/images/softdrink1.jpeg",
      },
      {
        title: "Chocolate Shake",
        shortInfo: "Cold chocolate shake",
        description: "Thick creamy chocolate shake.",
        price: 140,
        image: "assets/images/shake.jpeg",
      },
    ],
  },

  // =========================================================
  // 3. BURGER KING
  // =========================================================
  {
    email: "burgerking@gmail.com",
    name: "Burger King",
    menuTitle: "Burgers & Snacks",
    menuInfo: "Loaded burgers, fries, snacks and drinks",
    menuImage: "assets/images/Burger King_restaurent.png",

    items: [
      {
        title: "Whopper Burger",
        shortInfo: "Classic loaded burger",
        description: "Large juicy burger loaded with fresh vegetables and sauce.",
        price: 240,
        image: "assets/images/burger3.jpeg",
      },
      {
        title: "Cheese Burger",
        shortInfo: "Cheesy burger",
        description: "Delicious burger with melted cheese and fresh toppings.",
        price: 170,
        image: "assets/images/burger4.jpeg",
      },
      {
        title: "Crispy Chicken Burger",
        shortInfo: "Crispy chicken burger",
        description: "Crispy chicken patty with fresh vegetables and sauce.",
        price: 210,
        image: "assets/images/burger5.png",
      },
      {
        title: "Double Burger",
        shortInfo: "Double patty burger",
        description: "Two delicious patties with cheese and fresh toppings.",
        price: 260,
        image: "assets/images/burger6.jpeg",
      },
      {
        title: "French Fries",
        shortInfo: "Golden crispy fries",
        description: "Hot crispy French fries.",
        price: 100,
        image: "assets/images/food3.webp",
      },
      {
        title: "Chicken Nuggets",
        shortInfo: "Crispy nuggets",
        description: "Golden crispy chicken nuggets served hot.",
        price: 160,
        image: "assets/images/nonveg3.jpeg",
      },
      {
        title: "Cold Drink",
        shortInfo: "Refreshing cold drink",
        description: "Chilled refreshing soft drink.",
        price: 60,
        image: "assets/images/softdrink2.jpeg",
      },
      {
        title: "Chocolate Shake",
        shortInfo: "Creamy chocolate shake",
        description: "Creamy chocolate milkshake.",
        price: 150,
        image: "assets/images/shake.jpeg",
      },
    ],
  },

  // =========================================================
  // 4. DOMINO'S PIZZA
  // =========================================================
  {
    email: "dominos@gmail.com",
    name: "Domino's Pizza",
    menuTitle: "Pizza & Sides",
    menuInfo: "Delicious pizzas, sides and beverages",
    menuImage: "assets/images/pizz.png",

    items: [
      {
        title: "Margherita Pizza",
        shortInfo: "Classic cheese pizza",
        description: "Classic pizza with tomato sauce and mozzarella cheese.",
        price: 220,
        image: "assets/images/pizza7.jpeg",
      },
      {
        title: "Veg Loaded Pizza",
        shortInfo: "Loaded vegetable pizza",
        description: "Pizza loaded with fresh vegetables and cheese.",
        price: 290,
        image: "assets/images/pizza8.jpeg",
      },
      {
        title: "Paneer Pizza",
        shortInfo: "Paneer topped pizza",
        description: "Tasty pizza topped with paneer, vegetables and cheese.",
        price: 310,
        image: "assets/images/pizza9.jpeg",
      },
      {
        title: "Cheese Burst Pizza",
        shortInfo: "Extra cheesy pizza",
        description: "Rich pizza filled with delicious melted cheese.",
        price: 340,
        image: "assets/images/pizza10.jpeg",
      },
      {
        title: "Garlic Bread",
        shortInfo: "Soft garlic bread",
        description: "Freshly baked garlic bread with herbs and butter.",
        price: 130,
        image: "assets/images/food1.jpeg",
      },
      {
        title: "Burger",
        shortInfo: "Loaded burger",
        description: "Juicy burger with vegetables, sauce and cheese.",
        price: 170,
        image: "assets/images/burger1.jpeg",
      },
      {
        title: "Soft Drink",
        shortInfo: "Chilled soft drink",
        description: "Refreshing chilled soft drink.",
        price: 60,
        image: "assets/images/softdrink3.jpeg",
      },
      {
        title: "Chocolate Shake",
        shortInfo: "Creamy chocolate shake",
        description: "Rich creamy chocolate milkshake.",
        price: 140,
        image: "assets/images/shake.jpeg",
      },
    ],
  },

  // =========================================================
  // 5. KFC
  // =========================================================
  {
    email: "kfc@gmail.com",
    name: "KFC",
    menuTitle: "Chicken & Meals",
    menuInfo: "Crispy chicken, burgers, fries and drinks",
    menuImage: "assets/images/non-veg.jpeg",

    items: [
      {
        title: "Zinger Burger",
        shortInfo: "Crispy chicken burger",
        description: "Crispy chicken burger with fresh lettuce and sauce.",
        price: 220,
        image: "assets/images/nonveg4.jpeg",
      },
      {
        title: "Chicken Bucket",
        shortInfo: "Crispy chicken bucket",
        description: "A delicious bucket of crispy fried chicken.",
        price: 420,
        image: "assets/images/nonveg5.jpeg",
      },
      {
        title: "Chicken Wings",
        shortInfo: "Crispy chicken wings",
        description: "Crispy seasoned chicken wings.",
        price: 260,
        image: "assets/images/nonveg6.jpeg",
      },
      {
        title: "Fried Chicken",
        shortInfo: "Crispy fried chicken",
        description: "Golden crispy fried chicken.",
        price: 280,
        image: "assets/images/nonveg7.jpeg",
      },
      {
        title: "Chicken Strips",
        shortInfo: "Crispy chicken strips",
        description: "Tender crispy chicken strips.",
        price: 240,
        image: "assets/images/nonveg8.jpeg",
      },
      {
        title: "Chicken Burger",
        shortInfo: "Chicken burger",
        description: "Chicken burger with fresh lettuce and sauce.",
        price: 210,
        image: "assets/images/nonveg9.jpeg",
      },
      {
        title: "French Fries",
        shortInfo: "Hot crispy fries",
        description: "Golden crispy French fries.",
        price: 110,
        image: "assets/images/food2.webp",
      },
      {
        title: "Soft Drink",
        shortInfo: "Chilled soft drink",
        description: "Refreshing cold soft drink.",
        price: 60,
        image: "assets/images/softdrink4.jpeg",
      },
    ],
  },

  // =========================================================
  // 6. SUBWAY
  // =========================================================
  {
    email: "subway@gmail.com",
    name: "Subway",
    menuTitle: "Subs & Sandwiches",
    menuInfo: "Fresh subs, sandwiches, snacks and drinks",
    menuImage: "assets/images/sandwich.jpeg",

    items: [
      {
        title: "Veggie Sub",
        shortInfo: "Fresh vegetable sub",
        description: "Freshly prepared sub filled with vegetables and sauces.",
        price: 160,
        image: "assets/images/veg2.jpeg",
      },
      {
        title: "Paneer Sub",
        shortInfo: "Paneer filled sub",
        description: "Delicious paneer sub with fresh vegetables and sauces.",
        price: 190,
        image: "assets/images/veg3.jpeg",
      },
      {
        title: "Veg Sandwich",
        shortInfo: "Fresh vegetable sandwich",
        description: "Fresh sandwich with vegetables, cheese and sauce.",
        price: 140,
        image: "assets/images/veg4.jpeg",
      },
      {
        title: "Chicken Sub",
        shortInfo: "Chicken filled sub",
        description: "Tasty chicken sub with fresh vegetables and sauce.",
        price: 220,
        image: "assets/images/nonveg10.jpeg",
      },
      {
        title: "Chicken Sandwich",
        shortInfo: "Chicken sandwich",
        description: "Fresh sandwich with chicken, vegetables and sauce.",
        price: 210,
        image: "assets/images/nonveg11.jpeg",
      },
      {
        title: "Cookies",
        shortInfo: "Fresh bakery cookies",
        description: "Soft and tasty freshly baked cookies.",
        price: 80,
        image: "assets/images/cake10.jpeg",
      },
      {
        title: "Soft Drink",
        shortInfo: "Chilled soft drink",
        description: "Refreshing chilled soft drink.",
        price: 60,
        image: "assets/images/softdrink5.jpeg",
      },
      {
        title: "Chocolate Shake",
        shortInfo: "Creamy chocolate shake",
        description: "Rich and refreshing chocolate shake.",
        price: 140,
        image: "assets/images/shake.jpeg",
      },
    ],
  },

  // =========================================================
  // 7. FRESH FRUIT CORNER
  // =========================================================
  {
    email: "freshfruit@gmail.com",
    name: "Fresh Fruit Corner",
    menuTitle: "Fresh Fruits",
    menuInfo: "Fresh and healthy fruits",
    menuImage: "assets/images/fruits.png",

    items: [
      {
        title: "Fresh Fruits",
        shortInfo: "Fresh seasonal fruits",
        description: "A healthy selection of fresh seasonal fruits.",
        price: 120,
        image: "assets/images/fruits.png",
      },
      {
        title: "Fruit Platter",
        shortInfo: "Mixed fresh fruit platter",
        description: "A colorful platter made with fresh mixed fruits.",
        price: 180,
        image: "assets/images/fruit.png",
      },
      {
        title: "Mixed Fruit Bowl",
        shortInfo: "Fresh mixed fruit bowl",
        description: "Freshly prepared mixed fruit bowl.",
        price: 150,
        image: "assets/images/fruits.gif",
      },
    ],
  },

  // =========================================================
  // 8. DRINKS & SHAKES
  // =========================================================
  {
    email: "drinksandshakes@gmail.com",
    name: "Drinks & Shakes",
    menuTitle: "Drinks & Shakes",
    menuInfo: "Refreshing soft drinks and tasty shakes",
    menuImage: "assets/images/softdrink.png",

    items: [
      {
        title: "Soft Drinks",
        shortInfo: "Refreshing chilled soft drinks",
        description: "Refreshing chilled soft drinks served cold.",
        price: 60,
        image: "assets/images/softdrink.jpeg",
      },
      {
        title: "Chocolate Shake",
        shortInfo: "Creamy chocolate shake",
        description: "Rich and creamy chocolate shake.",
        price: 140,
        image: "assets/images/shake.jpeg",
      },
      {
        title: "Fruit Shake",
        shortInfo: "Fresh fruit shake",
        description: "A refreshing shake prepared with fresh fruit.",
        price: 130,
        image: "assets/images/shake.avif",
      },
      {
        title: "Cold Drink",
        shortInfo: "Chilled fizzy drink",
        description: "A chilled fizzy soft drink.",
        price: 50,
        image: "assets/images/softdrink1.jpeg",
      },
    ],
  },

  // =========================================================
  // 9. SWEET & SNACKS
  // =========================================================
  {
    email: "sweetandsnacks@gmail.com",
    name: "Sweet & Snacks",
    menuTitle: "Sweets & Snacks",
    menuInfo: "Traditional sweets and popular Indian snacks",
    menuImage: "assets/images/laddoo.jpeg",

    items: [
      {
        title: "Laddoo",
        shortInfo: "Traditional Indian laddoo",
        description: "Soft and delicious traditional Indian laddoo.",
        price: 100,
        image: "assets/images/laddoo.jpeg",
      },
      {
        title: "Jalebi",
        shortInfo: "Crispy sweet jalebi",
        description: "Crispy and juicy jalebi prepared fresh.",
        price: 90,
        image: "assets/images/jalebi.webp",
      },
      {
        title: "Gulab Jamun",
        shortInfo: "Soft gulab jamun",
        description: "Soft sweet gulab jamun served with sugar syrup.",
        price: 110,
        image: "assets/images/gulabjamun.jpeg",
      },
      {
        title: "Kaju Barfi",
        shortInfo: "Rich kaju barfi",
        description: "Premium cashew-based Indian sweet.",
        price: 180,
        image: "assets/images/kajubarfi.jpeg",
      },
      {
        title: "Samosa",
        shortInfo: "Crispy potato samosa",
        description: "Crispy samosa filled with spiced potato.",
        price: 40,
        image: "assets/images/samosa.jpeg",
      },
      {
        title: "Momos",
        shortInfo: "Steamed momos with chutney",
        description: "Soft and tasty momos served with spicy chutney.",
        price: 100,
        image: "assets/images/momos.jpeg",
      },
    ],
  },

  // =========================================================
  // 10. BAKERY & FAST FOOD
  // =========================================================
  {
    email: "bakeryfastfood@gmail.com",
    name: "Bakery & Fast Food",
    menuTitle: "Bakery & Fast Food",
    menuInfo: "Cakes, chocolates, burgers, pizza and more",
    menuImage: "assets/images/cake.jpeg",

    items: [
      {
        title: "Cake",
        shortInfo: "Fresh cream cake",
        description: "Soft and creamy cake for every occasion.",
        price: 350,
        image: "assets/images/cake.jpeg",
      },
      {
        title: "Chocolate",
        shortInfo: "Premium chocolate",
        description: "Rich and delicious chocolate.",
        price: 120,
        image: "assets/images/chokolate.jpeg",
      },
      {
        title: "Pastries",
        shortInfo: "Fresh bakery pastries",
        description: "Freshly prepared soft and creamy pastries.",
        price: 90,
        image: "assets/images/pastries.jpeg",
      },
      {
        title: "Burger",
        shortInfo: "Juicy loaded burger",
        description: "Juicy burger with fresh vegetables and cheese.",
        price: 180,
        image: "assets/images/burger.png",
      },
      {
        title: "Pizza",
        shortInfo: "Cheesy vegetable pizza",
        description: "Hot pizza topped with vegetables and cheese.",
        price: 280,
        image: "assets/images/pizza1.jpeg",
      },
      {
        title: "Vegetarian",
        shortInfo: "Fresh vegetarian meal",
        description: "A tasty vegetarian meal prepared with fresh ingredients.",
        price: 220,
        image: "assets/images/veg1.jpeg",
      },
      {
        title: "Non-Vegetarian",
        shortInfo: "Special non-vegetarian meal",
        description: "A flavorful non-vegetarian meal.",
        price: 280,
        image: "assets/images/non-veg.jpeg",
      },
    ],
  },
];

function makeMenuId(sellerUID) {
  return `setup-menu-${sellerUID}`;
}

function makeItemId(sellerUID, title) {
  const slug = title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");

  return `setup-${sellerUID}-${slug}`;
}

async function createOrGetUser(email) {
  try {
    const userRecord = await auth.createUser({
      email: email,
      password: PASSWORD,
      emailVerified: true,
    });

    console.log(`Authentication account created: ${email}`);

    return userRecord;
  } catch (error) {
    if (error.code === "auth/email-already-exists") {
      const userRecord = await auth.getUserByEmail(email);

      console.log(`Account already exists: ${email}`);

      return userRecord;
    }

    throw error;
  }
}

async function createSellerProfile(userRecord, restaurant) {
  const sellerUID = userRecord.uid;

  await db.collection("sellers").doc(sellerUID).set({
    sellerUID: sellerUID,
    sellerEmail: restaurant.email,
    sellerName: restaurant.name,
    sellerAvtar: "",
    phone: PHONE,
    address: "Mumbai, Maharashtra, India",
    status: "Approved",
    lat: 19.0760,
    lng: 72.8777,
  });

  console.log(`Seller profile ready: ${restaurant.name}`);
}

async function createMenuAndItems(sellerUID, restaurant) {
  const menuId = makeMenuId(sellerUID);

  const menuData = {
    menuId: menuId,
    sellerUID: sellerUID,
    menuInfo: restaurant.menuInfo,
    menuTitle: restaurant.menuTitle,
    publishedDate: FieldValue.serverTimestamp(),
    status: "available",
    thumbnailUrl: restaurant.menuImage,
  };

  await db
    .collection("sellers")
    .doc(sellerUID)
    .collection("menus")
    .doc(menuId)
    .set(menuData);

  console.log(`Menu ready: ${restaurant.menuTitle}`);

  for (const food of restaurant.items) {
    const itemId = makeItemId(
      sellerUID,
      food.title
    );

    const itemData = {
      itemId: itemId,
      menuId: menuId,
      sellerUID: sellerUID,
      sellerName: restaurant.name,
      shortInfo: food.shortInfo,
      longDescription: food.description,
      price: food.price,
      title: food.title,
      publishedDate: FieldValue.serverTimestamp(),
      status: "available",
      thumbnailUrl: food.image,
    };

    // Seller nested item
    await db
      .collection("sellers")
      .doc(sellerUID)
      .collection("menus")
      .doc(menuId)
      .collection("items")
      .doc(itemId)
      .set(itemData);

    // Top-level item
    await db
      .collection("items")
      .doc(itemId)
      .set(itemData);

    console.log(
      `  Food added: ${food.title} - ₹${food.price}`
    );
  }
}

async function setupRestaurant(restaurant) {
  console.log("");
  console.log("======================================");
  console.log(`Setting up: ${restaurant.name}`);
  console.log("======================================");

  try {
    const userRecord =
      await createOrGetUser(restaurant.email);

    await createSellerProfile(
      userRecord,
      restaurant
    );

    await createMenuAndItems(
      userRecord.uid,
      restaurant
    );

    console.log(
      `SUCCESS: ${restaurant.name}`
    );

    console.log(
      `Email: ${restaurant.email}`
    );

    console.log(
      `Password: ${PASSWORD}`
    );

    console.log(
      `UID: ${userRecord.uid}`
    );

  } catch (error) {
    console.error(
      `FAILED: ${restaurant.name}`
    );

    console.error(error.message);
  }
}

async function main() {
  console.log("");
  console.log("FOODHUB COMPLETE RESTAURANT SETUP");
  console.log("==================================");

  for (const restaurant of restaurants) {
    await setupRestaurant(restaurant);
  }

  console.log("");
  console.log("==================================");
  console.log("ALL RESTAURANTS AND FOODS FINISHED");
  console.log("==================================");

  process.exit(0);
}

main().catch((error) => {
  console.error("");
  console.error("FATAL ERROR:");
  console.error(error);

  process.exit(1);
});