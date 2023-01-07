import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seven_learn_nick/data/product_entity.dart';

class FavoriteManater {
  static const _boxName = 'favorites';
  final _box = Hive.box<ProductEntity>(_boxName);
  ValueListenable<Box<ProductEntity>> get listenable => Hive.box<ProductEntity>(_boxName).listenable();

  static init()async{
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }
  void addFavprote (ProductEntity productEntity){
    _box.put(productEntity.id,productEntity);
  }

  void delete (ProductEntity productEntity){
    _box.delete(productEntity.id);
  }

  List<ProductEntity> get favorites => _box.values.toList();

  bool isFavorite (ProductEntity productEntity){
    return _box.containsKey(productEntity.id);
  }
}