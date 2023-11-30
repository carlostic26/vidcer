import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vidcer/presentation/provider/riverpod_provider.dart';
import 'package:vidcer/presentation/screens/work_screen.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class VideoChooser extends ConsumerWidget {
  const VideoChooser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Elige el video',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0, /*fontWeight: FontWeight.bold*/
          ),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [],
        centerTitle: true,
      ),
      body: FutureBuilder<PermissionStatus>(
        future: Permission.storage.status,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == PermissionStatus.granted) {
            // Permisos otorgados, mostrar la galería de videos
            return FutureBuilder<List<FileSystemEntity>>(
              future: _getVideos(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0, // Reducir el espaciado
                        mainAxisSpacing: 5.0, // Reducir el espaciado
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String path = snapshot.data![index].path;
                        return FutureBuilder<Uint8List>(
                          future: _getVideoThumbnail(path),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  print(
                                      'Vídeo seleccionado: ${ref.watch(selectedVideoProvider.notifier).state}');
                                  ref
                                      .watch(selectedVideoProvider.notifier)
                                      .state = (ref
                                              .watch(selectedVideoProvider
                                                  .notifier)
                                              .state ==
                                          path
                                      ? null
                                      : path);
                                },
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ),
                                    if (ref
                                            .watch(
                                                selectedVideoProvider.notifier)
                                            .state ==
                                        path)
                                      Container(
                                        color: Colors.orange.withOpacity(0.6),
                                      ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                color: Colors.grey,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No se encontraron videos.'),
                  );
                }
              },
            );
          } else {
            // Permisos no otorgados, mostrar el botón para solicitar permisos
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No has dado permiso a la app de cargar tus videos',
                    style: TextStyle(fontSize: 12),
                  ),
                  TextButton(
                    child: const Text('Solicitar permiso'),
                    onPressed: () async {
                      var status = await Permission.storage.request();
                      if (status.isGranted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const VideoChooser()),
                        );
                        // El permiso fue concedido
                        Fluttertoast.showToast(
                          msg: "Permiso concedido",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      } else {
                        // El permiso fue denegado
                        Fluttertoast.showToast(
                          msg: "Permiso denegado",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton:
          ref.watch(selectedVideoProvider.notifier).state != null
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkScreen(
                          videoPath:
                              ref.read(selectedVideoProvider.notifier).state!,
                        ),
                      ),
                    );
                  },
                  child: const Text('Mejorar'),
                )
              : null,
    );
  }

  Future<List<FileSystemEntity>> _getVideos() async {
    final List<String> directories = [
      '/storage/emulated/0/DCIM',
      '/storage/emulated/0/Movies',
      '/storage/emulated/0/WhatsApp/Media/WhatsApp Video',
      '/storage/emulated/0/Telegram/Telegram Video',
      '/storage/emulated/0/Download',
      // Añade más directorios si es necesario
    ];

    final List<String> videoExtensions = [
      '.mp4',
      '.avi',
      '.mov',
      '.flv',
      '.wmv',
      '.mkv'
    ];

    List<FileSystemEntity> videos = [];

    for (String directoryPath in directories) {
      final Directory dir = Directory(directoryPath);

      if (await dir.exists()) {
        videos.addAll(
          dir
              .listSync(followLinks: false, recursive: true)
              .where((FileSystemEntity entity) {
            return videoExtensions.any(
                (extension) => entity.path.toLowerCase().endsWith(extension));
          }).toList(),
        );
      }
    }

    return videos;
  }

  Future<Uint8List> _getVideoThumbnail(String videoPath) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    return uint8list!;
  }
}

/*
Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: ref.read(selectedVideoProvider.notifier).state !=
                            null
                        ? () {
                            // Navegar a la nueva pantalla con el video seleccionado
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                    videoIndex: ref
                                        .read(selectedVideoProvider.notifier)
                                        .state!),
                              ),
                            );
                          }
                        : null,
                    child: const Text('Comenzar'),
                  ),
                ),

*/