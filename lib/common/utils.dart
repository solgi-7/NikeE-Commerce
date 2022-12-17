import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const defualtScrollPhysics = BouncingScrollPhysics();

extension PriceLable on int {
  String get withPriceLabel => this > 0 ? '$sparateByComma تومان' : 'رایگان';
  String get sparateByComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}
