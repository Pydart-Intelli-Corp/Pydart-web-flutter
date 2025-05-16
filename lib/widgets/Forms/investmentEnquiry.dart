import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:pydart/widgets/buttons/loading_button.dart';

class InvestorInquiryDialog extends StatefulWidget {
  const InvestorInquiryDialog({super.key});

  @override
  InvestorInquiryDialogState createState() => InvestorInquiryDialogState();
}

class InvestorInquiryDialogState extends State<InvestorInquiryDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _closeDialog(BuildContext context) async {
    await _controller.reverse();
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color.fromARGB(71, 32, 95, 122),
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Invest in Freestyle",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Freestyle is a next-gen salon and beauty booking platform combined with an e-commerce marketplace for beauty products. Be a part of this growing industry!",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: nameController,
                          label: 'Full Name',
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your name' : null,
                        ),
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value!.contains('@')
                              ? null
                              : 'Enter a valid email',
                        ),
                        _buildTextField(
                          controller: mobileController,
                          label: 'Mobile',
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.length == 10
                              ? null
                              : 'Enter a valid mobile number',
                        ),
                        _buildTextField(
                          controller: messageController,
                          label: 'Message',
                          maxLines: 4,
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a message' : null,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: LoadingButton(
                            onPressed: () async {
                              await Future.delayed(Duration(seconds: 2));
                              if (_formKey.currentState!.validate()) {
                                _closeDialog(context);
                              }
                            },
                            text: "Submit",
                            buttonColor: const Color.fromARGB(181, 56, 134, 49),
                            hoverColor: const Color.fromARGB(255, 32, 95, 122),
                            onClickColor:
                                const Color.fromARGB(255, 27, 69, 111),
                            textColor: Colors.white,
                            textSize: 19,
                            textWeight: FontWeight.w600,
                            buttonWidth: 180,
                            buttonHeight: 45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    _closeDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 32, 95, 122)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 56, 134, 49)),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
      ),
    );
  }
}
