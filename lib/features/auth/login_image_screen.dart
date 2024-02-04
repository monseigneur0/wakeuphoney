import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/auth/login_screen.dart';

class LoginImageScreen extends StatefulWidget {
  const LoginImageScreen({super.key});

  @override
  State<LoginImageScreen> createState() => _LoginImageScreenState();
}

class _LoginImageScreenState extends State<LoginImageScreen> {
  int _current = 0;

  final CarouselController _controller = CarouselController();

  List widgetList = [
    Image.asset('assets/images/awakebear.jpeg'),
    Image.asset('assets/images/rabbitalarm.jpeg'),
    Image.asset('assets/images/rabbitspeak.jpeg'),
    Image.asset('assets/images/rabbitwake.jpeg'),
    Image.asset('assets/images/sleepingbear.jpeg'),
    // const LoginHome(),
  ];

  List textList = [
    "Wake up with a smile1",
    "Wake up with a smile2",
    "Wake up with a smile3",
    "Wake up with a smile4",
    "Wake up with a smile5",
    // "Wake up with a smile5",
  ];

  Widget sliderWidget() {
    return CarouselSlider(
        carouselController: _controller,
        items: widgetList
            .map(
              (imageWidget) => Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      100.heightBox,
                      Text(textList[widgetList.indexOf(imageWidget)]),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: imageWidget,
                        ),
                      ),
                    ],
                  );
                },
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: 600,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          },
        ));
  }

  Widget slideIndicator() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widgetList.map((url) {
          int index = widgetList.indexOf(url);
          return GestureDetector(
            onTap: () => _controller.animateToPage(index),
            child: Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index ? Colors.blue : Colors.grey,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: 600,
        child: Stack(
          children: [
            sliderWidget(),
            slideIndicator(),
          ],
        ),
      ),
    );
  }
}
