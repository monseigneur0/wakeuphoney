import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web_socket_channel/io.dart';

import 'animated_text.dart';
import 'line_chart.dart';

class BitcoinScreen extends StatefulWidget {
  static const routeName = 'bitcoin';
  static const routeUrl = '/bitcoin';
  const BitcoinScreen({super.key});

  @override
  State<BitcoinScreen> createState() => _BitcoinScreenState();
}

class _BitcoinScreenState extends State<BitcoinScreen> {
  final wsUrl = Uri.parse('wss://stream.binance.com:9443/ws/btcusdt@trade');
  late final channel = IOWebSocketChannel.connect(wsUrl);
  late final Stream<dynamic> stream;

  String priceText = 'Loading';
  final List<double> priceList = [];

  final intervalDuration = 1.seconds;
  DateTime lastUpdatedTime = DateTime.now();

  double maxPrice = 0;

  @override
  void initState() {
    super.initState();
    stream = channel.stream;
    stream.listen((event) {
      final obj = json.decode(event);
      final price = double.parse(obj['p']);

      if (DateTime.now().difference(lastUpdatedTime) > intervalDuration) {
        lastUpdatedTime = DateTime.now();
        if (context.mounted) {
          setState(() {
            maxPrice = max(maxPrice, price);
            priceList.add(price);
            priceText = price.toDoubleStringAsFixed();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedNumberText(
              priceText,
              textStyle: const TextStyle(
                  fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white, textBaseline: null, decoration: TextDecoration.none),
              duration: 50.microseconds,
            ),
            LineChartWidget(
              priceList,
              maxPrice: maxPrice,
            ),
          ],
        ),
      ),
    );
  }
}
