import 'package:hive_flutter/adapters.dart';
part 'product_entity.g.dart';

class ProductSort {
  static const latest = 0;
  static const popular = 1;
  static const priceHeighToLow = 2;
  static const priceLowToHeight = 3;
  static const List<String> names = [
    'جدیدترین',
    'پربازدیدترین',
    'قیمت نزولی',
    'قیمت سعودی',
  ];

}

@HiveType(typeId: 0)
class ProductEntity {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int price;
  @HiveField(4)
  final int discount;
  @HiveField(5)
  final int priviousPrice;
  ProductEntity(this.discount,this.id,this.imageUrl,this.price,this.priviousPrice,this.title,);

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image'],
        price = json['previous_price'] == null ? json['price'] - json['discount']: json['price'],
        priviousPrice = json['previous_price'] ?? json['price'] ,
        discount = json['discount'];
}

//   ProductEntity.fromJson(Map<String, dynamic> json)
//       : id = json['id'],
//         title = json['title'],
//         imageUrl = json['image'],
//         price = json['price'],
//         priviousPrice = json['previous_price'] ?? json['price'] + json['discount'],
//         discount = json['discount'];
// }
