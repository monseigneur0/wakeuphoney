import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WakeWriteScreen extends StatefulWidget {
  static const routeName = 'wakewrite';
  static const routeUrl = '/wakewrite';
  const WakeWriteScreen({super.key});

  @override
  State<WakeWriteScreen> createState() => _WakeWriteScreenState();
}

class _WakeWriteScreenState extends State<WakeWriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('편지쓰기'),
      ),
      body: Column(
        children: [
          // chooseTime,
          ElevatedButton(
            onPressed: () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selectedTime != null) {
                // Do something with the selected time
              }
            },
            child: const Text('Select Time'),
          ),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDateTime) {
                // Do something with the selected time
              },
            ),
          )
          //volumebar
          //select box
          //textbox,
          //recorder
          //camera
          //album
        ],
      ),
    );
  }
}
