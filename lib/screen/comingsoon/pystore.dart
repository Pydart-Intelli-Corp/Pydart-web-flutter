import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Pystore extends StatefulWidget {
  @override
  _PystoreState createState() => _PystoreState();
}

class _PystoreState extends State<Pystore>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  final DateTime _launchDate = DateTime(2025, 3, 24, 22, 0, 0);
  late Timer _timer;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => setState(() {}));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _timer.cancel();
    _emailController.dispose();
    super.dispose();
  }

  Duration get _remainingTime => _launchDate.difference(DateTime.now());

  String _formatDuration(Duration duration) {
    return duration.isNegative
        ? '00:00:00:00'
        : '${duration.inDays.toString().padLeft(2, '0')} : '
            '${(duration.inHours % 24).toString().padLeft(2, '0')} : '
            '${(duration.inMinutes % 60).toString().padLeft(2, '0')} : '
            '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void _subscribe() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF00C853), size: 64),
                SizedBox(height: 20),
                Text(
                  'Thank You!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'You\'ve been added to our notification list. We\'ll alert you as soon as Pystore opens!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      AnimatedBuilder(
                        animation: _scaleController,
                        builder: (context, child) => Transform.scale(
                          scale: 1 + (_scaleController.value * 0.05),
                          child: child,
                        ),
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                          ).createShader(bounds),
                          child: Text(
                            'PYSTORE',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 42 : 56,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'An initiative by Pydart Intelli Corp',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isSmallScreen ? 16 : 18,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 24, horizontal: 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer,
                                    color: Colors.white70,
                                    size: isSmallScreen ? 28 : 32),
                                SizedBox(width: 12),
                                Text(
                                  'STORE LAUNCH COUNTDOWN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 18 : 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              _formatDuration(_remainingTime),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 32 : 48,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00E676),
                                fontFamily: 'Digital',
                                letterSpacing: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Get notified when our store opens',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: isSmallScreen ? 16 : 18,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.15),
                                    Colors.white.withOpacity(0.05)
                                  ],
                                ),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 18),
                                  suffixIcon: Container(
                                    margin: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF00B4DB),
                                          Color(0xFF0083B0)
                                        ],
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_forward,
                                          color: Colors.white),
                                      onPressed: _subscribe,
                                    ),
                                  ),
                                ),
                                validator: (value) => value!.contains('@')
                                    ? null
                                    : 'Please enter a valid email',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      Wrap(
                        spacing: 20,
                        runSpacing: 15,
                        alignment: WrapAlignment.center,
                        children: [
                          _SocialButton(
                            icon: FontAwesomeIcons.discord,
                            color: Color(0xFF7289DA),
                            onPressed: () {},
                          ),
                          _SocialButton(
                            icon: FontAwesomeIcons.twitter,
                            color: Color(0xFF1DA1F2),
                            onPressed: () {},
                          ),
                          _SocialButton(
                            icon: FontAwesomeIcons.linkedin,
                            color: Color(0xFF0077B5),
                            onPressed: () {},
                          ),
                          _SocialButton(
                            icon: FontAwesomeIcons.github,
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        '© 2025 Pydart Intelli Corp Pvt Ltd. All Rights Reserved',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: IconButton(
        icon: FaIcon(icon, color: color),
        iconSize: 24,
        onPressed: onPressed,
        hoverColor: color.withOpacity(0.1),
        splashColor: color.withOpacity(0.2),
      ),
    );
  }
}
