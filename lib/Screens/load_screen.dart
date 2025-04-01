import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housing_portal_plus/Screens/home_screen.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _horizontalMovement;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // Initialize animation controller for 5 seconds
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Animation for horizontal movement (from right to left)
    _horizontalMovement = Tween<double>(
      begin: 1.0,
      end: -1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Start the animation and make it repeat
    _controller.repeat();

    // Navigate to home screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) { // Ensures the widget is still active
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF13A5DC), // UCSC Blue
              Color(0xFF003C6C), // UCSC Dark Blue
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Banana Slug
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  // Straight horizontal movement
                  offset: Offset(
                    _horizontalMovement.value * screenWidth,
                    0,
                  ),
                  child: child,
                );
              },
              child: Image.asset(
                'assets/SnailChilling.png',
                width: 150,
                height: 80,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Housing plus',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Go Banana Slugs!',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xFFFDB515), // UCSC Yellow
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}