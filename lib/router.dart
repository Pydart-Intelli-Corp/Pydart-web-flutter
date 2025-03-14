import 'package:flutter_website/screen/services/servicesScreen.dart';
import 'package:get/get.dart';
import 'package:flutter_website/screen/home/homescreen.dart';
import 'package:flutter_website/screen/whoweare/whoweare_screen.dart';

class Routes {
  static const String home = '/';
  static const String about = '/about';
  static const String services = '/services';
  static final List<GetPage> pages = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: about, page: () => WhoweareScreen()),
     GetPage(name: services, page: () => ServicesScreen()),
    // Add additional routes such as productDetail, cart, order, and payment here.
  ];
}
