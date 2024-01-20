import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class WakeUpVoiceScreen extends ConsumerStatefulWidget {
  const WakeUpVoiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WakeUpVoiceScreenState();
}

class _WakeUpVoiceScreenState extends ConsumerState<WakeUpVoiceScreen> {
  Logger logger = Logger();
  final _recorder = AudioRecorder();
  // final Record _recorde = Record();
  bool _isRecording = false;
  String? _audioPath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Record Example'),
        ),
        body: Center(
          child: _isRecording
              ? RecordingWidget(
                  onStop: (path) {
                    setState(() {
                      _audioPath = path;
                      _isRecording = false;
                    });
                  },
                )
              : PlaybackWidget(
                  audioPath: _audioPath ??
                      'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3',
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isRecording ? _stopRecording : _startRecording,
          child: Icon(_isRecording ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    // 앱의 임시 디렉토리 경로를 가져옵니다.
    final tempDir = await getTemporaryDirectory();
    // 파일을 저장할 경로를 설정합니다.
    final path = '${tempDir.path}/myRecording1.m4a';
    // 녹음 시작 전에 권한을 확인하고 요청합니다.
    if (await _recorder.hasPermission()) {
      // 실제 녹음을 시작합니다.
      await _recorder.start(const RecordConfig(), path: path);
      setState(() {
        _isRecording = true;
      });
    } else {
      // 권한이 없다면 사용자에게 요청합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('녹음을 위해 권한이 필요합니다.')),
      );
    }
  }

  Future<void> _stopRecording() async {
    // 녹음을 정지하고 파일 경로를 얻습니다.
    final path = await _recorder.stop();
    setState(() {
      _audioPath = path;
      _isRecording = false;
    });
  }
}

class RecordingWidget extends StatelessWidget {
  final Function(String path) onStop;

  const RecordingWidget({Key? key, required this.onStop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 녹음 중 UI를 여기에 구현합니다.
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('녹음 중...'),
          ElevatedButton(
            onPressed: () async {
              // 녹음을 정지하고 파일 경로를 콜백을 통해 전달합니다.
              onStop('aFullPath/myFile.m4a');
            },
            child: const Text('정지'),
          ),
        ],
      ),
    );
  }
}

class PlaybackWidget extends StatefulWidget {
  final String audioPath;

  const PlaybackWidget({Key? key, required this.audioPath}) : super(key: key);

  @override
  _PlaybackWidgetState createState() => _PlaybackWidgetState();
}

class _PlaybackWidgetState extends State<PlaybackWidget> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer(); // 오디오 플레이어 인스턴스를 생성합니다.
  }

  @override
  void dispose() {
    _player.dispose(); // 위젯이 제거될 때 플레이어를 해제합니다.
    super.dispose();
  }

  Future<void> _playAudio() async {
    try {
      await _player.setFilePath(widget.audioPath); // 파일 경로를 설정합니다.
      await _player.play(); // 오디오 재생을 시작합니다.
    } catch (e) {
      // 오류 처리
      print("오류 발생: $e");
    }
  }

  Future<void> _stopAudio() async {
    _player.stop(); // 오디오 재생을 정지합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _playAudio,
          child: const Text('재생'),
        ),
        ElevatedButton(
          onPressed: _stopAudio,
          child: const Text('중지'),
        ),
      ],
    );
  }
}
