import 'package:flutter/cupertino.dart';

const defualtScrollPhysics = BouncingScrollPhysics();

extension PriceLable on int {
  String get withPriceLabel => '$this تومان';
}