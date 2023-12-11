import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:video_player/video_player.dart';

class WorkScreenImage extends StatefulWidget {
  final String videoPath;
  final bool isImage;

  WorkScreenImage({Key? key, required this.videoPath, required this.isImage})
      : super(key: key);

  @override
  _WorkScreenImageState createState() => _WorkScreenImageState();
}

class _WorkScreenImageState extends State<WorkScreenImage> {
  late VideoPlayerController _controller;
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;
  double _currentTime = 0.0; // Add this line
  late ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();

    _initializeMediaController();

    progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Procesando...',
      progressWidget: CircularProgressIndicator(),
      maxProgress: 100.0,
    );
  }

  void _initializeMediaController() {
    if (widget.isImage) {
      // For images, initialize with Image.file instead of VideoPlayerController.file
      _controller = VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      // For videos, use the existing initialization logic
      _controller = VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then((_) {
          setState(() {});
        });
    }

    _controller.addListener(() {
      if (!_controller.value.isPlaying) {
        setState(() {
          // Update current time when not playing
          _currentTime = _controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ... (unchanged code)

    return Scaffold(
      // ... (unchanged code)

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  child: widget.isImage
                      ? Image.file(File(widget.videoPath))
                      : _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            )
                          : const CircularProgressIndicator(),
                ),
                Container(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: widget.isImage
                            ? Container() // No slider for images
                            : Slider(
                                value: _currentTime,
                                min: 0.0,
                                max: _controller.value.duration.inSeconds
                                    .toDouble(),
                                onChanged: (double value) {
                                  setState(() {
                                    _currentTime = value;
                                  });
                                  _controller
                                      .seekTo(Duration(seconds: value.toInt()));
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ... (unchanged code)
          ],
        ),
      ),
    );
  }

  void _applyFilters() async {
    final String outputPath = widget.isImage
        ? widget.videoPath.replaceFirst('.png', '_filtered.png')
        : widget.videoPath.replaceFirst('.mp4', '_filtered.mp4');

    final String command = widget.isImage
        ? '-i ${widget.videoPath} -vf "eq=brightness=$_brightness:contrast=$_contrast:saturation=$_saturation" $outputPath'
        : '-i ${widget.videoPath} -vf "eq=brightness=$_brightness:contrast=$_contrast:saturation=$_saturation" $outputPath';

    int rc = await FlutterFFmpeg().execute(command);
    if (rc == 0) {
      print("Proceso FFmpeg finalizado con éxito");
    } else {
      print("Error en el proceso FFmpeg. Código de retorno: $rc");
    }

    _controller.pause();
    _controller.seekTo(const Duration(seconds: 0));

    _initializeMediaController(); // Re-initialize media controller after processing
  }

  // ... (unchanged code)

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
