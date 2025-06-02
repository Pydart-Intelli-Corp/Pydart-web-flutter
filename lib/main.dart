import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart'; // Added for custom scroll physics
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:pydart/preload.dart';
import 'package:pydart/ui/blocks/common/header.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:url_strategy/url_strategy.dart';
import 'router.dart';

// Optimized scroll physics for ultra-smooth scrolling
class OptimizedScrollPhysics extends ScrollPhysics {
  const OptimizedScrollPhysics({ScrollPhysics? parent}) 
      : super(parent: parent);

  @override
  OptimizedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return OptimizedScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5; // More responsive

  @override
  double frictionFactor(double overscrollFraction) => 0.12; // Lower friction

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 80,
    stiffness: 100,
    damping: 1,
  );
  
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (offset == 0.0) return 0.0;
    return offset * 0.9; // Slightly reduce sensitivity for smoother feel
  }
}

// Enhanced scroll behavior with no glow effect for entire app
class EnhancedScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
  
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const OptimizedScrollPhysics();
  }
  
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  // Optimized gesture detector for smoother scrolling
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}

// Custom scroll wrapper that works with responsive framework
class EnhancedClampingScrollWrapper extends StatelessWidget {
  final Widget child;
  
  const EnhancedClampingScrollWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  static Widget builder(BuildContext context, Widget? child) {
    return ScrollConfiguration(
      behavior: EnhancedScrollBehavior(),
      child: rf.ClampingScrollWrapper.builder(context, child!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: EnhancedScrollBehavior(),
      child: child,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  // Disable debug modes that affect performance
  debugProfileBuildsEnabled = false;
  debugProfilePaintsEnabled = false;

  // Configure image cache size (200MB)
  PaintingBinding.instance.imageCache.maximumSizeBytes = 200 * 1024 * 1024;
  // Add more aggressive caching policy for frequently accessed images
  PaintingBinding.instance.imageCache.maximumSize = 200; // Number of images to cache

  // Debug: Print all registered routes
  if (kDebugMode) {
    print('🛣️ Registered routes:');
    for (var page in Routes.pages) {
      print('  Route: ${page.name}');
    }
  }

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

  // Create and register NavigationProvider with GetX
  final navigationProvider = NavigationProvider();
  Get.put(navigationProvider);

  runApp(
    ChangeNotifierProvider.value(
      value: navigationProvider,
      child: OptimizedPrecacheManager(
        assets: precacheImageList,
        child: const MyApp(),
      ),
    ),
  );
}

// Enhanced precache manager with better performance
class OptimizedPrecacheManager extends StatefulWidget {
  final Widget child;
  final List<String> assets;

  const OptimizedPrecacheManager({
    super.key,
    required this.child,
    required this.assets,
  });

  @override
  State<OptimizedPrecacheManager> createState() => _OptimizedPrecacheManagerState();
}

class _OptimizedPrecacheManagerState extends State<OptimizedPrecacheManager> {
  bool _precachingComplete = false;
  
  @override
  void initState() {
    super.initState();
    // Use a microtask to avoid delaying app startup
    Future.microtask(() => _loadAssets());
  }

  Future<void> _loadAssets() async {
    if (kDebugMode) {
      print('🚀 Starting asset precaching...');
    }
    
    // Create batches of futures to avoid blocking the UI thread
    const int batchSize = 5;
    final int totalBatches = (widget.assets.length / batchSize).ceil();
    
    for (int i = 0; i < totalBatches; i++) {
      final int start = i * batchSize;
      final int end = (start + batchSize < widget.assets.length) 
          ? start + batchSize 
          : widget.assets.length;
      
      final batch = widget.assets.sublist(start, end);
      final futures = batch.map((asset) => _precacheSingleAsset(asset));
      
      // Process batch in parallel
      await Future.wait(futures);
      
      // Allow UI to breathe between batches
      await Future.delayed(const Duration(milliseconds: 5));
    }
    
    if (mounted) {
      setState(() => _precachingComplete = true);
    }
    
    if (kDebugMode) {
      print('✅ Completed asset precaching');
    }
  }
  
  Future<void> _precacheSingleAsset(String asset) async {
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

  @override
  Widget build(BuildContext context) {
    // Use RepaintBoundary to prevent precaching from affecting UI
    return RepaintBoundary(
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pydart Intelli corp',
      debugShowCheckedModeBanner: false,
      
      getPages: Routes.pages,
      
      // Enhanced routing callback with NavigationProvider integration
      routingCallback: (routing) {
        if (kDebugMode) {
          print('🚀 Routing to: ${routing?.current}');
          print('📍 Previous route: ${routing?.previous}');
        }
        
        // Update NavigationProvider when routes change
        if (routing?.current != null) {
          try {
            // Get the NavigationProvider instance and update it
            final navProvider = Get.find<NavigationProvider>();
            navProvider.onRouteChange(routing!.current);
          } catch (e) {
            if (kDebugMode) {
              print('⚠️ NavigationProvider not found or error updating: $e');
            }
          }
        }
      },
      
      // Handle unknown routes
      unknownRoute: GetPage(
        name: '/404',
        page: () => Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Page Not Found',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The page you are looking for does not exist.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Get.offNamed(Routes.home),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE58742),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
      // Apply scroll behavior globally
      scrollBehavior: EnhancedScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFE58742),
        primaryColorLight: const Color(0xFFEDA53F),
        // Add scroll-specific theme options
        platform: TargetPlatform.android, // Force Android scrolling behavior which is smoother
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
              // Use enhanced scroll wrapper instead of default
              child: EnhancedClampingScrollWrapper.builder(context, widget),
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