import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:user_app/assistant_methods/address_changer.dart';
import 'package:user_app/mainScreens/payment_screen.dart';
import 'package:user_app/models/address.dart';

import '../maps/maps.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totolAmmount;
  final String? sellerUID;

  const AddressDesign({
    super.key,
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totolAmmount,
    this.sellerUID,
  });

  @override
  State<AddressDesign> createState() =>
      _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  static const Color darkBlue =
  Color(0xFF1565C0);

  static const Color lightBlue =
  Color(0xFFE3F2FD);

  @override
  Widget build(BuildContext context) {
    final int addressIndex =
        widget.value ?? 0;

    final int selectedIndex =
        widget.currentIndex ?? 0;

    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(
          context,
          listen: false,
        ).displayResult(addressIndex);
      },

      borderRadius:
      BorderRadius.circular(15),

      child: Card(
        elevation: 2,

        margin:
        const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),

        color: Colors.white,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(15),

          side: const BorderSide(
            color: Color(0xFFBBDEFB),
          ),
        ),

        child: Padding(
          padding:
          const EdgeInsets.all(8),

          child: Column(
            children: [
              // ------------------------------------------------
              // ADDRESS INFORMATION
              // ------------------------------------------------

              Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Radio<int>(
                    value: addressIndex,

                    groupValue:
                    selectedIndex,

                    activeColor:
                    darkBlue,

                    onChanged: (val) {
                      if (val == null) {
                        return;
                      }

                      Provider.of<AddressChanger>(
                        context,
                        listen: false,
                      ).displayResult(val);
                    },
                  ),

                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                        right: 8,
                        top: 6,
                      ),

                      child: Table(
                        columnWidths:
                        const {
                          0: FlexColumnWidth(
                            1.1,
                          ),
                          1: FlexColumnWidth(
                            2,
                          ),
                        },

                        children: [
                          TableRow(
                            children: [
                              _label("Name"),
                              _value(
                                widget.model
                                    ?.name ??
                                    "Not available",
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _label("Phone"),
                              _value(
                                widget.model
                                    ?.phoneNumber ??
                                    "Not available",
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _label("Flat"),
                              _value(
                                widget.model
                                    ?.flatNumber ??
                                    "Not available",
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _label("City"),
                              _value(
                                widget.model
                                    ?.city ??
                                    "Not available",
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _label("State"),
                              _value(
                                widget.model
                                    ?.state ??
                                    "Not available",
                              ),
                            ],
                          ),

                          TableRow(
                            children: [
                              _label("Address"),
                              _value(
                                widget.model
                                    ?.fullAddress ??
                                    "Not available",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ------------------------------------------------
              // MAP BUTTON
              // ------------------------------------------------

              ElevatedButton(
                onPressed: () {
                  final String? lat =
                      widget.model?.lat;

                  final String? lng =
                      widget.model?.lng;

                  if (lat == null ||
                      lng == null) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Location is not available.",
                        ),
                      ),
                    );

                    return;
                  }

                  MapsUtils
                      .openMapWithPosition(
                    lat,
                    lng,
                  );
                },

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.black54,

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

                child: const Text(
                  "Check on Maps",
                ),
              ),

              // ------------------------------------------------
              // PROCEED BUTTON
              // Only appears for selected address.
              // ------------------------------------------------

              if (addressIndex ==
                  selectedIndex)
                Container(
                  width:
                  double.infinity,

                  margin:
                  const EdgeInsets.only(
                    top: 5,
                  ),

                  padding:
                  const EdgeInsets.all(
                    6,
                  ),

                  decoration:
                  BoxDecoration(
                    color: lightBlue,

                    borderRadius:
                    BorderRadius.circular(
                      10,
                    ),
                  ),

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentScreen(
                                addressID:
                                widget.addressID,

                                totalAmount:
                                widget.totolAmmount,

                                sellerUID:
                                widget.sellerUID,
                              ),
                        ),
                      );
                    },

                    style:
                    ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      darkBlue,

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

                    child: const Text(
                      "Proceed to Payment",
                      style: TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // LABEL
  // ----------------------------------------------------------

  Widget _label(String text) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 5,
      ),

      child: Text(
        text,

        style: const TextStyle(
          color: darkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // VALUE
  // ----------------------------------------------------------

  Widget _value(String text) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 5,
      ),

      child: Text(
        text,

        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
    );
  }
}