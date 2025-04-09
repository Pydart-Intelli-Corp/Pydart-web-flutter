import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_website/preload.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:url_strategy/url_strategy.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  // Configure image cache size (200MB)
  PaintingBinding.instance.imageCache.maximumSizeBytes = 200 * 1024 * 1024;

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

  // Precache these images globally

  runApp(
    ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: PrecacheManager(
        assets: precacheImageList,
        child: const MyApp(),
      ),
    ),
  );
}

class PrecacheManager extends StatefulWidget {
  final Widget child;
  final List<String> assets;

  const PrecacheManager({
    super.key,
    required this.child,
    required this.assets,
  });

  @override
  State<PrecacheManager> createState() => _PrecacheManagerState();
}

class _PrecacheManagerState extends State<PrecacheManager> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAssets());
  }

  Future<void> _loadAssets() async {
    if (kDebugMode) {
      print('🚀 Starting asset precaching...');
    }
    
    for (final asset in widget.assets) {
      try {
        await precacheImage(AssetImage(asset), context);
        if (kDebugMode) {
          print('🖼️ Precached: $asset');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❗ Error precaching $asset: $e');
        }
      }
    }
    
    if (kDebugMode) {
      print('✅ Completed asset precaching');
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pydart Intelli corp',
      debugShowCheckedModeBanner: false,
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