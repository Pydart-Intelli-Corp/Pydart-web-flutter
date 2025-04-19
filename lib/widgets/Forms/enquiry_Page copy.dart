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

  // Map to track field validation for visual feedback
  final Map<String, ValueNotifier<bool>> _fieldValidMap = {
    "Name": ValueNotifier<bool>(true),
    "Mobile": ValueNotifier<bool>(true),
    "Email": ValueNotifier<bool>(true),
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
    setState(() {
      _displayedSuggestion = '';
    });
  }

  bool isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidMobile(String mobile) {
    final mobileRegex = RegExp(r'^[0-9]{10}$'); // Ensures exactly 10 digits
    return mobileRegex.hasMatch(mobile);
  }

  void _onPurposeChanged() {
    _showSuggestionInline();
  }

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
    setState(() {
      _displayedSuggestion = matchedSuggestion;
    });
  }

  Future<void> _closeDialog(BuildContext context) async {
    await _controller.reverse();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<bool> sendEnquiryEmail({
  required String recipientEmail,
  required String recipientName,
  required String mobile,
  required String selectedService,
  required String purpose,
  required BuildContext context,
}) async {
  // Build the URI with query parameters
  final Uri uri = Uri.parse("$apiUrl/Email/EnquiryMail").replace(
    queryParameters: {
      'recipientEmail': recipientEmail,
      'recipientName': recipientName,
      'mobile': mobile,
      'selectedService': selectedService,
      'purpose': purpose,
    },
  );

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
    );
 _closeDialog(context);
    final success = response.statusCode == 200;
    if (context.mounted) {
      success
          ? CustomSnackbar.success(context, "Your inquiry has been received successfully")
          : CustomSnackbar.error(context, "Submission failed. Please try again later.");
    }
    return success;
  } catch (e) {
    if (context.mounted) {
      CustomSnackbar.error(context, "Server error occurred. Please try again later.");
    }
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
      case 'AI Services':
        _purposeSuggestions = [
          "I need help integrating AI into my products.",
          "I'm interested in developing machine learning solutions.",
          "I need consultation for implementing AI algorithms.",
        ];
        break;
      default:
        _purposeSuggestions = [];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to adjust dialog size based on screen size
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Deeper blur for focus
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600, // Maximum width for larger screens
              minWidth: 300, // Minimum width for smaller screens
            ),
            child: Dialog(
              elevation: 10,
              backgroundColor: AppColors.darkNavy.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header section with title and close button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Kickstart Your Project Now",
                                  style: AppColors.buttonTextStyle.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () {
                                    _closeDialog(context);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: nameController,
                              label: 'Name',
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your name'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: emailController,
                              label: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                } else if (!isValidEmail(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: mobileController,
                              label: 'Mobile',
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mobile number is required';
                                } else if (!isValidMobile(value)) {
                                  return 'Enter a valid 10-digit mobile number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildDropdownField(
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value!;
                                  _updatePurposeSuggestions(selectedValue);
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildPurposeTextField(
                              controller: purposeController,
                              label: 'Purpose',
                              maxLines: 3,
                              focusNode: _purposeFocusNode,
                              suggestion: _displayedSuggestion,
                            ),
                            const SizedBox(height: 20),
                            Center(
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
                                        "Please fill all required fields correctly!");
                                    setState(() => isLoading = false);
                                  }
                                },
                                text: "Submit",
                                isLoading: isLoading,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPurposeTextField({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    int maxLines = 1,
    String suggestion = '',
  }) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppColors.buttonTextStyle,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accentBlue),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maxLines: maxLines,
        ),
        if (suggestion.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Text(
              suggestion,
              style: const TextStyle(
                  color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: _fieldValidMap[label]!,
      builder: (context, isValid, child) {
        return TextFormField(
          focusNode: focusNode,
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
                color: isValid ? Colors.white : Colors.red,
                fontWeight: FontWeight.w500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isValid ? AppColors.accentBlue : Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isValid ? AppColors.accent : Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          keyboardType: keyboardType,
          validator: (value) {
            bool isValidField = validator(value) == null;
            _fieldValidMap[label]!.value = isValidField;
            return isValidField ? null : validator(value);
          },
          onChanged: (value) {
            _fieldValidMap[label]!.value = validator(value) == null;
          },
          onTap: () {
            if (!_fieldValidMap[label]!.value) {
              _formKey.currentState!.validate();
            }
          },
          maxLines: maxLines,
        );
      },
    );
  }

  Widget _buildDropdownField({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Service',
        labelStyle: AppColors.buttonTextStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentBlue),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accent),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dropdownColor: AppColors.darkNavy,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      items: [
        'Mobile Application',
        'Web Application',
        'GUI application',
        'Computer Software',
        'Website',
        'Smart Home',
        'Embedded System',
        'IOT Projects',
        'AI Services',  // New option added here
      ]
          .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      isExpanded: true,
      menuMaxHeight: 500,
    );
  }
}
