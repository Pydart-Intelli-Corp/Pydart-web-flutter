import 'package:flutter/material.dart';
import 'package:flutter_website/api/config.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/widgets/buttons/gradient_button.dart';
import 'package:flutter_website/widgets/buttons/loading_button.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_website/widgets/notifications/snackbar.dart';

class ResponsiveDialog extends StatefulWidget {
  final String dropdownValue;

  const ResponsiveDialog({super.key, this.dropdownValue = 'App Development'});

  @override
  ResponsiveDialogState createState() => ResponsiveDialogState();
}

class ResponsiveDialogState extends State<ResponsiveDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late String selectedValue;
  List<String> _purposeSuggestions = [];
  final FocusNode _purposeFocusNode = FocusNode();
  String _displayedSuggestion = '';
  bool isLoading = false;

  final Map<String, ValueNotifier<bool>> _fieldValidMap = {
    "Full Name": ValueNotifier<bool>(true),
    "Email Address": ValueNotifier<bool>(true),
    "Mobile Number": ValueNotifier<bool>(true),
  };

  @override
  void initState() {
    super.initState();
    selectedValue = widget.dropdownValue;
    _updatePurposeSuggestions(selectedValue);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
    _purposeFocusNode.addListener(() {
      if (_purposeFocusNode.hasFocus) {
        _showSuggestionInline();
      } else {
        _clearSuggestion();
      }
    });

    purposeController.addListener(_onPurposeChanged);
  }

  @override
  void dispose() {
    _purposeFocusNode.dispose();
    purposeController.removeListener(_onPurposeChanged);
    _controller.dispose();
    super.dispose();
  }

  void _clearSuggestion() {
    setState(() => _displayedSuggestion = '');
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidMobile(String mobile) {
    return RegExp(r'^[0-9]{10}$').hasMatch(mobile);
  }

  void _onPurposeChanged() => _showSuggestionInline();

  void _showSuggestionInline() {
    if (!_purposeFocusNode.hasFocus || _purposeSuggestions.isEmpty) {
      _clearSuggestion();
      return;
    }

    String currentText = purposeController.text;
    String matchedSuggestion = '';

    for (String suggestion in _purposeSuggestions) {
      if (suggestion.toLowerCase().startsWith(currentText.toLowerCase())) {
        matchedSuggestion = suggestion.substring(currentText.length);
        if (matchedSuggestion.isNotEmpty) {
          matchedSuggestion = 'e.g., $matchedSuggestion';
        }
        break;
      }
    }
    setState(() => _displayedSuggestion = matchedSuggestion);
  }

  Future<void> _closeDialog(BuildContext context) async {
    await _controller.reverse();
    if (context.mounted) Navigator.pop(context);
  }

  Future<bool> sendEnquiryEmail({
    required String recipientEmail,
    required String recipientName,
    required String mobile,
    required String selectedService,
    required String purpose,
    required BuildContext context,
  }) async {
    String endPoint = "$apiUrl/emaillead/EnquiryMail";
    try {
      final response = await http.post(
        Uri.parse(endPoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "recipientEmail": recipientEmail,
          "recipientName": recipientName,
          "mobile": mobile,
          "selectedService": selectedService,
          "purpose": purpose,
        }),
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          CustomSnackbar.success(context, "Your inquiry has been received successfully");
        }
        setState(() => isLoading = false);
        _closeDialog(context);
        return true;
      } else {
        if (context.mounted) {
          CustomSnackbar.error(context, "Submission failed. Please try again later.");
        }
        setState(() => isLoading = false);
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackbar.error(context, "Server error occurred. Please try again later.");
      }
      setState(() => isLoading = false);
      return false;
    }
  }

  void _updatePurposeSuggestions(String service) {
    switch (service) {
      case 'Mobile Application':
        _purposeSuggestions = [
          "I want to develop a mobile app for iOS and Android.",
          "I need a mobile app for my business.",
          "I have an app idea I'd like to discuss.",
        ];
        break;
      case 'Web Application':
        _purposeSuggestions = [
          "I want to build a web application with specific functionality.",
          "I need a web-based platform for my services.",
          "I need a website with advanced features.",
        ];
        break;
      case 'GUI application':
        _purposeSuggestions = [
          "I need a desktop application for my work.",
          "I'm looking to create a user-friendly GUI application.",
          "I want a software for internal purpose.",
        ];
        break;
      case 'Computer Software':
        _purposeSuggestions = [
          "I have an idea for software to solve a specific problem.",
          "I'm seeking developers for a computer application.",
          "I need help to write software.",
        ];
        break;
      case 'Website':
        _purposeSuggestions = [
          "I need a professional website for my company.",
          "I want to create a blog or portfolio website.",
          "I am looking for web design and development services.",
        ];
        break;
      case 'Smart Home':
        _purposeSuggestions = [
          "I need to integrate my existing appliances with smart home features.",
          "I have a new home with smart features and want to develop an app for it.",
          "I want to develop a smart automation system for my house.",
        ];
        break;
      case 'Embedded System':
        _purposeSuggestions = [
          "I need an embedded system to control a machine.",
          "I have a hardware project that requires embedded programming.",
          "I need assistance with my embedded system project.",
        ];
        break;
      case 'IOT Projects':
        _purposeSuggestions = [
          "I have an idea for an IoT based product.",
          "I'm looking to develop a smart monitoring system.",
          "I want to integrate IoT for my existing product.",
        ];
        break;
      case 'College Project':
        _purposeSuggestions = [
          "I need help with my college project.",
          "I need assistance in my final year project.",
          "I want guidance in a coding related project",
        ];
        break;
      case 'Auto CAD':
        _purposeSuggestions = [
          "I need assistance in designing in AutoCAD.",
          "I'm seeking experts for my 2D or 3D CAD design",
          "I want to design a building using AutoCAD",
        ];
        break;
      case 'PCB Designing':
        _purposeSuggestions = [
          "I'm looking for assistance in PCB design",
          "I need help with my PCB project",
          "I want to design a complex multilayer PCB",
        ];
        break;
      default:
        _purposeSuggestions = [];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600, minWidth: 300),
            child: Dialog(
              elevation: 16,
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.darkNavy.withOpacity(0.95),
                      AppColors.darkNavy.withOpacity(0.98),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [const Color.fromARGB(255, 255, 0, 0), const Color.fromARGB(255, 255, 0, 0)],
                            ),
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 24),
                        ),
                        onPressed: () => _closeDialog(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Start Your Project",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: AppColors.accent.withOpacity(0.2),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Fill the form below and our team will contact you",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildModernTextField(
                              controller: nameController,
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your name'
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            _buildModernTextField(
                              controller: emailController,
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Email is required';
                                if (!isValidEmail(value)) return 'Enter a valid email';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildModernTextField(
                              controller: mobileController,
                              label: 'Mobile Number',
                              icon: Icons.phone_iphone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Mobile number is required';
                                if (!isValidMobile(value)) return 'Enter a valid 10-digit number';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildModernDropdown(),
                            const SizedBox(height: 20),
                            _buildPurposeField(),
                            const SizedBox(height: 32),
                          Align(
  alignment: Alignment.center,
  child: SizedBox(
    width: 200, // Adjust this value as needed
    height: 50,
    child: PrimaryGradientButton(
      onPressed: () async {
        setState(() => isLoading = true);
        if (_formKey.currentState!.validate()) {
          await sendEnquiryEmail(
            recipientEmail: emailController.text,
            recipientName: nameController.text,
            mobile: mobileController.text,
            selectedService: selectedValue,
            purpose: purposeController.text,
            context: context,
          );
        } else {
          CustomSnackbar.error(
            context,
            "Please fill all required fields correctly!",
          );
          setState(() => isLoading = false);
        }
      },
      text: "Submit Request",
      isLoading: isLoading,
      gradient: const LinearGradient(
        colors: [AppColors.accentBlue, AppColors.accent],
      ),
    ),
  ),
)

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: _fieldValidMap[label]!,
      builder: (context, isValid, child) {
        return TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(icon, color: Colors.white70, size: 22),
            filled: true,
            fillColor: AppColors.darkNavy.withOpacity(0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isValid ? Colors.white24 : Colors.redAccent,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.accentBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          keyboardType: keyboardType,
          validator: validator,
          onChanged: (value) => _fieldValidMap[label]!.value = validator(value) == null,
        );
      },
    );
  }

  Widget _buildModernDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: 'Service Type',
        labelStyle: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Icon(Icons.work_outline, color: Colors.white70, size: 22),
        ),
        filled: true,
        fillColor: AppColors.darkNavy.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accentBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      ),
      dropdownColor: AppColors.darkNavy,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
      items: [
        'Mobile Application',
        'Web Application',
        'GUI application',
        'Computer Software',
        'Website',
        'Smart Home',
        'Embedded System',
        'IOT Projects',
      ].map((String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      )).toList(),
      onChanged: (value) => setState(() {
        selectedValue = value!;
        _updatePurposeSuggestions(selectedValue);
      }),
      style: const TextStyle(color: Colors.white, fontSize: 15),
      isExpanded: true,
      menuMaxHeight: 400,
    );
  }

  Widget _buildPurposeField() {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        TextFormField(
          focusNode: _purposeFocusNode,
          controller: purposeController,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Project Details',
            labelStyle: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            alignLabelWithHint: true,
            prefixIcon: Container(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(Icons.edit_outlined, color: Colors.white70, size: 22),
            ),
            filled: true,
            fillColor: AppColors.darkNavy.withOpacity(0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white24, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.accentBlue, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
        if (_displayedSuggestion.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 56, top: 16),
            child: Text(
              _displayedSuggestion,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}