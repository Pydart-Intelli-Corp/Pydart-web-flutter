import 'package:flutter/material.dart';




class LoadingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color buttonColor;
  final Color hoverColor;
  final Color onClickColor;
  final Color textColor;
  final double textSize;
  final FontWeight textWeight;
  final double buttonWidth;
  final double buttonHeight;
  final bool isLoading;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.buttonColor,
    required this.hoverColor,
    required this.onClickColor,
    required this.textColor,
    required this.textSize,
    required this.textWeight,
    required this.buttonWidth,
    required this.buttonHeight,
    this.isLoading = false,
  });

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton> {
  bool isHovered = false;

  void _onHover(bool hover) {
    setState(() {
      isHovered = hover;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonWidth,
      height: widget.buttonHeight,
      child: MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(0),
          child: AnimatedScale(
            scale: isHovered && !widget.isLoading ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: widget.isLoading
                    ? widget.buttonColor.withOpacity(0.7)
                    : (isHovered ? widget.hoverColor : widget.buttonColor),
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Center(
                child: widget.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: widget.textSize,
                          fontWeight: widget.textWeight,
                          color: widget.textColor,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}