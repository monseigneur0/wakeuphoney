import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'just_audio_examle.dart';

class ListAudio extends StatefulWidget {
  const ListAudio({Key? key}) : super(key: key);

  @override
  ListAudioState createState() => ListAudioState();
}

class ListAudioState extends State<ListAudio> with WidgetsBindingObserver {
  final _player = AudioPlayer();
  late List<File> _audioFiles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    // Fetch the app document directory
    final appDocDir = await getApplicationDocumentsDirectory();
    _audioFiles = Directory(appDocDir.path).listSync().cast<File>().toList();

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }
  // Future<void> _init() async {
  //   // Fetch the app document directory
  //   final appDocDir = await getTemporaryDirectory();
  //   _audioFiles = Directory(appDocDir.path)
  //       .listSync()
  //       .map((item) => item)
  //       .where((item) => item.path.endsWith('m4a'))
  //       .cast<File>()
  //       .toList();

  //   final session = await AudioSession.instance;
  //   await session.configure(const AudioSessionConfiguration.speech());
  //   _player.playbackEventStream.listen((event) {},
  //       onError: (Object e, StackTrace stackTrace) {
  //     print('A stream error occurred: $e');
  //   });
  // }

  //...

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  //...

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _audioFiles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_audioFiles[index].path),
                      onTap: () async {
                        await _player.setAudioSource(
                            AudioSource.uri(Uri.file(_audioFiles[index].path)));
                        _player.play();
                      },
                    );
                  },
                ),
              ),
              ControlButtons(_player),
            ],
          ),
        ),
      ),
    );
  }
}

//...
