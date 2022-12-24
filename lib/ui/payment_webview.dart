import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_learn_nick/ui/receipt/payment_receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGateWayScreen extends StatelessWidget {
  final String backGatewayUrl;

  const PaymentGateWayScreen({Key? key,required this.backGatewayUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: backGatewayUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        final uri = Uri.parse(url);
        if (uri.pathSegments.contains('checkout') && uri.host == 'expertdevelopers.ir') {
          final orderId = int.parse(uri.queryParameters['order_id']!);
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentReceiptScreen(orderId: orderId)));

        }
      },
    );
  }

}