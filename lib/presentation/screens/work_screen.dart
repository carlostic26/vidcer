import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WorkScreen extends StatefulWidget {
  final String videoPath;

  const WorkScreen({Key? key, required this.videoPath}) : super(key: key);

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeigt = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

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
        title: const Text(
          'Work screen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0, /*fontWeight: FontWeight.bold*/
          ),
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
                    //shareCourse();
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.tips_and_updates),
                  onPressed: () {
                    dialogConfigRender(context, sizeHeigt);
                  },
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.file_upload),
                  onPressed: () {
                    //shareCourse();
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
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(),
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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void dialogConfigRender(BuildContext context, sizeHeigt) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor:
          Colors.transparent, // Esto hace que el fondo sea transparente
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return SlideInDown(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, sizeHeigt * 0.06, 0, 0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          40), // Esto redondea el borde inferior izquierdo del diálogo
                      bottomRight: Radius.circular(
                          40), // Esto redondea el borde inferior derecho del diálogo
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: sizeHeigt * 0.4),
                  child: Column(
                    children: [
                      Slider(
                        value: 0.5,
                        onChanged: (double newValue) {
                          // Aquí puedes guardar el valor del Slider
                        },
                      ),
                      Slider(
                        value: 0.5,
                        onChanged: (double newValue) {
                          // Aquí puedes guardar el valor del Slider
                        },
                      ),
                      Slider(
                        value: 0.5,
                        onChanged: (double newValue) {
                          // Aquí puedes guardar el valor del Slider
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
