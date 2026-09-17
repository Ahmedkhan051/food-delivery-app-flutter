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

  String get longitude => lng ?? '';

  String get lattitude => lat ?? '';

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