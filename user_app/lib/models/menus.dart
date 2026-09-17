class Menus {
  String? menuId;
  String? sellerUID;
  String? menuTitle;
  String? menuInfo;
  String? publishedDate;
  String? thumbnailUrl;
  String? status;

  Menus({
    this.menuId,
    this.menuInfo,
    this.menuTitle,
    this.sellerUID,
    this.publishedDate,
    this.status,
    this.thumbnailUrl,
  });

  Menus.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId']?.toString();
    sellerUID = json['sellerUID']?.toString();
    menuTitle = json['menuTitle']?.toString();
    menuInfo = json['menuInfo']?.toString();
    publishedDate = json['publishedDate']?.toString();
    thumbnailUrl = json['thumbnailUrl']?.toString();
    status = json['status']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'menuId': menuId,
      'sellerUID': sellerUID,
      'menuTitle': menuTitle,
      'menuInfo': menuInfo,
      'publishedDate': publishedDate,
      'thumbnailUrl': thumbnailUrl,
      'status': status,
    };
  }
}