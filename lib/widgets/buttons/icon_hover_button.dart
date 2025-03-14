import 'package:flutter/material.dart';



class IconHoverButton extends StatefulWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const IconHoverButton(
      {required this.iconPath, required this.onPressed, super.key});

  @override
  IconHoverButtonState createState() => IconHoverButtonState();
}

class IconHoverButtonState extends State<IconHoverButton> {
  bool isHovered = false;

  void _onHover(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(50),
        child: AnimatedScale(
          scale: isHovered ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHovered
                  ? const Color.fromARGB(45, 255, 255, 255)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: ImageIcon(
              AssetImage(widget.iconPath),
              color: const Color.fromARGB(255, 110, 114, 116),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
