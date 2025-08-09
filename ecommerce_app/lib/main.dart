import 'package:ecommerce_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}
// import 'dart:math';
// import 'package:flutter/material.dart';

// void main() =>
//     runApp(MaterialApp(home: Scaffold(body: RadialLinesAnimation())));

// class RadialLinesAnimation extends StatefulWidget {
//   @override
//   _RadialLinesAnimationState createState() => _RadialLinesAnimationState();
// }

// class _RadialLinesAnimationState extends State<RadialLinesAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   final int totalLines = 100;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 4),
//     )..repeat();

//     _animation = Tween<double>(
//       begin: 0,
//       end: totalLines.toDouble(),
//     ).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           AnimatedBuilder(
//             animation: _animation,
//             builder: (context, child) {
//               return CustomPaint(
//                 size: Size(300, 300),
//                 painter: RadialLinesPainter(
//                   linesToDraw: _animation.value.toInt(),
//                   totalLines: totalLines,
//                 ),
//               );
//             },
//           ),
//           const Text(
//             'دائرة',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class RadialLinesPainter extends CustomPainter {
//   final int linesToDraw;
//   final int totalLines;

//   RadialLinesPainter({required this.linesToDraw, required this.totalLines});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//         Paint()
//           ..color = Colors.orange
//           ..strokeWidth = 2;

//     final center = Offset(size.width / 2, size.height / 2);
//     final baseRadius = min(size.width, size.height) / 2 - 20;

//     for (int i = 0; i < linesToDraw; i++) {
//       final angle = (2 * pi * i) / totalLines;

//       // كل خط: مرة طويل للخارج، مرة قصير للداخل
//       final isEven = i % 2 == 0;
//       final startRadius = isEven ? baseRadius * 0.8 : baseRadius;
//       final endRadius = isEven ? baseRadius : baseRadius * 1.2;

//       final start = Offset(
//         center.dx + startRadius * cos(angle),
//         center.dy + startRadius * sin(angle),
//       );

//       final end = Offset(
//         center.dx + endRadius * cos(angle),
//         center.dy + endRadius * sin(angle),
//       );

//       canvas.drawLine(start, end, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant RadialLinesPainter oldDelegate) {
//     return oldDelegate.linesToDraw != linesToDraw;
//   }
// }
