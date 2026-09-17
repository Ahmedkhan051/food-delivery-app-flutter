class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerEmail;
  String? sellerAvtar;

  Sellers({
    this.sellerUID,
    this.sellerName,
    this.sellerAvtar,
    this.sellerEmail,
  });

  Sellers.fromJson(Map<String, dynamic> json) {
    sellerUID = json["sellerUID"]?.toString();
    sellerName = json["sellerName"]?.toString();
    sellerAvtar = json["sellerAvtar"]?.toString();
    sellerEmail = json["sellerEmail"]?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "sellerUID": sellerUID,
      "sellerName": sellerName,
      "sellerAvtar": sellerAvtar,
      "sellerEmail": sellerEmail,
    };
  }
}