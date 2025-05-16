import 'package:flutter/material.dart';
import 'package:pydart/api/config.dart';
import 'package:pydart/core/extensions/color_extensions.dart';
import 'package:pydart/widgets/buttons/gradient_button.dart';
import 'package:pydart/widgets/notifications/snackbar.dart';
import 'dart:math';
import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  final _particleCount = 80;
  final List<Particle> _particles = [];
  final Random _random = Random();
  late String selectedValue;
  List<String> _purposeSuggestions = [];
  final FocusNode _purposeFocusNode = FocusNode();
  String _displayedSuggestion = '';
  bool isLoading = false;
  Timer? _particleTimer;
  Size? _screenSize;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.dropdownValue;
    _updatePurposeSuggestions(selectedValue);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Initialize animations first
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Delay context-dependent initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _screenSize = MediaQuery.of(context).size;
        _initParticles();
        _startParticleAnimation();
      }
    });

    _controller.forward();
    _purposeFocusNode.addListener(_onPurposeFocusChange);
    purposeController.addListener(_onPurposeChanged);
  }

  void _initParticles() {
    // Get size from context after widget is mounted
    final size = MediaQuery.of(context).size;
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        radius: _random.nextDouble() * 2 + 1,
        dx: _random.nextDouble() * 1.5 - 0.75,
        dy: _random.nextDouble() * 1.5 - 0.75,
      ));
    }
  } void _startParticleAnimation() {
    _particleTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted || _screenSize == null) return;
      
      setState(() {
        for (var particle in _particles) {
          particle.x += particle.dx;
          particle.y += particle.dy;
          
          if (particle.x < 0 || particle.x > _screenSize!.width) {
            particle.dx *= -1;
          }
          if (particle.y < 0 || particle.y > _screenSize!.height) {
            particle.dy *= -1;
          }
        }
      });
    });
  }

  void _onPurposeFocusChange() {
    if (_purposeFocusNode.hasFocus) {
      _showSuggestionInline();
    } else {
      _clearSuggestion();
    }
  }

  void _onPurposeChanged() => _showSuggestionInline();

  bool isValidEmail(String email) => RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);

  bool isValidMobile(String mobile) => RegExp(r'^[0-9]{10}$').hasMatch(mobile);

  Future<void> _closeDialog(BuildContext context) async {
    _particleTimer?.cancel();
    await _controller.reverse();
    if (mounted) Navigator.pop(context);
  }

  Future<bool> sendEnquiryEmail({
    required String recipientEmail,
    required String recipientName,
    required String mobile,
    required String selectedService,
    required String purpose,
    required BuildContext context,
  }) async {
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
      final response = await http.post(uri, headers: {'Content-Type': 'application/json'});
      if (!mounted) return false;
      
      _closeDialog(context);
      final success = response.statusCode == 200;
      success
          ? CustomSnackbar.success(context, "Inquiry received successfully!")
          : CustomSnackbar.error(context, "Submission failed. Please try again.");
      return success;
    } catch (e) {
      if (mounted) CustomSnackbar.error(context, "Server error. Please try later.");
      return false;
    }
  }

void _updatePurposeSuggestions(String service) {
  const suggestionMap = {
    'Mobile Application': [
      "I want to develop a mobile app for iOS and Android.",
      "I need a mobile app for my business.",
      "I have an app idea I'd like to discuss.",
    ],
    'Web Application': [
      "I want to build a web application with specific functionality.",
      "I need a web-based platform for my services.",
      "I need a website with advanced features.",
    ],
    'GUI application': [
      "I need a desktop application for my work.",
      "I'm looking to create a user-friendly GUI application.",
      "I want a software for internal purpose.",
    ],
    'Computer Software': [
      "I have an idea for software to solve a specific problem.",
      "I'm seeking developers for a computer application.",
      "I need help to write software.",
    ],
    'Website': [
      "I need a professional website for my company.",
      "I want to create a blog or portfolio website.",
      "I am looking for web design and development services.",
    ],
    'Smart Home': [
      "I need to integrate my existing appliances with smart home features.",
      "I have a new home with smart features and want to develop an app for it.",
      "I want to develop a smart automation system for my house.",
    ],
    'Embedded System': [
      "I need an embedded system to control a machine.",
      "I have a hardware project that requires embedded programming.",
      "I need assistance with my embedded system project.",
    ],
    'IOT Projects': [
      "I have an idea for an IoT based product.",
      "I'm looking to develop a smart monitoring system.",
      "I want to integrate IoT for my existing product.",
    ],
    'AI Services': [
      "I need help integrating AI into my products.",
      "I'm interested in developing machine learning solutions.",
      "I need consultation for implementing AI algorithms.",
    ],
  };

  _purposeSuggestions = suggestionMap[service] ?? [];
}

  void _showSuggestionInline() {
    if (!_purposeFocusNode.hasFocus || _purposeSuggestions.isEmpty) return;
    
    final currentText = purposeController.text.toLowerCase();
    final suggestion = _purposeSuggestions.firstWhere(
      (s) => s.toLowerCase().startsWith(currentText),
      orElse: () => '',
    );
    
    setState(() {
      _displayedSuggestion = suggestion.replaceFirst(currentText, '');
    });
  }

  void _clearSuggestion() => setState(() => _displayedSuggestion = '');

  @override
  void dispose() {
    _particleTimer?.cancel();
    _controller.dispose();
    _purposeFocusNode.dispose();
    purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CustomPaint(
            painter: ParticlePainter(particles: _particles),
            size: Size.infinite,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkNavy.withOpacity(0.95),
                    AppColors.darkNavy.withOpacity(0.85),
                  ],
                ),
              ),
              child: SafeArea(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 40),
                            AnimatedFormField(
                              delay: 0,
                              controller: nameController,
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                            AnimatedFormField(
                              delay: 100,
                              controller: emailController,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              validator: (v) => isValidEmail(v!) ? null : 'Invalid email',
                            ),
                            AnimatedFormField(
                              delay: 200,
                              controller: mobileController,
                              label: 'Mobile',
                              icon: Icons.phone_iphone,
                              validator: (v) => isValidMobile(v!) ? null : 'Invalid number',
                            ),
                            AnimatedDropdown(
                              delay: 300,
                              value: selectedValue,
                              onChanged: (v) => setState(() {
                                selectedValue = v!;
                                _updatePurposeSuggestions(v);
                              }),
                            ),
                            const SizedBox(height: 16),
                            _buildPurposeField(),
                            const SizedBox(height: 40),
                            _buildSubmitButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 24,
            right: 24,
            child: IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.close_menu,
                progress: _controller,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => _closeDialog(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() => Column(
    children: [
      ShaderMask(
        shaderCallback: (rect) => LinearGradient(
          colors: [AppColors.accent, AppColors.accentBlue],
        ).createShader(rect),
        child: Text(
          "Start Your Project",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        "Complete the form and our team will contact you within 24 hours",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  );

  Widget _buildPurposeField() => Stack(
    alignment: Alignment.topLeft,
    children: [
      TextFormField(
        controller: purposeController,
        focusNode: _purposeFocusNode,
        maxLines: 3,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Project Purpose',
          alignLabelWithHint: true,
          prefixIcon: Icon(Icons.lightbulb_outline, color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.accent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      if (_displayedSuggestion.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 56, top: 16),
          child: Text(
            _displayedSuggestion,
            style: TextStyle(
              color: Colors.white54,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
        ),
    ],
  );

  Widget _buildSubmitButton() => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) => Transform.translate(
      offset: Offset(0, (1 - _controller.value) * 20),
      child: Opacity(
        opacity: _controller.value,
        child: PrimaryGradientButton(
          onPressed: _submitForm,
          text: "Submit Request",
          isLoading: isLoading,
          gradient: LinearGradient(
            colors: [AppColors.accent, AppColors.accentBlue],
          ),
        ),
      ),
    ),
  );

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      await _controller.animateTo(0.1, duration: Duration(milliseconds: 100));
      await _controller.animateBack(0, duration: Duration(milliseconds: 200));
      return;
    }

    setState(() => isLoading = true);
    await sendEnquiryEmail(
      recipientEmail: emailController.text,
      recipientName: nameController.text,
      mobile: mobileController.text,
      selectedService: selectedValue,
      purpose: purposeController.text,
      context: context,
    );
    setState(() => isLoading = false);
  }
}

class AnimatedFormField extends StatelessWidget {
  final int delay;
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;

  const AnimatedFormField({
    required this.delay,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final animation = ModalRoute.of(context)!.animation!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Interval(delay / 1000, 1.0, curve: Curves.easeOut),
        )),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(delay / 1000, 1.0, curve: Curves.easeIn),
            ),
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(icon, color: Colors.white54),
              floatingLabelStyle: TextStyle(color: AppColors.accent),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white24),
              ),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }
}

class AnimatedDropdown extends StatelessWidget {
  final int delay;
  final String value;
  final ValueChanged<String?> onChanged;

  const AnimatedDropdown({
    required this.delay,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final animation = ModalRoute.of(context)!.animation!;
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Interval(delay / 1000, 1.0, curve: Curves.easeOut),
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: Interval(delay / 1000, 1.0, curve: Curves.easeIn),
          ),
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          dropdownColor: AppColors.darkNavy,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.work_outline, color: Colors.white54),
            labelText: 'Service Type',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white24),
            ),
          ),
          items: [
            'Mobile Application',
            'Web Application',
            'AI Services',
            'IOT Projects',
          ].map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.white))),
          ).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class Particle {
  double x, y, dx, dy, radius;

  Particle({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.radius,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    for (final particle in particles) {
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}