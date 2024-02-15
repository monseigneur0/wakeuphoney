import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

class MyApp extends StatefulWidget {
  static const routeName = 'voice_text_screen';
  static const routeURL = '/voice_text_screen';
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    const uuid = Uuid();
    final filePath = '${tempDir.path}/${uuid.v4()}.m4a';

    await _recorder.start(const RecordConfig(), path: filePath); // 녹음 시작
    setState(() {
      _audioPath = filePath;
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop(); // 녹음 중지
    setState(() {
      _audioPath = path;
      _isRecording = false;
    });
  }

  Future<void> _cancelRecording() async {
    await _recorder.stop(); // 녹음 중지
    if (_audioPath != null) {
      final file = File(_audioPath!);
      if (await file.exists()) {
        await file.delete(); // 파일 삭제
      }
    }
    setState(() {
      _audioPath = null;
      _isRecording = false;
    });
  }

  Future<void> _playRecording() async {
    if (_audioPath != null) {
      await _audioPlayer.setFilePath(_audioPath!); // 녹음 파일 설정
      await _audioPlayer.play(); // 재생 시작
    }
  }

  Future<void> _stopPlayback() async {
    await _audioPlayer.stop(); // 재생 중지
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Record Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isRecording)
                ElevatedButton(
                  onPressed: _stopRecording,
                  child: const Text('Stop Recording'),
                )
              else
                ElevatedButton(
                  onPressed: _startRecording,
                  child: const Text('Start Recording'),
                ),
              if (_audioPath != null) ...[
                ElevatedButton(
                  onPressed: _playRecording,
                  child: const Text('Play'),
                ),
                ElevatedButton(
                  onPressed: _stopPlayback,
                  child: const Text('Stop'),
                ),
                ElevatedButton(
                  onPressed: _cancelRecording,
                  child: const Text('Cancel Recording'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
