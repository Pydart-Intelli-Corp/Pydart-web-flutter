import 'package:flutter/material.dart';
import 'package:pydart/screen/Career/CareerScreen.dart';

import 'package:pydart/screen/comingsoon/comingsoon.dart';
import 'package:pydart/screen/home/blocks/IndustryTrend.dart';
import 'package:pydart/screen/services/servicesScreen.dart';
import 'package:pydart/screen/home/homescreen.dart';
import 'package:pydart/screen/whoweare/whoweare_screen.dart';

import 'package:get/get.dart';

// Assign an order/index to each route.
final Map<String, int> routeOrder = {
  Routes.home: 0,
  Routes.whoweare: 1,
  Routes.services: 2,
  Routes.insights: 3,
  Routes.career: 4,
};

/// A custom slide transition that determines the slide direction
/// based on the relative order of the current and previous route.
class CustomSlideTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    int? currentIndex = routeOrder[Get.currentRoute];
    int? previousIndex = routeOrder[Get.previousRoute];

    // Default to a small slide from the right.
    Offset beginOffset = const Offset(0.1, 0);

    if (previousIndex != null && currentIndex != null) {
      // Slide from the left if navigating backwards.
      if (currentIndex < previousIndex) {
        beginOffset = const Offset(-0.1, 0);
      } else {
        beginOffset = const Offset(0.1, 0);
      }
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

class Routes {
  static const String home = '/';
  static const String whoweare = '/whoweare';
  static const String services = '/services';
  static const String insights = '/insights';
  static const String career = '/career';

  static final List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => HomeScreen(),
      customTransition: CustomSlideTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: whoweare,
      page: () => WhoweareScreen(),
      customTransition: CustomSlideTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: services,
      page: () => ServicesScreen(),
      customTransition: CustomSlideTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
    // GetPage(
    //   name: insights,
    //   page: () => CyberpunkIndustryTrendsBlock(),
    //   customTransition: CustomSlideTransition(),
    //   transitionDuration: const Duration(milliseconds: 500),
    // ),
    GetPage(
      name: career,
      page: () => CareerScreen(),
      customTransition: CustomSlideTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
