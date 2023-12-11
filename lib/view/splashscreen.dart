import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Color(0xFF9B4FE6)),
          child: Stack(
            children: [
              const Positioned(
                left: 101,
                top: 312,
                child: SizedBox(
                  width: 223,
                  height: 68,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Naviga \nVisual',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontFamily: 'IBM Plex Sans Devanagari',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: '.',
                          style: TextStyle(
                            color: Color(0xFF3936E4),
                            fontSize: 50,
                            fontFamily: 'IBM Plex Sans Devanagari',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 87,
                top: 448,
                child: Container(
                  width: 186,
                  height: 4,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 87,
                top: 448,
                child: Container(
                  width: 87,
                  height: 4,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF6029FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
