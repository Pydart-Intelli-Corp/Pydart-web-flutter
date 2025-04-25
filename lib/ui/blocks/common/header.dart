import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_website/widgets/Forms/enquiry_Page.dart';
import 'package:flutter_website/widgets/buttons/gradient_button.dart';
import 'package:flutter_website/widgets/notifications/snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:flutter_website/router.dart';
import 'package:flutter_website/ui/blocks/header%20contents/careers.dart';
import 'package:flutter_website/ui/blocks/header%20contents/insights.dart';
import 'package:flutter_website/ui/blocks/header%20contents/services.dart';
import 'package:flutter_website/ui/blocks/header%20contents/whoweare.dart';

import 'package:flutter_website/widgets/buttons/text_hover_button.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationProvider extends ChangeNotifier {
  String _active = 'home';
  String? _previousActive;
  String? _hovered;

  String get active => _active;
  String? get previousActive => _previousActive;
  String? get hovered => _hovered;

  set active(String value) {
    if (_active != value) {
      _previousActive = _active;
      _active = value;
      notifyListeners();
    }
  }

  set hovered(String? value) {
    if (_hovered != value) {
      _hovered = value;
      notifyListeners();
    }
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
  // Variable to hold the previous hovered state.
  String? _previousHovered;
  // Cache the NavigationProvider for safe access.
  late NavigationProvider _navProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache the provider reference once dependencies are available.
    _navProvider = Provider.of<NavigationProvider>(context, listen: false);
  }


  /// Shows the dropdown for the given [dropdown] key.
  /// If another dropdown is open, it is first closed without restoring the hovered state.
  void _showDropdown(String dropdown) {
    if (currentDropdown == dropdown) return;

    if (currentDropdown != null) {
      // Hide any open dropdown without restoring the previous hovered state.
      _hideDropdown(restorePreviousHovered: false);
    }

    currentDropdown = dropdown;
    // Calculate position using the key for the specific dropdown.
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

  /// Hides the currently open dropdown.
  /// If [restorePreviousHovered] is true, the previously stored hovered state is restored.
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
      case 'insights':
        return Insights(
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
        // When auto-closing, restore previous hovered state.
        _hideDropdown();
      });

  @override
  void dispose() {
    // Avoid restoring hovered state on dispose to prevent provider update during tree lock.
    _hideDropdown(restorePreviousHovered: false);
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure this widget is wrapped with a ChangeNotifierProvider<NavigationProvider>
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

  // --- Desktop Header ---
  Widget _buildDesktopHeader() {
    // Provider lookup is safe here.
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
          // Logo (clicking sets active to 'home').
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                navProvider.hovered = 'home';
                navProvider.active = 'home';
                Navigator.pushReplacementNamed(context, Routes.home);
              },
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
          // Home Button (no dropdown).
          MouseRegion(
            child: TextHoverButton(
              label: "Home",
              onPressed: () {
                navProvider.hovered = 'home';
                navProvider.active = 'home';
                Get.toNamed(Routes.home);
              },
              isActive: (navProvider.hovered == 'home') ||
                  (navProvider.hovered == null && navProvider.active == 'home'),
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Who we are" Button with dropdown.
          MouseRegion(
            key: _whoweareKey,
            child: TextHoverButton(
              label: "Who we are",
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false)
                    .hovered = 'whoweare';
                Provider.of<NavigationProvider>(context, listen: false).active =
                    'whoweare';
                Get.toNamed(Routes.whoweare);

                // if (currentDropdown == 'whoweare') {
                //   _hideDropdown();
                // } else {
                //   _previousHovered =
                //       Provider.of<NavigationProvider>(context, listen: false).hovered;
                //   Provider.of<NavigationProvider>(context, listen: false).hovered = 'whoweare';
                //   _showDropdown('whoweare');
                //   Provider.of<NavigationProvider>(context, listen: false).active = 'whoweare';
                // }
              },
              // onDoubleTap: () {
              //   Provider.of<NavigationProvider>(context, listen: false)
              //       .hovered = 'whoweare';
              //   Provider.of<NavigationProvider>(context, listen: false).active =
              //       'whoweare';
              //   Get.toNamed(Routes.whoweare);
              // },
              isActive: (Provider.of<NavigationProvider>(context).hovered ==
                      'whoweare') ||
                  (Provider.of<NavigationProvider>(context).hovered == null &&
                      Provider.of<NavigationProvider>(context).active ==
                          'whoweare'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Our services" Button with dropdown.
          MouseRegion(
            key: _ourservicesKey,
            child: TextHoverButton(
              label: "Our services",
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false)
                    .hovered = 'ourservices';
                Provider.of<NavigationProvider>(context, listen: false).active =
                    'ourservices';
                Get.toNamed(Routes.services);

                // if (currentDropdown == 'ourservices') {
                //   _hideDropdown();
                // } else {
                //   _previousHovered =
                //       Provider.of<NavigationProvider>(context, listen: false).hovered;
                //   Provider.of<NavigationProvider>(context, listen: false).hovered = 'ourservices';
                //   _showDropdown('ourservices');
                //   Provider.of<NavigationProvider>(context, listen: false).active = 'ourservices';
                // }
              },
              // onDoubleTap: () {
              //   Provider.of<NavigationProvider>(context, listen: false)
              //       .hovered = 'ourservices';
              //   Provider.of<NavigationProvider>(context, listen: false).active =
              //       'ourservices';
              //   Navigator.pushReplacementNamed(context, Routes.services);
              // },
              isActive: (Provider.of<NavigationProvider>(context).hovered ==
                      'ourservices') ||
                  (Provider.of<NavigationProvider>(context).hovered == null &&
                      Provider.of<NavigationProvider>(context).active ==
                          'ourservices'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Insights" Button with dropdown.
          MouseRegion(
            key: _insightsKey,
            child: TextHoverButton(
              label: "Insights",
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false)
                    .hovered = 'insights';
                Provider.of<NavigationProvider>(context, listen: false).active =
                    'insights';
                Get.toNamed(Routes.insights);

                // if (currentDropdown == 'insights') {
                //   _hideDropdown();
                // } else {
                //   _previousHovered =
                //       Provider.of<NavigationProvider>(context, listen: false).hovered;
                //   Provider.of<NavigationProvider>(context, listen: false).hovered = 'insights';
                //   _showDropdown('insights');
                //   Provider.of<NavigationProvider>(context, listen: false).active = 'insights';
                // }
              },
              // onDoubleTap: () {
              //   Provider.of<NavigationProvider>(context, listen: false)
              //       .hovered = 'insights';
              //   Provider.of<NavigationProvider>(context, listen: false).active =
              //       'insights';
              //   Navigator.pushReplacementNamed(context, Routes.insights);
              // },
              isActive: (navProvider.hovered == 'insights') ||
                  (navProvider.hovered == null &&
                      navProvider.active == 'insights'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Careers" Button with dropdown.
          MouseRegion(
            key: _careersKey,
            child: TextHoverButton(
              label: "Careers",
              onPressed: () {
                Provider.of<NavigationProvider>(context, listen: false)
                    .hovered = 'careers';
                Provider.of<NavigationProvider>(context, listen: false).active =
                    'careers';
                Get.toNamed(Routes.career);

                // if (currentDropdown == 'careers') {
                //   _hideDropdown();
                // } else {
                //   _previousHovered =
                //       Provider.of<NavigationProvider>(context, listen: false).hovered;
                //   Provider.of<NavigationProvider>(context, listen: false).hovered = 'careers';
                //   _showDropdown('careers');
                //   Provider.of<NavigationProvider>(context, listen: false).active = 'careers';
                // }
              },
              // onDoubleTap: () {
              //   Provider.of<NavigationProvider>(context, listen: false)
              //       .hovered = 'careers';
              //   Provider.of<NavigationProvider>(context, listen: false).active =
              //       'careers';
              //   Get.toNamed(Routes.whoweare);
              // },
              isActive: (navProvider.hovered == 'careers') ||
                  (navProvider.hovered == null &&
                      navProvider.active == 'careers'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const Spacer(),
          // "About" Button (non-dropdown).
          SecondaryGradientButton(
            onPressed: (){  CustomSnackbar.info(context, "Coming soon ");},
            text: "Pystore",
          ),
          const SizedBox(width: 32),
          // "Contact Us" Button.
          PrimaryGradientButton(
            onPressed: () {
              _showDetailsPopup(context, 'Mobile Application');
            },
            text: "Enquire Now ",
          )
        ],
      ),
    );
  }


  // --- Mobile Header ---
 // Replace the existing _buildMobileHeader() and _buildMobileMenu() methods with these:

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
      opaque: false, // This is crucial
      barrierColor: Colors.transparent, // Remove default barrier
    ),
  );
}
class RightSlideMenu extends StatelessWidget {
  const RightSlideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Transparent click layer
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          
          // Menu content with shadow-only styling
          Transform.translate(
            offset: Offset(width * 0.2, 0),
            child: Container(
              width: width * 0.8,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 6,
                                    offset: Offset(1, 1),
                                  )
                                ]),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _buildGhostMenuItem(
                            icon: Icons.home,
                            title: 'Home',
                            onTap: () => _handleNavigation(context, Routes.home, 'home'),
                          ),
                          // Repeat for other menu items
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: _buildGhostButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _showDetailsPopup(context, 'Mobile Application');
                              },
                              text: "Enquire Now",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGhostMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            children: [
              Icon(icon,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: const Offset(1, 1),
          )]),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: const Offset(1, 1),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGhostButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 6,
                  offset: const Offset(1, 1),
             ) ],
            ),
          ),
        ),
      ),
    );
  }
}

  void _handleNavigation(BuildContext context, String route, String active) {
    Navigator.pop(context);
    Provider.of<NavigationProvider>(context, listen: false).active = active;
    Get.toNamed(route);
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