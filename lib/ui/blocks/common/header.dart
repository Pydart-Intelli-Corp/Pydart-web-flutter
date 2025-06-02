import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pydart/components/colors.dart' as AppColors;
import 'package:pydart/widgets/Forms/enquiry_Page.dart';
import 'package:pydart/widgets/buttons/gradient_button.dart';
import 'package:pydart/widgets/notifications/snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:pydart/router.dart';
import 'package:pydart/ui/blocks/header%20contents/careers.dart';
import 'package:pydart/ui/blocks/header%20contents/insights.dart';
import 'package:pydart/ui/blocks/header%20contents/services.dart';
import 'package:pydart/ui/blocks/header%20contents/whoweare.dart';
import 'package:pydart/widgets/buttons/text_hover_button.dart';
import 'package:url_launcher/url_launcher.dart';

// Updated NavigationProvider that's route-aware
class NavigationProvider extends ChangeNotifier {
  String _active = 'home';
  String? _previousActive;
  String? _hovered;

  NavigationProvider() {
    _initializeRouteListener();
  }

  String get active => _active;
  String? get previousActive => _previousActive;
  String? get hovered => _hovered;
 void onRouteChange(String? newRoute) {
    if (newRoute != null) {
      String newActive = _routeToNavigationKey(newRoute);
      
      if (_active != newActive) {
        _previousActive = _active;
        _active = newActive;
        notifyListeners();
      }
    }
  }
  // Convert route to navigation key
  String _routeToNavigationKey(String route) {
    switch (route) {
      case Routes.home:
        return 'home';
      case Routes.whoweare:
        return 'whoweare';
      case Routes.services:
        return 'ourservices';
      case Routes.career:
        return 'careers';
      default:
        return 'home';
    }
  }

  // Convert navigation key to route
  String _navigationKeyToRoute(String key) {
    switch (key) {
      case 'home':
        return Routes.home;
      case 'whoweare':
        return Routes.whoweare;
      case 'ourservices':
        return Routes.services;
      case 'careers':
        return Routes.career;
      default:
        return Routes.home;
    }
  }

  void _initializeRouteListener() {
    // Set initial active based on current route
    _updateActiveFromCurrentRoute();
  }
  
  // Call this method whenever a navigation occurs
  void updateFromRoute() {
    _updateActiveFromCurrentRoute();
  }
  
  // Helper method to manually sync with current route (useful for browser navigation)
  void syncWithCurrentRoute() {
    _updateActiveFromCurrentRoute();
  }

  void _updateActiveFromCurrentRoute() {
    String currentRoute = Get.currentRoute;
    String newActive = _routeToNavigationKey(currentRoute);
    
    if (_active != newActive) {
      _previousActive = _active;
      _active = newActive;
      notifyListeners();
    }
  }

  // Navigate to a section and update the route
  void navigateTo(String navigationKey) {
    String route = _navigationKeyToRoute(navigationKey);
    
    // Clear hover state
    _hovered = null;
    
    // Update active state before navigation
    if (_active != navigationKey) {
      _previousActive = _active;
      _active = navigationKey;
      notifyListeners();
    }
    
    // Navigate to the route
    Get.toNamed(route);
  }

  // Backward compatibility setter for active
  set active(String value) {
    if (_active != value) {
      _previousActive = _active;
      _active = value;
      
      // Navigate to the corresponding route
      String route = _navigationKeyToRoute(value);
      Get.toNamed(route);
      
      notifyListeners();
    }
  }

  set hovered(String? value) {
    if (_hovered != value) {
      _hovered = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final Color navLinkColor = Colors.white;
  // Global keys for dropdown placement on desktop.
  final GlobalKey _whoweareKey = GlobalKey();
  final GlobalKey _ourservicesKey = GlobalKey();
  final GlobalKey _careersKey = GlobalKey();
  final GlobalKey _insightsKey = GlobalKey();

  String? currentDropdown;
  OverlayEntry? _overlayEntry;
  Timer? _autoCloseTimer;
  String? _previousHovered;
  late NavigationProvider _navProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navProvider = Provider.of<NavigationProvider>(context, listen: false);
  }

  void _showDropdown(String dropdown) {
    if (currentDropdown == dropdown) return;

    if (currentDropdown != null) {
      _hideDropdown(restorePreviousHovered: false);
    }

    currentDropdown = dropdown;
    GlobalKey keyForDropdown;
    switch (dropdown) {
      case 'whoweare':
        keyForDropdown = _whoweareKey;
        break;
      case 'ourservices':
        keyForDropdown = _ourservicesKey;
        break;
      case 'insights':
        keyForDropdown = _insightsKey;
        break;
      case 'careers':
        keyForDropdown = _careersKey;
        break;
      default:
        return;
    }

    final RenderBox? renderBox =
        keyForDropdown.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        child: MouseRegion(
          onEnter: (_) => _cancelAutoClose(),
          onExit: (_) => _scheduleAutoClose(),
          child: _buildDropdownContent(dropdown),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown({bool restorePreviousHovered = true}) {
    currentDropdown = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (restorePreviousHovered) {
      _navProvider.hovered = _previousHovered ?? 'home';
      _previousHovered = null;
    }
  }

  Widget _buildDropdownContent(String dropdown) {
    switch (dropdown) {
      case 'whoweare':
        return WhoWeAreContent(
          onItemPressed: _hideDropdown,
          openUrl: openUrl,
        );
      case 'ourservices':
        return OurServices(
          onItemPressed: _hideDropdown,
          openUrl: openUrl,
        );
      case 'careers':
        return CareersContent(
          onItemPressed: _hideDropdown,
          openUrl: openUrl,
        );
      default:
        return Container();
    }
  }

  void _cancelAutoClose() => _autoCloseTimer?.cancel();

  void _scheduleAutoClose() =>
      _autoCloseTimer = Timer(const Duration(milliseconds: 200), () {
        _hideDropdown();
      });

  @override
  void dispose() {
    _hideDropdown(restorePreviousHovered: false);
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileHeader();
        } else {
          return _buildDesktopHeader();
        }
      },
    );
  }

  Widget _buildDesktopHeader() {
    final navProvider = Provider.of<NavigationProvider>(context);
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 3, 10, 14),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 47, 47, 47),
            offset: Offset(0, 0.01),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          // Logo (clicking navigates to home)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => navProvider.navigateTo('home'),
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: SizedBox(
                  height: 100,
                  width: 150,
                  child: SvgPicture.asset(
                    "assets/logos/pydart-logo.svg",
                    semanticsLabel: 'Pydart Logo',
                    fit: BoxFit.scaleDown,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
              ),
            ),
          ),
          // Home Button
          MouseRegion(
            child: TextHoverButton(
              label: "Home",
              onPressed: () => navProvider.navigateTo('home'),
              isActive: (navProvider.hovered == 'home') ||
                  (navProvider.hovered == null && navProvider.active == 'home'),
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Who we are" Button
          MouseRegion(
            key: _whoweareKey,
            child: TextHoverButton(
              label: "Who we are",
              onPressed: () => navProvider.navigateTo('whoweare'),
              isActive: (navProvider.hovered == 'whoweare') ||
                  (navProvider.hovered == null && navProvider.active == 'whoweare'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Our services" Button
          MouseRegion(
            key: _ourservicesKey,
            child: TextHoverButton(
              label: "Our services",
              onPressed: () => navProvider.navigateTo('ourservices'),
              isActive: (navProvider.hovered == 'ourservices') ||
                  (navProvider.hovered == null && navProvider.active == 'ourservices'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Careers" Button
          MouseRegion(
            key: _careersKey,
            child: TextHoverButton(
              label: "Careers",
              onPressed: () => navProvider.navigateTo('careers'),
              isActive: (navProvider.hovered == 'careers') ||
                  (navProvider.hovered == null && navProvider.active == 'careers'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const Spacer(),
          // "Pystore" Button
          SecondaryGradientButton(
            onPressed: () => CustomSnackbar.info(context, "Coming soon "),
            text: "Pystore",
          ),
          const SizedBox(width: 32),
          // "Contact Us" Button
          PrimaryGradientButton(
            onPressed: () => _showDetailsPopup(context, 'Mobile Application'),
            text: "Enquire Now ",
          )
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 3, 10, 14),
      leadingWidth: 150,
      leading: SizedBox(
        width: 130,
        height: 60,
        child: SvgPicture.asset(
          "assets/logos/pydart-logo.svg",
          semanticsLabel: 'Pydart Logo',
          fit: BoxFit.fill,
          allowDrawingOutsideViewBox: true,
        ),
      ),
      title: const Text(''),
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _showRightSlideMenu(context),
        ),
      ],
    );
  }

  void _showRightSlideMenu(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RightSlideMenu(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        opaque: false,
        barrierColor: Colors.transparent,
      ),
    );
  }

  void _showDetailsPopup(BuildContext context, String dropdownValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResponsiveDialog(dropdownValue: dropdownValue);
      },
    );
  }

  void openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class RightSlideMenu extends StatefulWidget {
  const RightSlideMenu({super.key});

  @override
  State<RightSlideMenu> createState() => _RightSlideMenuState();
}

class _RightSlideMenuState extends State<RightSlideMenu> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  final List<bool> _itemVisibility = List.generate(6, (index) => false);
  final List<double> _itemScale = List.generate(6, (index) => 1.0);

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));

    _controller.forward().then((_) {
      for (int i = 0; i < _itemVisibility.length; i++) {
        Future.delayed(Duration(milliseconds: 100 * i), () {
          setState(() => _itemVisibility[i] = true);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: width * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.pydart.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.5
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: _buildMenuContent(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuContent(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMenuHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                _buildAnimatedMenuItem(
                  index: 0,
                  icon: Icons.home_filled,
                  title: 'Home',
                  navigationKey: 'home',
                ),
                _buildAnimatedMenuItem(
                  index: 1,
                  icon: Icons.people_alt_rounded,
                  title: 'Who We Are',
                  navigationKey: 'whoweare',
                ),
                _buildAnimatedMenuItem(
                  index: 2,
                  icon: Icons.design_services_rounded,
                  title: 'Our Services',
                  navigationKey: 'ourservices',
                ),
                _buildAnimatedMenuItem(
                  index: 4,
                  icon: Icons.work_history_rounded,
                  title: 'Careers',
                  navigationKey: 'careers',
                ),
                const SizedBox(height: 32),
                _buildAnimatedButton(
                  index: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: PrimaryGradientButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showDetailsPopup(context, 'Mobile Application');
                      },
                      text: "Enquire Now",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMenuItem({
    required int index,
    required IconData icon,
    required String title,
    required String navigationKey,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _itemScale[index] = 1.05),
      onExit: (_) => setState(() => _itemScale[index] = 1.0),
      child: AnimatedOpacity(
        opacity: _itemVisibility[index] ? 1 : 0,
        duration: Duration(milliseconds: 300 + (index * 50)),
        curve: Curves.easeOutQuint,
        child: AnimatedSlide(
          duration: Duration(milliseconds: 400 + (index * 50)),
          offset: _itemVisibility[index] 
              ? Offset.zero 
              : const Offset(0.5, 0),
          child: ScaleTransition(
            scale: Tween(begin: 0.7, end: _itemScale[index].toDouble())
              .animate(CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  0.3 + (index * 0.1),
                  1.0,
                  curve: Curves.elasticOut,
                ),
              )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Card(
                margin: EdgeInsets.zero,
                color: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1
                  ),
                ),
                child: InkWell(
                  onTap: () => _handleNavigation(context, navigationKey),
                  borderRadius: BorderRadius.circular(15),
                  splashColor: AppColors.pydart.withOpacity(0.2),
                  highlightColor: AppColors.pydart.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.white70, size: 24),
                        const SizedBox(width: 20),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded,
                          color: AppColors.pydart, size: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70, size: 28),
            onPressed: () => Navigator.pop(context),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required int index,
    required Widget child,
  }) {
    return AnimatedOpacity(
      opacity: _itemVisibility[index] ? 1 : 0,
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutQuad,
      child: AnimatedSlide(
        duration: Duration(milliseconds: 300 + (index * 50)),
        offset: _itemVisibility[index] ? Offset.zero : const Offset(0, 0.5),
        child: child,
      ),
    );
  }

  void _handleNavigation(BuildContext context, String navigationKey) {
    Navigator.pop(context);
    Provider.of<NavigationProvider>(context, listen: false).navigateTo(navigationKey);
  }

  void _showDetailsPopup(BuildContext context, String dropdownValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResponsiveDialog(dropdownValue: dropdownValue);
      },
    );
  }
}

