import 'dart:async';

import 'package:flutter/material.dart';

import 'package:user_app/mainScreens/placed_order_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  const PaymentScreen({
    super.key,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
  });

  @override
  State<PaymentScreen> createState() =>
      _PaymentScreenState();
}

class _PaymentScreenState
    extends State<PaymentScreen> {
  static const Color deepBlue =
  Color(0xFF1565C0);

  static const Color mediumBlue =
  Color(0xFF42A5F5);

  static const Color lightBlue =
  Color(0xFFE3F2FD);

  String selectedMethod = "Cash on Delivery";

  bool processing = false;

  final TextEditingController upiController =
  TextEditingController();

  final TextEditingController cardNumberController =
  TextEditingController();

  final TextEditingController expiryController =
  TextEditingController();

  final TextEditingController cvvController =
  TextEditingController();

  final TextEditingController cardNameController =
  TextEditingController();

  @override
  void dispose() {
    upiController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    cardNameController.dispose();

    super.dispose();
  }

  double get amount =>
      widget.totalAmount ?? 0;

  Future<void> processPayment() async {
    if (processing) {
      return;
    }

    // -------------------------------------------------------
    // VALIDATE UPI
    // -------------------------------------------------------

    if (selectedMethod == "UPI") {
      if (upiController.text.trim().isEmpty) {
        _showMessage(
          "Please enter a UPI ID.",
        );
        return;
      }
    }

    // -------------------------------------------------------
    // VALIDATE CARD
    // -------------------------------------------------------

    if (selectedMethod == "Card") {
      if (cardNameController.text.trim().isEmpty ||
          cardNumberController.text
              .trim()
              .length <
              12 ||
          expiryController.text.trim().isEmpty ||
          cvvController.text.trim().length < 3) {
        _showMessage(
          "Please enter valid card details.",
        );
        return;
      }
    }

    // -------------------------------------------------------
    // CASH ON DELIVERY
    // -------------------------------------------------------

    if (selectedMethod ==
        "Cash on Delivery") {
      await _openOrderScreen(
        paymentMethod:
        "Cash on Delivery",
      );
      return;
    }

    // -------------------------------------------------------
    // FAKE ONLINE PAYMENT
    // -------------------------------------------------------

    setState(() {
      processing = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      processing = false;
    });

    // Fake payment succeeded.
    _showPaymentSuccess();
  }

  Future<void> _openOrderScreen({
    required String paymentMethod,
  }) async {
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlacedOrderScreen(
              addressID: widget.addressID,
              totolAmmount:
              widget.totalAmount,
              sellerUID:
              widget.sellerUID,
              paymentMethod:
              paymentMethod,
              paymentCompleted:
              paymentMethod !=
                  "Cash on Delivery",
            ),
      ),
    );
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(18),
          ),

          content: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              Container(
                width: 75,
                height: 75,

                decoration:
                const BoxDecoration(
                  color:
                  Color(0xFFE8F5E9),
                  shape:
                  BoxShape.circle,
                ),

                child: const Icon(
                  Icons.check_circle,
                  color:
                  Color(0xFF2E7D32),
                  size: 60,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Payment Successful",
                textAlign:
                TextAlign.center,

                style: TextStyle(
                  color: deepBlue,
                  fontSize: 21,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "₹${amount.toStringAsFixed(2)} paid successfully.",
                textAlign:
                TextAlign.center,

                style: const TextStyle(
                  color:
                  Colors.black87,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );

                    _openOrderScreen(
                      paymentMethod:
                      selectedMethod,
                    );
                  },

                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    deepBlue,
                    foregroundColor:
                    Colors.white,
                  ),

                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(
      String message,
      ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        duration:
        const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFFF8FBFF),

      appBar: AppBar(
        backgroundColor:
        mediumBlue,

        elevation: 3,

        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(
              context,
            )) {
              Navigator.pop(context);
            }
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          "Payment",
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontWeight:
            FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics:
        const BouncingScrollPhysics(),

        padding:
        const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          30,
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------
            // TOTAL AMOUNT
            // ------------------------------------------------

            Container(
              width: double.infinity,

              padding:
              const EdgeInsets.all(18),

              decoration:
              BoxDecoration(
                gradient:
                const LinearGradient(
                  colors: [
                    deepBlue,
                    mediumBlue,
                  ],
                ),

                borderRadius:
                BorderRadius.circular(
                  16,
                ),
              ),

              child: Column(
                children: [
                  const Text(
                    "Amount to Pay",
                    style:
                    TextStyle(
                      color:
                      Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    "₹${amount.toStringAsFixed(2)}",
                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                      fontSize: 30,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              "Select Payment Method",
              style: TextStyle(
                color: deepBlue,
                fontSize: 21,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // ------------------------------------------------
            // CASH ON DELIVERY
            // ------------------------------------------------

            _paymentMethodCard(
              value: "Cash on Delivery",
              title: "Cash on Delivery",
              subtitle:
              "Pay when your order arrives",
              icon:
              Icons.payments_outlined,
            ),

            // ------------------------------------------------
            // UPI
            // ------------------------------------------------

            _paymentMethodCard(
              value: "UPI",
              title: "UPI",
              subtitle:
              "Pay using UPI",
              icon:
              Icons.account_balance_wallet_outlined,
            ),

            if (selectedMethod == "UPI")
              Padding(
                padding:
                const EdgeInsets.only(
                  top: 8,
                  bottom: 10,
                ),

                child: TextField(
                  controller:
                  upiController,

                  keyboardType:
                  TextInputType.emailAddress,

                  decoration:
                  InputDecoration(
                    labelText:
                    "UPI ID",

                    hintText:
                    "example@upi",

                    prefixIcon:
                    const Icon(
                      Icons
                          .account_balance_wallet,
                      color:
                      deepBlue,
                    ),

                    filled: true,

                    fillColor:
                    Colors.white,

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),

            // ------------------------------------------------
            // CARD
            // ------------------------------------------------

            _paymentMethodCard(
              value: "Card",
              title: "Credit / Debit Card",
              subtitle:
              "Visa, Mastercard, RuPay",
              icon:
              Icons.credit_card,
            ),

            if (selectedMethod ==
                "Card")
              _cardFields(),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // SECURITY NOTICE
            // ------------------------------------------------

            Container(
              width: double.infinity,

              padding:
              const EdgeInsets.all(15),

              decoration:
              BoxDecoration(
                color: lightBlue,

                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Icon(
                    Icons.info_outline,
                    color: deepBlue,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "This is a demo payment screen. No real money will be charged.",
                      style:
                      TextStyle(
                        fontSize: 13,
                        color:
                        Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ------------------------------------------------
            // PAY BUTTON
            // ------------------------------------------------

            SizedBox(
              width: double.infinity,
              height: 56,

              child: ElevatedButton.icon(
                onPressed:
                processing
                    ? null
                    : processPayment,

                icon: processing
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child:
                  CircularProgressIndicator(
                    strokeWidth:
                    2.5,
                    color:
                    Colors.white,
                  ),
                )
                    : Icon(
                  selectedMethod ==
                      "Cash on Delivery"
                      ? Icons
                      .check_circle_outline
                      : Icons
                      .lock_outline,
                ),

                label: Text(
                  processing
                      ? "PROCESSING..."
                      : selectedMethod ==
                      "Cash on Delivery"
                      ? "PLACE ORDER"
                      : "PAY ₹${amount.toStringAsFixed(2)}",

                  style:
                  const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  deepBlue,

                  foregroundColor:
                  Colors.white,

                  disabledBackgroundColor:
                  Colors.grey,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodCard({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool selected =
        selectedMethod == value;

    return InkWell(
      borderRadius:
      BorderRadius.circular(14),

      onTap: () {
        setState(() {
          selectedMethod = value;
        });
      },

      child: Container(
        width: double.infinity,

        margin:
        const EdgeInsets.only(
          bottom: 10,
        ),

        padding:
        const EdgeInsets.all(15),

        decoration:
        BoxDecoration(
          color: selected
              ? lightBlue
              : Colors.white,

          borderRadius:
          BorderRadius.circular(
            14,
          ),

          border: Border.all(
            color: selected
                ? deepBlue
                : Colors.grey
                .shade300,

            width:
            selected ? 2 : 1,
          ),
        ),

        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,

              decoration:
              BoxDecoration(
                color: lightBlue,
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),

              child: Icon(
                icon,
                color: deepBlue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [
                  Text(
                    title,
                    style:
                    const TextStyle(
                      color: deepBlue,
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    subtitle,
                    style:
                    const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Radio<String>(
              value: value,
              groupValue:
              selectedMethod,

              activeColor:
              deepBlue,

              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedMethod = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardFields() {
    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),

      padding:
      const EdgeInsets.all(15),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          14,
        ),
      ),

      child: Column(
        children: [
          TextField(
            controller:
            cardNameController,

            textCapitalization:
            TextCapitalization.words,

            decoration:
            InputDecoration(
              labelText:
              "Card Holder Name",

              prefixIcon:
              const Icon(
                Icons.person_outline,
                color: deepBlue,
              ),

              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller:
            cardNumberController,

            keyboardType:
            TextInputType.number,

            maxLength: 16,

            decoration:
            InputDecoration(
              labelText:
              "Card Number",

              hintText:
              "1234 5678 9012 3456",

              counterText: "",

              prefixIcon:
              const Icon(
                Icons.credit_card,
                color: deepBlue,
              ),

              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller:
                  expiryController,

                  keyboardType:
                  TextInputType.number,

                  decoration:
                  InputDecoration(
                    labelText:
                    "MM/YY",

                    hintText:
                    "12/28",

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: TextField(
                  controller:
                  cvvController,

                  keyboardType:
                  TextInputType.number,

                  obscureText: true,

                  maxLength: 3,

                  decoration:
                  InputDecoration(
                    labelText: "CVV",

                    counterText: "",

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}