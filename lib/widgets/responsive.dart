import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  ResponsiveWidget(
      {required this.largeScreen,
      required this.mediumScreen,
      required this.smallScreen});
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isMeduimScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <= 1200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return largeScreen;
      } else if (constraints.maxWidth <= 1200 && constraints.maxWidth >= 800) {
        return mediumScreen;
      } else {
        return smallScreen;
      }
    });
  }
}
