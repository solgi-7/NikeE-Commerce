class ProductEntity {
  final int id;
  final String title;
  final String imageUrl;
  final int price;
  final int discount;
  final int priviusePrice;

ProductEntity.fromJson(Map<String,dynamic> json)
  : id = json['id'],
  title = json['title'],
  imageUrl = json['image'],
  price = json['price'],
  priviusePrice = json['previuse_price'],
  discount =json['discount'];

}