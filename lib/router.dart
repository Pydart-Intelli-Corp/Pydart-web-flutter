import 'package:flutter/foundation.dart';
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
  Routes.career: 3,
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
  static const String career = '/career';

  static final List<GetPage> pages = [
    GetPage(
      name: home,
      page: () {
        if (kDebugMode) {
          print('🏠 Loading HomeScreen for route: $home');
        }
        return HomeScreen();
      },
      customTransition: CustomSlideTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: whoweare,
      page: () {
        if (kDebugMode) {
          print('👥 Loading WhoweareScreen for route: $whoweare');
        }
        return WhoweareScreen();
        
      },
      
      customTransition: CustomSlideTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: services,
      page: () {
        if (kDebugMode) {
          print('🔧 Loading ServicesScreen for route: $services');
        }
        return ServicesScreen();
      },
      customTransition: CustomSlideTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: career,
      page: () {
        if (kDebugMode) {
          print('💼 Loading CareerScreen for route: $career');
        }
        return CareerScreen();
      },
      customTransition: CustomSlideTransition(),
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];

  // Helper method to check if a route exists
  static bool isValidRoute(String route) {
    return pages.any((page) => page.name == route);
  }

  // Helper method to get default route
  static String getDefaultRoute() {
    return home;
  }

  // Helper method to validate and sanitize routes
  static String sanitizeRoute(String route) {
    // Remove trailing slashes except for home route
    if (route != home && route.endsWith('/')) {
      route = route.substring(0, route.length - 1);
    }
    
    // Ensure route starts with /
    if (!route.startsWith('/')) {
      route = '/$route';
    }
    
    return route;
  }
}