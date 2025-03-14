import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:url_strategy/url_strategy.dart';

import 'router.dart'; // Import the router configuration

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyB54bXuBBJXMQkGSzYAMTwlR1s70Ow3GQI",
        authDomain: "pydart-intellicorp.firebaseapp.com",
        projectId: "pydart-intellicorp",
        storageBucket: "pydart-intellicorp.firebasestorage.app",
        messagingSenderId: "547840922925",
        appId: "67f1a176218c443a70efa4",
      ),
    );
    if (kDebugMode) {
      print("✅ Firebase successfully connected!");
    }
  } catch (e) {
    if (kDebugMode) {
      print("❌ Firebase connection failed: $e");
    }
  }

  runApp( ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pydart Intelli corp',
      debugShowCheckedModeBanner: false,
      // Use the routes defined in router.dart
      initialRoute: Routes.home,
      getPages: Routes.pages,
      theme: ThemeData(useMaterial3: true).copyWith(
        primaryColor: const Color(0xFFE58742),
        primaryColorLight: const Color(0xFFEDA53F),
      ),
      builder: (context, widget) => rf.ResponsiveBreakpoints.builder(
        child: Builder(
          builder: (context) {
            return rf.ResponsiveScaledBox(
              width: rf.ResponsiveValue<double?>(
                context,
                defaultValue: null,
                conditionalValues: [
                  const rf.Condition.equals(name: 'MOBILE_SMALL', value: 480),
                ],
              ).value,
              child: rf.ClampingScrollWrapper.builder(context, widget!),
            );
          },
        ),
        breakpoints: const [
          rf.Breakpoint(start: 0, end: 480, name: 'MOBILE_SMALL'),
          rf.Breakpoint(start: 481, end: 850, name: 'MOBILE'),
          rf.Breakpoint(start: 850, end: 1080, name: 'TABLET'),
          rf.Breakpoint(start: 1081, end: double.infinity, name: 'DESKTOP'),
        ],
      ),
    );
  }
}
