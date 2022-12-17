import 'package:flutter/material.dart';

class EmotyView extends StatelessWidget {
  const EmotyView({
    Key? key,
    required this.message,
    this.callToAction,
    required this.image,
  }) : super(key: key);
  final String message;
  final Widget? callToAction;
  final Widget image;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image,
        Padding(
          padding: const EdgeInsets.only(
            right: 48.0,
            left: 48.0,
            top: 24,
            bottom: 16,
          ),
          child: Text(
            message,
            style: Theme.of(context).textTheme.headline6!.copyWith(height: 1.3),
            textAlign: TextAlign.center,
          ),
        ),
        if(callToAction != null) callToAction!,
      ],
    );
  }
}
