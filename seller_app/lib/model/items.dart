class Items {
  String? menuId;
  String? sellerUID;
  String? itemId;
  String? title;
  String? shortInfo;
  String? publishedDate;
  String? thumbnailUrl;
  String? sellerName;
  String? longDescription;
  String? status;
  int? price;

  Items({
    this.menuId,
    this.sellerUID,
    this.itemId,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.sellerName,
    this.longDescription,
    this.status,
    this.price,
  });

  Items.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId']?.toString();
    sellerUID = json['sellerUID']?.toString();
    itemId = json['itemId']?.toString();
    title = json['title']?.toString();
    shortInfo = json['shortInfo']?.toString();
    publishedDate = json['publishedDate']?.toString();
    thumbnailUrl = json['thumbnailUrl']?.toString();
    sellerName = json['sellerName']?.toString();
    longDescription = json['longDescription']?.toString();
    status = json['status']?.toString();

    final dynamic priceValue = json['price'];

    if (priceValue is int) {
      price = priceValue;
    } else if (priceValue is double) {
      price = priceValue.toInt();
    } else if (priceValue != null) {
      price = int.tryParse(
        priceValue.toString(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'sellerUID': sellerUID,
      'itemId': itemId,
      'title': title,
      'shortInfo': shortInfo,
      'publishedDate': publishedDate,
      'thumbnailUrl': thumbnailUrl,
      'sellerName': sellerName,
      'longDescription': longDescription,
      'status': status,
      'price': price,
    };
  }
}