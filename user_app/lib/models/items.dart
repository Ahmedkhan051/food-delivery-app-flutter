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

    if (json['price'] is int) {
      price = json['price'] as int;
    } else {
      price = int.tryParse(
        json['price']?.toString() ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'sellerUID': sellerUID,
      'title': title,
      'itemId': itemId,
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