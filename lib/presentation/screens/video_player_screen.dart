import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatelessWidget {
  final int videoIndex;

  VideoPlayerScreen({required this.videoIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video $videoIndex'),
      ),
      body: Center(
        child: Text('Aquí se mostrará el video $videoIndex'),
      ),
    );
  }
}
