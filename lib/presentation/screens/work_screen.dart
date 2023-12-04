import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class WorkScreen extends StatefulWidget {
  final String videoPath;

  const WorkScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late VideoPlayerController _controller;
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;
  double _currentTime = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });

    // Set up a listener to update video adjustments and current time in real-time
    _controller.addListener(() {
      if (!_controller.value.isPlaying) {
        setState(() {
          _currentTime = _controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeigt = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.tips_and_updates),
                  onPressed: () {
                    _applyFilters();
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.tune),
                  onPressed: () {
                    _showTuneDialog(context);
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.file_upload),
                  onPressed: () {
                    // shareCourse();
                  },
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Center(
                  child: _controller.value.isInitialized
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
                        child: Slider(
                          value: _currentTime,
                          min: 0.0,
                          max: _controller.value.duration.inSeconds.toDouble(),
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
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        _controller.play();
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () {
                      setState(() {
                        _controller.pause();
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: () {
                      setState(() {
                        _controller.pause();
                        _controller.seekTo(const Duration(seconds: 0));
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTuneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Adjust Video'),
              content: Column(
                children: [
                  _buildSlider(
                    'Brightness',
                    _brightness,
                    (double value) {
                      setState(() {
                        _brightness = value;
                      });
                      _updateVideoAdjustments();
                    },
                  ),
                  _buildSlider(
                    'Contrast',
                    _contrast,
                    (double value) {
                      setState(() {
                        _contrast = value;
                      });
                      _updateVideoAdjustments();
                    },
                  ),
                  _buildSlider(
                    'Saturation',
                    _saturation,
                    (double value) {
                      setState(() {
                        _saturation = value;
                      });
                      _updateVideoAdjustments();
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSlider(
      String label, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Text(label),
        Slider(
          value: value,
          min: 0.5,
          max: 1.5,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _applyFilters() async {
    final String outputPath =
        widget.videoPath.replaceFirst('.mp4', '_filtered.mp4');
    final String command =
        '-i ${widget.videoPath} -vf "eq=brightness=$_brightness:contrast=$_contrast:saturation=$_saturation" $outputPath';
    int rc = await FlutterFFmpeg().execute(command);
    print("FFmpeg process exited with rc $rc");

    _controller = VideoPlayerController.network(outputPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _updateVideoAdjustments() {
    if (_controller.value.isInitialized && !_controller.value.isPlaying) {
      applyVideoFilter();
    }
  }

  void applyVideoFilter() {
    final String command =
        '-i ${widget.videoPath} -vf "eq=brightness=$_brightness:contrast=$_contrast:saturation=$_saturation" output.mp4';

    FlutterFFmpeg().execute(command).then((rc) {
      print('FFmpeg process exited with rc $rc');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
