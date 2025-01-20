import 'package:flutter/material.dart';
//import 'dart:math';
//import 'package:housing_portal_plus/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Housing Portal Plus',
        style: TextStyle(
          fontSize: 16
        ),
        ),
      ),
      body: const Center(
        child: Text('Welcome'),
      )
    );
  }
}


/*
class BananaSlugLoader extends StatefulWidget {
  const BananaSlugLoader({@required Key? key}) : super(key: key);

  @override
  _BananaSlugLoaderState createState() => _BananaSlugLoaderState();
}

class _BananaSlugLoaderState extends State<BananaSlugLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slugAnimation;

  @override
  void initState() {
    super.initState();
    // Create an animation controller that runs for 2 seconds and repeats
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Create a curved animation for smooth slug movement
    _slugAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Navigate to MyHomePage after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8DC), // Banana cream background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Banana Slug
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    sin(_slugAnimation.value * 2 * pi) * 20, 
                    cos(_slugAnimation.value * 2 * pi) * 10
                  ),
                  child: Transform.scale(
                    scale: 1 + sin(_slugAnimation.value * pi) * 0.2,
                    child: CustomPaint(
                      painter: BananaSlugPainter(),
                      size: const Size(200, 100),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Loading...',
              style: TextStyle(
                color: Color(0xFF8B4513), // Dark brown text
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              backgroundColor: Colors.brown[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellowAccent[700]!),
            ),
          ],
        ),
      ),
    );
  }
}

class BananaSlugPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD2B48C) // Tan color for slug body
      ..style = PaintingStyle.fill;

    // Slug body
    final bodyPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.3, 
        size.width * 0.8, size.height * 0.6
      )
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.9, 
        size.width * 0.2, size.height * 0.6
      );
    canvas.drawPath(bodyPath, paint);

    // Eye stalks
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.4), 
      5, 
      eyePaint
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.4), 
      5, 
      eyePaint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
*/