import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../controller/camara_preview.dart';

class NavigationProgress extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  NavigationProgress({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => const CameraView()),
      );
    });

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF9B50E7), // Set the background color here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Naviga',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'IBM Plex Sans Devanagari',
              fontWeight: FontWeight.w700,
              height: 0,
              decoration: TextDecoration.none,
            ),
          ),
          const Text(
            'Visual',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'IBM Plex Sans Devanagari',
              fontWeight: FontWeight.w700,
              height: 0,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            width: 350, // Adjust the width as needed
            height: 100, // Adjust the height as needed
            child: LottieBuilder.asset(
              'assets/loader.json',
            ),
          ),
        ],
      ),
    );
  }
}
