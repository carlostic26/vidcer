import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';

class VideoChooser extends StatelessWidget {
  const VideoChooser({super.key});

  @override
  Widget build(BuildContext context) {
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
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: 10, // Puedes ajustar esto según tu necesidad
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // Construir el widget del video en el índice actual
                  return Container(
                    color: Colors.grey,
                    // Agregar lógica para mostrar el video en lugar del contenedor
                    child: Center(
                      child: Text('Video $index'),
                    ),
                  );
                },
              ),
            );
          } else {
            // Permisos no otorgados, mostrar el botón para solicitar permisos
            return Column(
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
            );
          }
        },
      ),
    );
  }
}
