/* import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';

class WorkScreenNew extends StatefulWidget {
  String videoPath;

  WorkScreenNew({Key? key, required this.videoPath}) : super(key: key);

  @override
  _WorkScreenNewState createState() => _WorkScreenNewState();
}

class _WorkScreenNewState extends State<WorkScreenNew> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.videoPath);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _applyFilters() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Procesando...')),
    );

    print("START TO PROCESS...");

    String commandToExecute =
        '-i ${widget.videoPath} -vf "eq=brightness=0.06:saturation=2" output.mp4';
    await FFmpegKit.executeAsync(commandToExecute, (session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        print("SUCCESS");
        setState(() {
          widget.videoPath = 'output.mp4';
          _controller = VideoPlayerController.file(File(widget.videoPath));
          _initializeVideoPlayerFuture = _controller.initialize();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video procesado correctamente')),
        );
      } else if (ReturnCode.isCancel(returnCode)) {
        print("CANCEL");
      } else {
        print("ERROR");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _applyFilters,
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
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
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
} */

/*

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class WorkScreen extends StatefulWidget {
  final String videoPath;

  WorkScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late VideoPlayerController _controller;
  double _brightness = 1.0;
  double _contrast = 1.0;
  double _saturation = 1.0;
  double _currentTime = 0.0;
  late ProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();

    Fluttertoast.showToast(
      msg: 'Ruta de video: ${widget.videoPath}',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 12.0,
    );

    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      if (!_controller.value.isPlaying) {
        setState(() {
          _currentTime = _controller.value.position.inSeconds.toDouble();
        });
      }
    });

    progressDialog = ProgressDialog(context);
    progressDialog.style(
      message: 'Procesando video...',
      progressWidget: CircularProgressIndicator(),
      maxProgress: 100.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;

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
                    _RenderingVideoDialog();
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
              title: const Text('Ajustar Video'),
              content: Column(
                children: [
                  _buildSlider(
                    'Brillo',
                    _brightness,
                    (double value) {
                      setState(() {
                        _brightness = value;
                      });
                      _updateVideoAdjustments();
                    },
                  ),
                  _buildSlider(
                    'Contraste',
                    _contrast,
                    (double value) {
                      setState(() {
                        _contrast = value;
                      });
                      _updateVideoAdjustments();
                    },
                  ),
                  _buildSlider(
                    'Saturación',
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
    if (rc == 0) {
      print("Proceso FFmpeg finalizado con éxito");
    } else {
      print("Error en el proceso FFmpeg. Código de retorno: $rc");
    }

    _controller.pause();
    _controller.seekTo(const Duration(seconds: 0));

    _controller = VideoPlayerController.file(File(outputPath))
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
    final String outputPath =
        widget.videoPath.replaceFirst('.mp4', '_filtered.mp4');
    final String command =
        '-i ${widget.videoPath} -vf "eq=brightness=$_brightness:contrast=$_contrast:saturation=$_saturation" $outputPath';

    FlutterFFmpeg().execute(command).then((rc) {
      print('Proceso FFmpeg finalizado con rc $rc');
    });
  }

  void _RenderingVideoDialog() async {
    //progressDialog.show();

    try {
      final String outputPath =
          widget.videoPath.replaceFirst('.mp4', '_procesado.mp4');
      final String command =
          '-i ${widget.videoPath} -vf "eq=brightness=$_brightness:contrast=$_contrast:saturation=$_saturation" $outputPath';

      final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
      await flutterFFmpeg.execute(command);

      progressDialog.hide();
      Fluttertoast.showToast(
        msg: 'Video procesado y guardado en: $outputPath',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    } catch (e) {
      print('Error al procesar el video: $e');
      progressDialog.hide();
      Fluttertoast.showToast(
        msg: 'Error al procesar el video: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

*/