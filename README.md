# Complete Food Delivery App

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28.svg?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

A complete **Food Delivery System** developed with **Flutter, Dart, and Firebase**.

The project contains four connected applications:

- **User App**
- **Seller App**
- **Rider App**
- **Admin Web Portal**

The applications work together to support restaurant browsing, menu management, cart and checkout, order processing, rider assignment, delivery tracking, order history, earnings, and administration.

---

# 📱 Applications

## 👤 User App

The User App allows customers to browse restaurants, order food, and track their deliveries.

### Features

- User registration and authentication
- User profile management
- Browse restaurants
- Browse restaurant menus
- Browse food items
- Search restaurants and food
- Restaurant-specific menu browsing
- Add food items to cart
- Restaurant-wise cart handling
- Prevent checkout with items from multiple restaurants at the same time
- Add and manage delivery address
- Live location support
- Place orders
- View order details
- Track order status in real time
- View rider information after rider assignment
- View delivery progress
- View notifications
- Like/favorite food items
- View order history

---

## 🏪 Seller App

The Seller App allows restaurants/sellers to manage their menus and process customer orders.

### Features

- Seller registration and authentication
- Seller profile management
- Restaurant management
- Manage menus
- Add menus
- Add menu items
- Delete menus
- Delete menu items
- View incoming orders
- Accept orders
- Confirm orders
- Start preparing orders
- Mark orders as packed
- Track order status
- View order history
- View total earnings

Orders are routed to the correct seller using the restaurant's seller ID.

---

## 🛵 Rider App

The Rider App handles the delivery process after an order is prepared by the seller.

### Features

- Rider registration and authentication
- Rider profile management
- View new available delivery orders
- Accept delivery orders
- View order details
- Confirm parcel pickup
- Parcel picking workflow
- Out for delivery workflow
- Parcel delivering workflow
- View not-yet-delivered orders
- View orders to be delivered
- Update delivery status
- Rider location updates
- Customer-facing rider tracking
- View delivery history
- View total earnings

---

## 🛠️ Admin Web Portal

The Admin Web Portal provides administrative control over users, sellers, riders, and orders.

### Features

- Admin authentication
- Dashboard
- User management
- Seller management
- Rider management
- View verified users
- View blocked users
- View verified sellers
- View blocked sellers
- View verified riders
- View blocked riders
- Block/unblock user accounts
- Block/unblock seller accounts
- Block/unblock rider accounts
- Order Management
- View order status information
- View rider tracking information

---

# 🔄 Order Workflow

The complete delivery workflow is:

```text
User
  ↓
Place Order
  ↓
Seller Receives Order
  ↓
Confirmed
  ↓
Preparing
  ↓
Packed
  ↓
Rider Accepts Delivery
  ↓
Parcel Picking / Pickup
  ↓
Out for Delivery
  ↓
Delivered
  ↓
Order Completed
```

### Order Status Flow

```text
Placed
   ↓
Confirmed
   ↓
Preparing
   ↓
Packed
   ↓
Out for Delivery
   ↓
Delivered
```

The relevant order information is synchronized between the applications using Firebase/Cloud Firestore.

---

# 🏗️ Project Structure

```text
food-delivery-app-flutter/
│
├── user_app/
│   └── Flutter User Application
│
├── seller_app/
│   └── Flutter Seller Application
│
├── rider_app/
│   └── Flutter Rider Application
│
├── admin_web_portal/
│   └── Flutter Admin Web Portal
│
├── firebase_setup/
│   └── Firebase setup utilities
│
├── LICENSE
├── README.md
└── .gitignore
```

---

# 🧩 Technologies Used

- **Flutter**
- **Dart**
- **Firebase Core**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Storage**
- **Shared Preferences**
- **Geolocator**
- **Geocoding**
- **Google Maps / Location Services**
- **Android**
- **Flutter Web**

---

# 🔥 Firebase Integration

Firebase is used as the backend for the connected applications.

The project uses Firebase/Cloud Firestore for:

- User data
- Seller data
- Rider data
- Restaurant data
- Menu data
- Food item data
- Cart/order information
- Order status updates
- Rider assignment
- Rider location information
- Notifications and related application data
- Real-time updates between applications

## Using Your Own Firebase Project

For your own deployment:

1. Create your Firebase project:

   https://console.firebase.google.com/

2. Enable the Firebase services required by the applications.

3. Register the required Android and Web applications.

4. Configure the Firebase configuration files for each application.

5. Configure Firestore rules and indexes according to your deployment requirements.

6. Review authentication and storage settings before production use.

> **Important:** Never publish private service-account keys, passwords, or other server-side secrets.

---

# 📦 Installation

Make sure Flutter and Dart are installed on your computer.

Check your Flutter environment:

```bash
flutter doctor
```

## Clone the Repository

```bash
git clone https://github.com/Ahmedkhan051/food-delivery-app-flutter.git
```

Then open the project directory:

```bash
cd food-delivery-app-flutter
```

This repository contains multiple separate Flutter applications.

---

# ▶️ Run User App

Open a terminal:

```bash
cd user_app
flutter pub get
flutter run
```

---

# ▶️ Run Seller App

Open another terminal:

```bash
cd seller_app
flutter pub get
flutter run
```

---

# ▶️ Run Rider App

Open another terminal:

```bash
cd rider_app
flutter pub get
flutter run
```

---

# 🌐 Run Admin Web Portal

Open another terminal:

```bash
cd admin_web_portal
flutter pub get
flutter run -d chrome
```

---

# ⚙️ Configuration Notes

Each application is maintained separately inside this repository.

Before using the applications with your own Firebase backend, verify:

- Firebase configuration
- Firebase Authentication
- Cloud Firestore
- Firestore security rules
- Firestore indexes
- Firebase Storage
- Maps/location configuration
- Any external services required by your deployment

For a public or production deployment, use your own Firebase project and review all security settings carefully.

---

# 🛒 Restaurant-wise Ordering

The project supports restaurant-specific ordering.

The selected restaurant's seller ID is carried through the restaurant/menu/item flow and into the checkout process.

The cart validates restaurant ownership so that items from different restaurants are not checked out together.

This ensures that an order is routed to the correct seller application.

---

# 📍 Rider Tracking

The Rider App can update rider location information for an assigned order.

The User App can display rider-related tracking information while the delivery is in progress.

The Admin Web Portal also provides rider tracking information for order management.

---

# 📸 Screenshots

Add screenshots of the working applications here.

## User App

Suggested screenshots:

- Home
- Restaurant list
- Restaurant menu
- Food items
- Cart
- Checkout
- Order details
- Order tracking
- Notifications

## Seller App

Suggested screenshots:

- Seller dashboard
- Menu management
- New orders
- Preparing orders
- Packed orders
- Order history
- Earnings

## Rider App

Suggested screenshots:

- Rider dashboard
- New orders
- Order details
- Parcel pickup
- Out for delivery
- Delivery tracking
- History
- Earnings

## Admin Web Portal

Suggested screenshots:

- Dashboard
- Users
- Sellers
- Riders
- Order Management
- Rider tracking

---

# 🎥 Screen Recording

Add the current project demonstration video here.

```text
<YOUR-SCREEN-RECORDING-LINK>
```

---

# 🤝 Contributing

Contributions are welcome.

You can:

- Report bugs
- Open issues
- Suggest improvements
- Improve documentation
- Submit pull requests

Please test your changes before submitting a pull request.

---

# 🎓 Educational Purpose

This repository is shared for **educational and learning purposes**.

It is intended to help college students and Flutter learners understand:

- Flutter application development
- Dart programming
- Firebase integration
- Cloud Firestore
- Firebase Authentication
- Multi-application architecture
- Restaurant-wise data handling
- Cart and checkout systems
- Order management
- Real-time order status
- Seller workflows
- Rider assignment
- Delivery workflows
- Location tracking
- Admin management

---

# 🙏 Credits & Acknowledgements

## Project Development

This project was developed by **Ahmed Khan with assistance from ChatGPT by OpenAI**.

ChatGPT was used during development for programming assistance, debugging, code explanations, architecture guidance, feature implementation, problem solving, and project improvements.

## Original Structure Acknowledgement

The project uses the **basic structure and reference architecture of Harendra Prajapati's original project** as a starting point.

The development, modifications, features, integrations, debugging, and improvements in this repository were carried out as part of our project work.

The original copyright and MIT License notice are retained in the `LICENSE` file.

---

# 📄 License

This project is distributed under the **MIT License**.

See the [LICENSE](LICENSE) file for the complete license terms.

The repository retains the original copyright notice contained in the license file.

---

# ⚠️ Important Notice

This repository is shared primarily for educational purposes.

Before using the project for production or commercial deployment:

- Configure your own Firebase project.
- Review Firestore security rules.
- Review Firebase Authentication settings.
- Review Firebase Storage permissions.
- Review Maps and location configuration.
- Review any external-service configuration.
- Remove development/test data where appropriate.
- Never expose private keys or service-account credentials.

---

# ⭐ Support the Project

If this project helps you learn Flutter or Firebase, you can:

- Star the repository
- Share it with other students
- Report issues
- Suggest improvements
- Contribute to the project
