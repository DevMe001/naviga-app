import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 360,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 360,
                  height: 800,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/360x800"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 360,
                  height: 800,
                  decoration: const BoxDecoration(color: Color(0xB2565555)),
                ),
              ),
              Positioned(
                left: 172,
                top: 708,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                ),
              ),
              Positioned(
                left: 177,
                top: 269,
                child: Container(
                  width: 7,
                  height: 71,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 188,
                top: 284,
                child: Container(
                  width: 7,
                  height: 50,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 166,
                top: 284,
                child: Container(
                  width: 7,
                  height: 50,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 199,
                top: 293,
                child: Container(
                  width: 7,
                  height: 33,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 155,
                top: 293,
                child: Container(
                  width: 7,
                  height: 33,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 210,
                top: 304,
                child: Container(
                  width: 7,
                  height: 17,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 144,
                top: 304,
                child: Container(
                  width: 7,
                  height: 17,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 133,
                top: 309,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              Positioned(
                left: 221,
                top: 309,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: Colors.white),
                ),
              ),
              const Positioned(
                left: 24,
                top: 483,
                child: Text(
                  '55 ml',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'IBM Plex Sans Devanagari',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              const Positioned(
                left: 47,
                top: 517,
                child: Text(
                  'Turn right',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const Positioned(
                left: 283,
                top: 493,
                child: Text(
                  '20 step to go',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const Positioned(
                left: 44,
                top: 562,
                child: Text(
                  'San Carlos City, Pangasinan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 517,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(children: [
                    // No extra comma here
                  ]),
                ),
              ),
              Positioned(
                left: 25,
                top: 562,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(children: [
                    // No extra comma here
                  ]),
                ),
              ),
              Positioned(
                left: 25,
                top: 562,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: const Stack(children: [
                    // No extra comma here
                  ]),
                ),
              ),
              Positioned(
                left: 84,
                top: 640,
                child: Container(
                  width: 16,
                  height: 16,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                ),
              ),
              Positioned(
                left: 264.43,
                top: 508.28,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 0.0)
                    ..rotateZ(-1.59),
                  child: Container(
                    width: 18.94,
                    height: 15.15,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(),
                    child: const Stack(children: [
                      // No extra comma here
                    ]),
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
