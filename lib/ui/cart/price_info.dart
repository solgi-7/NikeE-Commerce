import 'package:flutter/material.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:seven_learn_nick/theme.dart';

class PriceInfo extends StatelessWidget {
  const PriceInfo(
      {Key? key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice})
      : super(key: key);
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, right: 8),
          child: Text(
            'جزئیات خرید',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
              right: 8.0, left: 8.0, top: 8.0, bottom: 32.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ کل خرید'),
                    RichText(
                      text: TextSpan(
                        text: totalPrice.sparateByComma,
                        style: DefaultTextStyle.of(context).style.apply(
                              color: LightThemeColors.secondryColor,
                            ),
                        children: const [
                          TextSpan(
                            text: ' تومان',
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('هزینه ارسال'),
                    Text(shippingCost.withPriceLabel),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('مبلغ قابل پرداخت'),
                    RichText(
                      text: TextSpan(
                        text: payablePrice.sparateByComma,
                        style: DefaultTextStyle.of(context).style.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        children: const [
                          TextSpan(
                            text: ' تومان',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
