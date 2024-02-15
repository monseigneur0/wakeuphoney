import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

//works fantastic
class MyApptest extends StatefulWidget {
  static const routeName = 'voice_test_screen';
  static const routeURL = '/voice_test_screen';
  const MyApptest({super.key});

  @override
  State<MyApptest> createState() => _MyAppState();
}

class _MyAppState extends State<MyApptest> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _recorder = AudioRecorder();
  final double _volume = 1.0; // 기본 볼륨 값

  bool _isRecording = false;
  List<String> _recordings = []; // 녹음된 파일의 리스트

  final FirebaseStorage _storage =
      FirebaseStorage.instance; // Firebase Storage 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _loadRecordings();
  }

  void _loadRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final recordings = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith('m4a'))
        .toList();
    setState(() {
      _recordings = recordings;
    });
  }

  Future<void> _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    const uuid = Uuid();
    final filePath = '${tempDir.path}/${uuid.v4()}.m4a';

    await _recorder.start(const RecordConfig(), path: filePath); // 녹음 시작
    setState(() {
      _recordings.add(filePath); // 새로운 녹음을 리스트에 추가
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop(); // 녹음 중지
    if (path != null) {
      _uploadFileToFirebase(path); // Firebase Storage에 파일 업로드
    }
    setState(() {
      _isRecording = false;
      // 녹음 중지 후에는 리스트를 업데이트하지 않습니다.
    });
  }

  Future<void> _uploadFileToFirebase(String filePath) async {
    final file = File(filePath);
    try {
      final ref =
          _storage.ref().child('uploads/audio/${file.uri.pathSegments.last}');
      await ref.putFile(file); // Firebase Storage에 파일 업로드
    } catch (e) {
      print('Error uploading to Firebase Storage: $e');
    }
  }

  Future<void> _cancelRecording() async {
    await _recorder.stop(); // 녹음 중지
    if (_recordings.isNotEmpty) {
      final file = File(_recordings.last);
      if (await file.exists()) {
        await file.delete(); // 파일 삭제
        setState(() {
          _recordings.removeLast(); // 리스트에서 마지막 녹음 제거
        });
      }
    }
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playRecording(String path) async {
    await _audioPlayer.setFilePath(path); // 녹음 파일 설정
    await _audioPlayer.play(); // 재생 시작
  }

  Future<void> _stopPlayback() async {
    await _audioPlayer.stop(); // 재생 중지
  }

  Future<void> _deleteRecording(String path, int index) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete(); // 파일 삭제
      setState(() {
        _recordings.removeAt(index); // 리스트에서 해당 녹음 제거
      });
    }
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
              Expanded(
                child: Container(
                  child: ListView.builder(
                    itemCount: _recordings.length,
                    itemBuilder: (context, index) {
                      final recording = _recordings[index];
                      return ListTile(
                        title: Text('Recording ${index + 1}'),
                        subtitle: Text(
                          recording,
                          style: const TextStyle(fontSize: 10),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () => _playRecording(recording),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteRecording(recording, index),
                            ),
                            // Slider(
                            //   value: _volume,
                            //   min: 0.0,
                            //   max: 1.0,
                            //   divisions: 10,
                            //   onChanged: (newVolume) {
                            //     setState(() {
                            //       _volume = newVolume;
                            //     });
                            //     _audioPlayer.setVolume(_volume);
                            //   },
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
