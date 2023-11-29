import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:vidcer/presentation/provider/riverpod_provider.dart';
import 'package:vidcer/presentation/screens/video_player_screen.dart';

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
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: 10, // Puedes ajustar esto según tu necesidad
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // Construir el widget del video en el índice actual
                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedVideoProvider.notifier).state =
                                index;
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                color: Colors.grey,
                                // Agregar lógica para mostrar el video en lugar del contenedor
                                child: Center(
                                  child: Text('Video $index'),
                                ),
                              ),
                              if (ref
                                      .read(selectedVideoProvider.notifier)
                                      .state ==
                                  index)
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 50.0),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      ref.read(selectedVideoProvider.notifier).state != null
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
                  child: Text('Comenzar'),
                ),
              ],
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
    );
  }
}
