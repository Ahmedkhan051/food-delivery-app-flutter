import 'package:flutter/material.dart';
import 'package:seller_app/model/address.dart';

class ShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? sellerId;
  final String? orderByUser;
  final String? orderId;

  const ShipmentAddressDesign({
    super.key,
    this.model,
    this.orderStatus,
    this.orderId,
    this.sellerId,
    this.orderByUser,
  });

  void confirmPracelShipment(
      BuildContext context,
      String getOrderId,
      String sellerId,
      String purchaserId,
      ) {}

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF1565C0);
    const Color mediumBlue = Color(0xFF42A5F5);
    const Color lightBlue = Color(0xFFE3F2FD);

    final Address? address = model;

    if (address == null) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Shipping address is unavailable.",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final String name =
    address.name?.toString().trim().isNotEmpty == true
        ? address.name!.toString().trim()
        : "Not available";

    final String phoneNumber =
    address.phoneNumber?.toString().trim().isNotEmpty == true
        ? address.phoneNumber!.toString().trim()
        : "Not available";

    final String fullAddress =
    address.fullAddress?.toString().trim().isNotEmpty == true
        ? address.fullAddress!.toString().trim()
        : "Address not available";

    // The real final status in our app is "Delivered".
    final bool isOrderDelivered =
        orderStatus?.trim() == "Delivered" ||
            orderStatus?.trim() == "ended";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Shipping Details",
            style: TextStyle(
              color: darkBlue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 6),

        // --------------------------------------------------------
        // CUSTOMER DETAILS
        // --------------------------------------------------------
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: mediumBlue.withValues(alpha: 0.35),
            ),
          ),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(110),
            },
            children: [
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    child: Text(
                      "Name",
                      style: TextStyle(
                        color: darkBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    child: Text(
                      "Phone",
                      style: TextStyle(
                        color: darkBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    child: Text(
                      phoneNumber,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // --------------------------------------------------------
        // DELIVERY ADDRESS
        // --------------------------------------------------------
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.06,
                ),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                "Delivery Address",
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                fullAddress,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // --------------------------------------------------------
        // BACK BUTTON
        // --------------------------------------------------------
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Center(
            child: InkWell(
              onTap: () {
                // IMPORTANT:
                // Do NOT open the splash screen.
                // Simply return to the previous screen.
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              borderRadius: BorderRadius.circular(10),
              splashColor:
              mediumBlue.withValues(alpha: 0.2),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10),
                  gradient:
                  const LinearGradient(
                    colors: [
                      lightBlue,
                      mediumBlue,
                      darkBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                width:
                MediaQuery.of(context)
                    .size
                    .width -
                    40,
                height: 50,
                child: Text(
                  isOrderDelivered
                      ? "Go Back"
                      : "Order Packing-Done",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}