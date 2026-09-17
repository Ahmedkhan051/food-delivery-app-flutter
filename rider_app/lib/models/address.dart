class Address {
  String? name;
  String? phoneNumber;
  String? flatNumber;

  String? city;
  String? state;
  String? fullAddress;
  String? lat;
  String? lng;

  Address({
    this.name,
    this.phoneNumber,
    this.flatNumber,
    this.city,
    this.state,
    this.fullAddress,
    this.lat,
    this.lng,
  });

  Address.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    phoneNumber = json['phoneNumber']?.toString();
    flatNumber = json['flatNumber']?.toString();

    city = json['city']?.toString();
    state = json['state']?.toString();
    fullAddress = json['fullAddress']?.toString();

    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
  }

  // Actual longitude value.
  String get longitude => lng ?? "";

  // Actual latitude value.
  String get lattitude => lat ?? "";

  // Correctly spelled latitude getter for new code.
  String get latitude => lat ?? "";

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'flatNumber': flatNumber,
      'city': city,
      'state': state,
      'fullAddress': fullAddress,
      'lat': lat,
      'lng': lng,
    };
  }
}