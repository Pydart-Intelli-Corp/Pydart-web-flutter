import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomSnackbar {
  static bool isDesktop(BuildContext context) {
    return ResponsiveBreakpoints.of(context).largerThan(TABLET);
  }

  static bool isMobile(BuildContext context) {
    return ResponsiveBreakpoints.of(context).equals(MOBILE);
  }

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    Color backgroundColor = Colors.black87,
    IconData icon = Icons.info,
    Duration duration = const Duration(seconds: 4),
    Color borderColor = Colors.white,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double snackbarWidth =
        isDesktop(context) ? screenWidth * 0.3 : screenWidth * 0.9;

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: isDesktop(context) ? 550 : 20,
          left: isDesktop(context) ? screenWidth - snackbarWidth - 15 : 10,
          right: isDesktop(context) ? 15 : 10,
          child: SnackbarWidget(
            title: title,
            message: message,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            icon: icon,
            duration: duration,
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  static void success(BuildContext context, String message) {
    show(
      context: context,
      title: "Success",
      message: message,
      backgroundColor: Colors.green.withOpacity(0.1),
      borderColor: Colors.greenAccent,
      icon: Icons.check_circle,
    );
  }

  static void error(BuildContext context, String message) {
    show(
      context: context,
      title: "Error",
      message: message,
      backgroundColor: Colors.red.withOpacity(0.1),
      borderColor: Colors.redAccent,
      icon: Icons.error,
    );
  }

  static void warning(BuildContext context, String message) {
    show(
      context: context,
      title: "Warning",
      message: message,
      backgroundColor: Colors.orange.withOpacity(0.1),
      borderColor: Colors.orangeAccent,
      icon: Icons.warning,
    );
  }

  static void info(BuildContext context, String message) {
    show(
      context: context,
      title: "Info",
      message: message,
      backgroundColor: Colors.blue.withOpacity(0.1),
      borderColor: Colors.lightBlueAccent,
      icon: Icons.info,
    );
  }
}

class SnackbarWidget extends StatefulWidget {
  final String title;
  final String message;
  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;
  final Duration duration;

  const SnackbarWidget({
    super.key,
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.borderColor,
    required this.icon,
    required this.duration,
  });

  @override
  _SnackbarWidgetState createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<SnackbarWidget>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _opacity,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: widget.borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
