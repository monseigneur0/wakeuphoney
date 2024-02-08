import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/auth/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginImageScreen extends StatefulWidget {
  static const routeName = "loginimagescreen";
  static const routeURL = "/loginimagescreen";
  const LoginImageScreen({super.key});

  @override
  State<LoginImageScreen> createState() => _LoginImageScreenState();
}

class _LoginImageScreenState extends State<LoginImageScreen> {
  int _current = 0;

  final CarouselController _controller = CarouselController();

  List widgetList = [
    Image.asset('assets/images/sleepingbear.jpeg'),
    Image.asset('assets/images/awakebear.jpeg'),
    Image.asset('assets/images/rabbitwake.jpeg'),
    Image.asset('assets/images/rabbitalarm.jpeg'),
    Image.asset('assets/images/rabbitspeak.jpeg'),
    const LoginHome(),
  ];

  late List textList;

  Widget sliderWidget() {
    return CarouselSlider(
        carouselController: _controller,
        items: widgetList
            .map(
              (imageWidget) => Builder(
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Column(
                      children: [
                        Text(textList[widgetList.indexOf(imageWidget)]),
                        Center(
                          child: Container(
                            color: Colors.black,
                            height: MediaQuery.of(context).size.height * 0.74,
                            width: MediaQuery.of(context).size.width,
                            child: imageWidget,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1.0,
          // autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 500),
          enlargeCenterPage: true,
          // aspectRatio: 10.0,
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
            child: Transform.translate(
              offset: const Offset(0, -110),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    textList = [
      AppLocalizations.of(context)!.wakeupyou,
      AppLocalizations.of(context)!.wakeupnotapproved,
      AppLocalizations.of(context)!.wakeupmenotyet,
      AppLocalizations.of(context)!.wakeupmenotapproved,
      AppLocalizations.of(context)!.wakeupapproved,
      AppLocalizations.of(context)!.login,
    ];
    return Scaffold(
      body: SizedBox(
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
