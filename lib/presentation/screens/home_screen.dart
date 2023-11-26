import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidcer/domain/controller/theme.dart';
import 'package:vidcer/presentation/widgets/drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeHeigt = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

//debe tener un drawer para ofrecer la info de app, tutorial, pantalla de alternativas, politica de privacidad
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0, /*fontWeight: FontWeight.bold*/
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                //shareCourse();
              },
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      // Acción al hacer clic en el Container
                      // Puedes poner aquí la lógica que deseas ejecutar al hacer clic
                    },
                    child: Container(
                      height: sizeHeigt * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade900,
                            Colors.orange.shade600,
                          ], // Degradado azul
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: FloatingActionButton(
                              onPressed: () {
                                // Acción al presionar el botón
                              },
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Nuevo proyecto',
                              style: TextStyle(
                                color: vidcerTheme.primaryColor,
                                fontWeight: FontWeight.bold, // Texto en negrita
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: sizeHeigt * 0.55,
                child: Center(
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
                          var status = await Permission.storage.status;
                          if (!status.isGranted) {
                            status = await Permission.storage.request();
                            if (status.isGranted) {
                              // El permiso fue concedido
                              Fluttertoast.showToast(
                                msg: "Permiso concedido", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.BOTTOM, // location
                              );
                            } else {
                              // El permiso fue denegado
                              Fluttertoast.showToast(
                                msg: "Permiso denegado", // message
                                toastLength: Toast.LENGTH_SHORT, // length
                                gravity: ToastGravity.BOTTOM, // location
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerVidcer(
        context: context,
      ),
    );
  }
}
