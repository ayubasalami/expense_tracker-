import 'package:flutter/material.dart';

class ResponsiveButton extends StatelessWidget {
  String text;
  bool? isResponsive;
  double? width;
  ResponsiveButton(
      {Key? key, this.isResponsive = false, this.width, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.blue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(text)],
      ),
    );
  }
}
