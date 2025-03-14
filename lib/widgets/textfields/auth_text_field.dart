import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
bool iscredValid=false;
enum AuthFieldType {
  email,
  password,
  mobile,
  text,
  otp, // Added otp type
}

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final AuthFieldType fieldType;
  final bool showButton;
  final VoidCallback? onButtonPressed;
    final VoidCallback? onTap;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.validator,
    this.fieldType = AuthFieldType.text,
    this.showButton = false,
    this.onButtonPressed,
        this.onTap,
  });

  @override
  AuthTextFieldState createState() => AuthTextFieldState();
}

class AuthTextFieldState extends State<AuthTextField> {
  bool _isHovering = false;
  final FocusNode _focusNode = FocusNode();
  String? _errorText;
  late bool _obscureText;
  bool _canResend = false;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.fieldType == AuthFieldType.password ? true : widget.obscureText;
    widget.controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
        _startResendTimer();
  }
  
  
  void _handleTextChange() {
  setState(() {
    if (widget.controller.text.isEmpty) {
      _errorText = 'This field is required';
    } else if (widget.fieldType == AuthFieldType.password) {
      if (widget.controller.text.length < 8) {
        _errorText = 'Password must be at least 8 characters';
      } else {
        _errorText = null; // Clear error when password is valid
      }
    } else if (widget.fieldType == AuthFieldType.email) {
      _errorText = _isValidEmail(widget.controller.text)
          ? null
          : 'Please enter a valid email address';
    } else if (widget.fieldType == AuthFieldType.otp) {
      _errorText = widget.controller.text.length == 6
          ? null
          : 'OTP must be 6 numbers';
    } 
    else if (widget.fieldType == AuthFieldType.mobile) {
      _errorText = widget.controller.text.length == 10
          ? null
          : 'Mobile Number must be 10 numbers';
    } 
    else {
      _errorText = null;
    }

    // Ensure the field turns green when valid
    iscredValid = _errorText == null && widget.controller.text.isNotEmpty;
  });
}
void _startResendTimer() {
    setState(() {
      _canResend = false;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer(const Duration(seconds: 15), () {
      setState(() {
        _canResend = true;
      });
    });
  }
  void _handleFocusChange() {
    if (widget.fieldType == AuthFieldType.otp && _focusNode.hasFocus) {
      _startResendTimer();
    }
    if (!_focusNode.hasFocus) {
      setState(() {
        _errorText = (widget.validator ?? _defaultValidator)(widget.controller.text);
      });
    }
  }


  String? _defaultValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter ${widget.labelText}';
    }
    if (widget.fieldType == AuthFieldType.email && !_isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    if (widget.fieldType == AuthFieldType.mobile &&
        !RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    if (widget.fieldType == AuthFieldType.otp && value.length != 6) {
      return 'OTP must be 6 Numbers';
    }
        if (widget.fieldType == AuthFieldType.mobile && value.length != 10) {
      return 'Mobile Number must be 10 Numbers';
    }


    
    return null;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
      _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    switch (widget.fieldType) {
      case AuthFieldType.email:
        keyboardType = TextInputType.emailAddress;
        break;
      case AuthFieldType.mobile:
        keyboardType = TextInputType.phone;
        break;
      case AuthFieldType.password:
        keyboardType = TextInputType.visiblePassword;
        break;
      case AuthFieldType.otp:
        keyboardType = TextInputType.number;
        break;
      default:
        keyboardType = TextInputType.text;
    }

    bool isEmailValid = widget.fieldType == AuthFieldType.email &&
        _isValidEmail(widget.controller.text);
bool isPasswordValid = widget.fieldType == AuthFieldType.password &&
    widget.controller.text.length >= 8;

    bool isOtpValid = widget.fieldType == AuthFieldType.otp &&
        widget.controller.text.length == 6;

          bool isMobileValid = widget.fieldType == AuthFieldType.mobile &&
        widget.controller.text.length == 10;


    Color effectiveFillColor = _isHovering ? Colors.black45 : Colors.black54;
    Color effectiveLabelColor = _isHovering ? Colors.white : Colors.white70;
    Color effectiveIconColor = _isHovering
        ? Colors.white
        : const Color.fromRGBO(255, 255, 255, 0.702);

Color effectiveBorderColor = _errorText != null
    ? Colors.redAccent // Red border for error
    : (isPasswordValid||isMobileValid || isEmailValid || isOtpValid)
        ? const Color.fromARGB(181, 56, 134, 49) // Green for valid input
        : (_isHovering
            ? const Color.fromARGB(255, 27, 69, 111)
            : Colors.white70);


    Color effectiveEnabledBorderColor = (isPasswordValid||isMobileValid || isEmailValid || isOtpValid)
        ? const Color.fromARGB(181, 56, 134, 49)
        : (_isHovering
            ? const Color.fromARGB(255, 27, 69, 111)
            : Colors.white54);

    Color effectiveFocusedBorderColor = (isPasswordValid || isMobileValid||isEmailValid || isOtpValid)
        ? const Color.fromARGB(181, 56, 134, 49)
        : const Color.fromARGB(255, 27, 69, 111);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: TextFormField(
  focusNode: _focusNode,
  controller: widget.controller,
  keyboardType: keyboardType,
  obscureText: widget.fieldType == AuthFieldType.password
      ? _obscureText
      : widget.obscureText,
  style: const TextStyle(color: Colors.white),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return widget.validator != null ? widget.validator!(value) : null;
  },
maxLength: widget.fieldType == AuthFieldType.otp ? 6 : 
            widget.fieldType == AuthFieldType.mobile ? 10 : null,

inputFormatters: (widget.fieldType == AuthFieldType.otp || widget.fieldType == AuthFieldType.mobile)
    ? [FilteringTextInputFormatter.digitsOnly]
    : null,

  decoration: InputDecoration(
    counterText: "",  // Hide the character counter
    labelText: widget.labelText,
    labelStyle: TextStyle(color: effectiveLabelColor,fontSize: 12.0,),
    prefixIcon: Icon(widget.icon, color: effectiveIconColor),
    
    suffixIcon: widget.fieldType == AuthFieldType.password
        ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : (widget.fieldType == AuthFieldType.otp && widget.showButton && _canResend)
                  ? TextButton(
                 onPressed: () { 
  widget.onButtonPressed?.call();
  Future.delayed(Duration(seconds:3), () {
    _canResend = false;
  });
  _startResendTimer();
},

                      child: const Text('Resend',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    )
                  : null,
    filled: true,
    fillColor: effectiveFillColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: effectiveBorderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: effectiveEnabledBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: effectiveFocusedBorderColor),
    ),
    errorText: _errorText,
    errorStyle: const TextStyle(color: Colors.redAccent),
  ),
  onTap: () {
    if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  },
),

    );
  }
}
