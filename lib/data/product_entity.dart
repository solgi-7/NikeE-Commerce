class ProductSort {
  static const latest = 0;
  static const popular = 1;
  static const priceHeighToLow = 2;
  static const priceLowToHeight = 3;
}

class ProductEntity {
  final int id;
  final String title;
  final String imageUrl;
  final int price;
  final int discount;
  final int priviousPrice;

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image'],
        price = json['price'],
        priviousPrice = json['previous_price'] ?? json['price'] + json['discount'],
        discount = json['discount'];
}
