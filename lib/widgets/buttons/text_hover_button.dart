import 'package:flutter/material.dart';

class TextHoverButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onDoubleTap; // Added double click callback
  final Color color;
  final bool showArrow;
  final bool isActive;

  const TextHoverButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.onDoubleTap, // Added double click callback
    this.color = Colors.white,
    this.showArrow = false,
    this.isActive = false,
  }) : super(key: key);

  @override
  _TextHoverButtonState createState() => _TextHoverButtonState();
}

class _TextHoverButtonState extends State<TextHoverButton> {
  final GlobalKey _rowKey = GlobalKey();
  double _rowWidth = 0;

  @override
  void initState() {
    super.initState();
    // Measure the width of the row after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox =
          _rowKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _rowWidth = renderBox.size.width;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: (widget.onPressed != null || widget.onDoubleTap != null)
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onPressed,
        onDoubleTap: widget.onDoubleTap, // Listen for double taps
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row with label and optional arrow.
            Row(
              key: _rowKey,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ),
                ),
             if (widget.showArrow) ...[
  const SizedBox(width: 4),
  Icon(
    widget.isActive
        ? Icons.keyboard_arrow_up_sharp
        : Icons.keyboard_arrow_down_sharp,
    color: widget.color,
    size: 20,
  ),
],

              ],
            ),
            const SizedBox(height: 2),
            // Underline shows if isActive is true.
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: widget.isActive ? _rowWidth : 0,
              color: widget.color,
            ),
          ],
        ),
      ),
    );
  }
}
