import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_website/widgets/Forms/enquiry_Page.dart';
import 'package:flutter_website/widgets/buttons/gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_website/router.dart';
import 'package:flutter_website/ui/blocks/header%20contents/careers.dart';
import 'package:flutter_website/ui/blocks/header%20contents/insights.dart';
import 'package:flutter_website/ui/blocks/header%20contents/services.dart';
import 'package:flutter_website/ui/blocks/header%20contents/whoweare.dart';
import 'package:flutter_website/widgets/buttons/loading_button.dart';
import 'package:flutter_website/widgets/buttons/text_hover_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// Provider holding the current active (clicked) navigation ID and hovered state.
class NavigationProvider extends ChangeNotifier {
  String _active = 'home';
  String? _hovered;

  String get active => _active;
  String? get hovered => _hovered;

  set active(String value) {
    if (_active != value) {
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

  void openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showDropdown(String dropdown) {
    if (currentDropdown == dropdown) return;
    _hideDropdown();
    currentDropdown = dropdown;

    // Use one key (e.g. _whoweareKey) for position calculation.
    final RenderBox? renderBox =
        _whoweareKey.currentContext?.findRenderObject() as RenderBox?;
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

  void _hideDropdown() {
    currentDropdown = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
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
      _autoCloseTimer = Timer(const Duration(milliseconds: 200), _hideDropdown);

  @override
  void dispose() {
    _hideDropdown();
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
            onEnter: (_) => navProvider.hovered = 'home',
            onExit: (_) => navProvider.hovered = null,
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                navProvider.active = 'home';
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Image.asset(
                  "assets/logos/logo.png",
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Home Button (no dropdown).
          MouseRegion(
            onEnter: (_) => navProvider.hovered = 'home',
            onExit: (_) => navProvider.hovered = null,
            child: TextHoverButton(
              label: "Home",
              onPressed: () {
                navProvider.active = 'home';
                  Navigator.pushReplacementNamed(context, Routes.home);
           
              },
              // Show underline if this button is hovered or (if not hovered and it is active).
              isActive: (navProvider.hovered == 'home') ||
                  (navProvider.hovered == null && navProvider.active == 'home'),
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Who we are" Button with dropdown.
        // "Who we are" Button with dropdown.
MouseRegion(
  key: _whoweareKey,
  onEnter: (_) {
    // Only show the dropdown if the active page is not 'whoweare'.
    if (Provider.of<NavigationProvider>(context, listen: false).active != 'whoweare') {
      Provider.of<NavigationProvider>(context, listen: false).hovered = 'whoweare';
      _showDropdown('whoweare');
    }
  },
  onExit: (_) {
    Provider.of<NavigationProvider>(context, listen: false).hovered = null;
    _scheduleAutoClose();
  },
  child: TextHoverButton(
    label: "Who we are",
    onPressed: () {
      _hideDropdown();
      Provider.of<NavigationProvider>(context, listen: false).active = 'whoweare';
      Navigator.pushReplacementNamed(context, Routes.about);
    },
    isActive: (Provider.of<NavigationProvider>(context).hovered == 'whoweare') ||
        (Provider.of<NavigationProvider>(context).hovered == null &&
         Provider.of<NavigationProvider>(context).active == 'whoweare'),
    showArrow: true,
    color: navLinkColor,
  ),
),

          const SizedBox(width: 32),
          // "Our services" Button with dropdown.
          MouseRegion(
            key: _ourservicesKey,
  onEnter: (_) {
    // Only show the dropdown if the active page is not 'whoweare'.
    if (Provider.of<NavigationProvider>(context, listen: false).active != 'ourservices') {
      Provider.of<NavigationProvider>(context, listen: false).hovered = 'ourservices';
      _showDropdown('ourservices');
    }
  },
            onExit: (_) {
              navProvider.hovered = null;
              _scheduleAutoClose();
            },
            child: TextHoverButton(
              label: "Our services",
              onPressed: () {  _hideDropdown();
                navProvider.active = 'ourservices';
              
      Provider.of<NavigationProvider>(context, listen: false).active = 'ourservices';
      Navigator.pushReplacementNamed(context, Routes.services);
              },
                isActive: (Provider.of<NavigationProvider>(context).hovered == 'ourservices') ||
        (Provider.of<NavigationProvider>(context).hovered == null &&
         Provider.of<NavigationProvider>(context).active == 'ourservices'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Insights" Button with dropdown.
          MouseRegion(
            key: _insightsKey,
            onEnter: (_) {
              navProvider.hovered = 'insights';
              _showDropdown('insights');
            },
            onExit: (_) {
              navProvider.hovered = null;
              _scheduleAutoClose();
            },
            child: TextHoverButton(
              label: "Insights",
              onPressed: () {
                navProvider.active = 'insights';
              },
              isActive: (navProvider.hovered == 'insights') ||
                  (navProvider.hovered == null && navProvider.active == 'insights'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const SizedBox(width: 32),
          // "Careers" Button with dropdown.
          MouseRegion(
            key: _careersKey,
            onEnter: (_) {
              navProvider.hovered = 'careers';
              _showDropdown('careers');
            },
            onExit: (_) {
              navProvider.hovered = null;
              _scheduleAutoClose();
            },
            child: TextHoverButton(
              label: "Careers",
              onPressed: () {
                navProvider.active = 'careers';
              },
              isActive: (navProvider.hovered == 'careers') ||
                  (navProvider.hovered == null && navProvider.active == 'careers'),
              showArrow: true,
              color: navLinkColor,
            ),
          ),
          const Spacer(),
          // "About" Button (non-dropdown).
          SecondaryGradientButton(
          
            onPressed: () => openUrl('https://www.tcs.com/services'),
           text: "Pystore",
          ),
          const SizedBox(width: 32),
          // "Contact Us" Button.
         PrimaryGradientButton(onPressed: () { _showDetailsPopup(context, 'Mobile Application'); },
         text: "Enquire Now ",)
        ],
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
  // --- Mobile Header (simplified) ---
  Widget _buildMobileHeader() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 3, 10, 14),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          "assets/logos/logo.png",
          height: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: const Text(''),
      actions: [
        TextButton(
          onPressed: () => openUrl('https://www.tcs.com/services'),
          child: const Text(
            'About',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () => openUrl('https://www.tcs.com/services'),
          child: const Text(
            'Contact Us',
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => _buildMobileMenu(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMobileMenu() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Provider.of<NavigationProvider>(context, listen: false).active =
                  'home';
             Navigator.pushReplacementNamed(context, Routes.home);
           
            },
          ),
          ListTile(
            title: const Text('Who we are'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Provider.of<NavigationProvider>(context, listen: false).active =
                  'whoweare';
            Navigator.pushReplacementNamed(context, Routes.about);
           
            },
          ),
          ListTile(
            title: const Text('Our services'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Provider.of<NavigationProvider>(context, listen: false).active =
                  'ourservices';
              Navigator.pop(context);
              openUrl('https://www.tcs.com/services');
            },
          ),
          ListTile(
            title: const Text('Insights'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Provider.of<NavigationProvider>(context, listen: false).active =
                  'insights';
              Navigator.pop(context);
              openUrl('https://www.tcs.com/services');
            },
          ),
          ListTile(
            title: const Text('Careers'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Provider.of<NavigationProvider>(context, listen: false).active =
                  'careers';
              Navigator.pop(context);
              openUrl('https://www.tcs.com/services');
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              openUrl('https://www.tcs.com/services');
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pop(context);
              openUrl('https://www.tcs.com/services');
            },
          ),
        ],
      ),
    );
  }
}
