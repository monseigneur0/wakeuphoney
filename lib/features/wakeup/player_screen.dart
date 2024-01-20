import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Voice Player',
      home: FileManagerPage(),
    );
  }
}

class FileManagerPage extends StatefulWidget {
  const FileManagerPage({super.key});

  @override
  _FileManagerPageState createState() => _FileManagerPageState();
}

class _FileManagerPageState extends State<FileManagerPage> {
  List<FileSystemEntity> files = [];
  List<FileSystemEntity> tempfiles = [];

  @override
  void initState() {
    super.initState();
    _listFiles();
    _listTempFiles();
  }

  Future<void> _listFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    setState(() {
      files = dir.listSync();
    });
  }

  Future<void> _listTempFiles() async {
    final dir = await getTemporaryDirectory();
    setState(() {
      tempfiles = dir
          .listSync()
          .map((item) => item)
          .where((item) => item.path.endsWith('m4a'))
          .toList();
    });
  }

  Future<void> _deleteFile(FileSystemEntity file) async {
    final fileToDelete = File(file.path);
    await fileToDelete.delete();
    _listFiles(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Manager'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            height: 200,
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                final fileName = file.path.split('/').last;

                return ListTile(
                  title: Text(fileName),
                  subtitle: Text(
                    file.path,
                    style: const TextStyle(fontSize: 10),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteFile(file),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.red,
            height: 400,
            child: ListView.builder(
              itemCount: tempfiles.length,
              itemBuilder: (context, index) {
                final file = tempfiles[index];
                final fileName = file.path.split('/').last;

                return ListTile(
                  title: Text(fileName),
                  subtitle: Text(
                    file.path,
                    style: const TextStyle(fontSize: 10),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteFile(file),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
