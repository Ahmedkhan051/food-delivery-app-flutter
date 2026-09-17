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
