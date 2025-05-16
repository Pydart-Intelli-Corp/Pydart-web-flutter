import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pydart/api/config.dart';
import 'package:pydart/core/extensions/color_extensions.dart';
import 'package:pydart/components/spacing.dart';
import 'package:pydart/components/typography.dart';
import 'package:pydart/screen/Career/blocks/career_constants.dart';
import 'package:pydart/widgets/buttons/gradient_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pydart/widgets/notifications/snackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';


// For kIsWeb

import 'dart:typed_data'; // For handling bytes on web

// Declare these variables at your widget state level
File? _resumeFile;               // For mobile/desktop
Uint8List? _resumeBytes;         // For web
String? _resumeFileName;  
class CareerBlock extends StatefulWidget {
  const CareerBlock({super.key});

  @override
  State<CareerBlock> createState() => _CareerBlockState();
}

class _CareerBlockState extends State<CareerBlock> {
  final GlobalKey _jobOpeningsKey = GlobalKey();
  final GlobalKey _applicationFormKey = GlobalKey();

  int _currentPage = 0;
  late PageController _pageController;
  Timer? _sliderTimer;
  String _selectedJob = '';
    File? _resumeFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _sliderTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        // _currentPage = (_currentPage + 1) % sliderImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Container(
      width: double.infinity,
      margin: blockMargin.copyWith(top: 60, bottom: 60),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]
      ),
      child: Column(
        children: [
          _buildCareerHeader(isMobile),
          const SizedBox(height: 40),
          _buildJobOpeningsSection(isMobile, isTablet),
          const SizedBox(height: 40),
           _buildPerksSection(isMobile),
        
          const SizedBox(height: 60),
          _buildApplicationForm(isMobile),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCareerHeader(bool isMobile) {
    return Container(
      height: 400,
    
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Build Your Future With Us",
                style: TextStyle(
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  shadows: [Shadow(color: Colors.black54, blurRadius: 10)]
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Join our team of innovators and shape the future of technology",
                style: headlineTextStyleMobile.copyWith(
                  color: Colors.white70,
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              PrimaryGradientButton(
                onPressed: () => _scrollToJobOpenings(),
                text: "View Open Positions →",
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
Widget _buildApplicationForm(bool isMobile) {
    return Container(
      key: _applicationFormKey,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(217, 23, 23, 23),
            const Color.fromARGB(226, 0, 0, 0)
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apply Now",
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: "Montserrat"
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: _buildTransparentTextField(
                  controller: _nameController,
                  label: "Full Name",
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildTransparentTextField(
                  controller: _emailController,
                  label: "Email Address",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTransparentTextField(
                  controller: _phoneController,
                  label: "Phone Number",
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 20),
           Expanded(
  child: _buildJobDropdown(isMobile),
),

            ],
          ),
          const SizedBox(height: 20),
          _buildResumeUploadSection(),
          const SizedBox(height: 30),
          Center(
            child: PrimaryGradientButton(
              onPressed: (){
                
                 setState(() => isLoading = true);
                _submitApplication();},
              text: "Submit Application",
              isLoading: isLoading,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          )
        ],
      ),
    );
  }
Widget _buildResumeUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload Resume (PDF/DOC)",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'doc', 'docx'],
              allowMultiple: false,
            );
            if (result != null && result.files.isNotEmpty) {
              if (kIsWeb) {
                setState(() {
                  _resumeBytes = result.files.single.bytes;
                  _resumeFileName = result.files.single.name;
                });
              } else {
                setState(() {
                  _resumeFile = File(result.files.single.path!);
                });
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file, color: Colors.white70),
                const SizedBox(width: 10),
                Text(
                  kIsWeb
                      ? _resumeFileName ?? "Choose file..."
                      : _resumeFile?.path.split('/').last ?? "Choose file...",
                  style: TextStyle(
                    color: (kIsWeb ? _resumeFileName != null : _resumeFile != null)
                        ? Colors.white
                        : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (kIsWeb ? _resumeFileName != null : _resumeFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              kIsWeb
                  ? "File selected: $_resumeFileName"
                  : "File selected: ${_resumeFile!.path.split('/').last}",
              style: TextStyle(color: Colors.green[200], fontSize: 12),
            ),
          ),
      ],
    );
  }

void _submitApplication() async {
  print("Submitting application...");
  
  // Trim text values.
  final name = _nameController.text.trim();
  final email = _emailController.text.trim();
  final phone = _phoneController.text.trim();
  final job = _selectedJob.trim();

  // Check for empty fields.
  if ([name, email, phone, job].any((field) => field.isEmpty) ||
      (kIsWeb ? _resumeBytes == null : _resumeFile == null)) {
    setState(() => isLoading = false);
    CustomSnackbar.error(context, "Please fill all required fields");
    return;
  }

  // Validate email format.
  if (!isValidEmail(email)) {
    setState(() => isLoading = false);
    CustomSnackbar.error(context, "Please enter a valid email address");
    return;
  }

  // Validate phone number format.
  if (!isValidPhone(phone)) {
    setState(() => isLoading = false);
    CustomSnackbar.error(context, "Please enter a valid phone number");
    return;
  }

  try {
    final queryParams = {
      'recipientName': name,
      'recipientEmail': email,
      'mobile': phone,
      'selectedService': job,
      'purpose': "Application Submission",
    };

    final uri = Uri.parse("$apiUrl/Email/CareerMail")
        .replace(queryParameters: queryParams);

    var request = http.MultipartRequest("POST", uri);

    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'pdfFile',
          _resumeBytes!,
          filename: _resumeFileName,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    } else {
      final fileBytes = await _resumeFile!.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'pdfFile',
          fileBytes,
          filename: _resumeFile!.path.split('/').last,
        ),
      );
    }

    var response = await http.Response.fromStream(await request.send());
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      _clearForm();
      setState(() => isLoading = false);
      CustomSnackbar.success(context, "Application submitted successfully!");
    } else {
      setState(() => isLoading = false);
      CustomSnackbar.error(context, "Failed to submit: ${response.body} ${response.statusCode}");
    }
  } catch (e) {
    setState(() => isLoading = false);
    CustomSnackbar.error(context, "Error occurred: $e");
  }
}

bool isValidEmail(String email) {
  // A basic regex pattern for validating email addresses.
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

bool isValidPhone(String phone) {
  // A simple regex pattern for validating phone numbers.
  // This pattern allows an optional '+' at the beginning and expects 10 to 15 digits.
  final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
  return phoneRegex.hasMatch(phone);
}

  Widget _buildJobDropdown(bool isMobile) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonFormField<String>(
      isExpanded: true,
      value: _selectedJob.isNotEmpty ? _selectedJob : null,
      hint: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          "Select Position",
          style: TextStyle(color: Colors.white70),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: Colors.white70, size: 28),
      iconSize: 32,
      dropdownColor: const Color.fromARGB(255, 30, 30, 30),
      style: TextStyle(
        color: Colors.white,
        fontSize: isMobile ? 16 : 18,
      ),
      items: jobOpenings.map((job) {
        return DropdownMenuItem<String>(
          value: job['title'],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              job['title'],
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedJob = newValue ?? '';
        });
      },
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 12),
          child: Icon(Icons.work_outline, 
              color: Colors.white70, 
              size: 28),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
      menuMaxHeight: MediaQuery.of(context).size.height * 0.4, // Dynamic height based on screen
      elevation: 16, // Increase elevation to bring menu to front
      // Add these properties to handle menu positioning
      itemHeight: 60, // Fixed height for each dropdown item
      selectedItemBuilder: (BuildContext context) {
        return jobOpenings.map((job) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                _selectedJob,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList();
      },
    ),
  );
}
  Widget _buildTransparentTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
  
void _clearForm() {
  setState(() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _selectedJob = '';
    kIsWeb ? _resumeBytes = _resumeFileName = null : _resumeFile = null;
  });
  CustomSnackbar.success(context, "Application submitted successfully.");
}

  
  void _scrollToApplicationForm() {
    Scrollable.ensureVisible(
      _applicationFormKey.currentContext!,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

void _scrollToJobOpenings() {
  Scrollable.ensureVisible(
    _jobOpeningsKey.currentContext!,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );
}
  Widget _buildJobOpeningsSection(bool isMobile, bool isTablet) {
    return Padding(

        key: _jobOpeningsKey,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Current Open Positions",
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w800,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontFamily: "Montserrat"),
          ),
          const SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 1.2 : 1.1,
            ),
            itemCount: jobOpenings.length,
            itemBuilder: (context, index) => _buildJobCard(jobOpenings[index], isMobile),
          ),
        ],
      ),
    );
  }

Widget _buildJobCard(Map<String, dynamic> job, bool isMobile) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(82, 33, 33, 33),
              const Color.fromARGB(82, 0, 0, 0)
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 18 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      job['title'],
                      style: GoogleFonts.manrope(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _getJobTypeColor(job['type']).withOpacity(0.15),
                      border: Border.all(
                        color: _getJobTypeColor(job['type']).withOpacity(0.4),
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    child: Text(
                      job['type'],
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getJobTypeColor(job['type']),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 18, color: Colors.white.withOpacity(0.7)),
                  const SizedBox(width: 8),
                  Text(
                    job['location'],
                    style: GoogleFonts.manrope(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              Text(
                job['description'],
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.6,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Requirements",
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: job['requirements'].split('\n').length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade400,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  job['requirements'].split('\n')[i],
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
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
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.1),
                margin: const EdgeInsets.symmetric(vertical: 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Package: ",
                          style: GoogleFonts.manrope(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: job['salary'],
                          style: GoogleFonts.manrope(
                            color: AppColors.oceanBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.arrow_circle_right_outlined, 
                      size: 18, 
                      color: Colors.black.withOpacity(0.8)),
                    label: Text(
                      "Apply Now",
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                     onPressed: () {
                    setState(() {
                      _selectedJob = job['title'];
                    });
                    _scrollToApplicationForm();
                  }
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
Widget _buildPerksSection(bool isMobile) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 80),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromARGB(0, 0, 0, 0),
          const Color.fromARGB(0, 0, 0, 0),
        ],
      ),
    ),
    child: Column(
      children: [
        Text(
                    "Why We Stand Out ? ",
                    style: TextStyle(
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  shadows: [Shadow(color: Colors.black54, blurRadius: 10)]
                ),
                textAlign: TextAlign.center,),
        const SizedBox(height: 20),
        Text(
                "Leading with innovation, driven by excellence, and shaping tomorrow’s technology today",
                style: headlineTextStyleMobile.copyWith(
                  color: Colors.white70,
                  fontSize: isMobile ? 18 : 24,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
                const SizedBox(height: 50),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 80),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            childAspectRatio: 0.9,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => _buildModernPerkItem(index),
        ),
      ],
    ),
  );
}

Widget _buildModernPerkItem(int index) {
  final List<Map<String, dynamic>> perks = [
    {
      'icon': Icons.favorite_border_rounded,
      'title': "Health First",
      'desc': "Premium medical coverage & wellness programs",
      'gradient': [Color(0xFF6366F1), Color(0xFF8B5CF6)],
      'bgImage': "assets/images/career/health.webp",
    },
    {
      'icon': Icons.schedule_rounded,
      'title': "Flex Work",
      'desc': "Hybrid models & flexible hours",
      'gradient': [Color(0xFF3B82F6), Color(0xFF60A5FA)],
      'bgImage': "assets/images/career/flex.webp",
    },
    {
      'icon': Icons.rocket_launch_rounded,
      'title': "Growth Path",
      'desc': "Clear promotions & mentorship",
      'gradient': [Color(0xFF10B981), Color(0xFF34D399)],
      'bgImage': "assets/images/career/grow.webp",
    },
    {
      'icon': Icons.attach_money_rounded,
      'title': "Competitive Pay",
      'desc': "Top 10% industry compensation",
      'gradient': [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      'bgImage': "assets/images/career/pay.webp",
    },
    {
      'icon': Icons.language_rounded,
      'title': "Remote Options",
      'desc': "Work from anywhere globally",
      'gradient': [Color(0xFF8B5CF6), Color(0xFFEC4899)],
      'bgImage': "assets/images/career/home.webp",
    },
    {
      'icon': Icons.celebration_rounded,
      'title': "Team Culture",
      'desc': "Regular retreats & events",
      'gradient': [Color(0xFFEF4444), Color(0xFFF87171)],
      'bgImage': "assets/images/career/team.webp",
    },
  ];
  return MouseRegion(
    onEnter: (_) => setState(() {}),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuint,
      // Use Stack to layer the background image, overlay, and content
      child: Stack(
        children: [
          // Background image container
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(perks[index]['bgImage']),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 40,
                  spreadRadius: 0,
                  offset: Offset(0, 12),
                )
              ],
            ),
          ),
          // Black overlay container
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(178, 0, 0, 0),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          // Content container
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: perks[index]['gradient'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (perks[index]['gradient'] as List<Color>)
                            .first
                            .withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      )
                    ],
                  ),
                  child: Icon(
                    perks[index]['icon'],
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  perks[index]['title'],
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // Changed to white for better contrast
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  perks[index]['desc'],
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.white70, // Adjusted color for readability
                    height: 1.6,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: (perks[index]['gradient'] as List<Color>).first,
                  size: 20,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Color _getJobTypeColor(String type) {
    switch (type) {
      case 'Full-time':
        return Colors.green[100]!;
      case 'Part-time':
        return Colors.orange[100]!;
      case 'Contract':
        return Colors.blue[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

}


