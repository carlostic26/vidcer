import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WorkScreen extends StatelessWidget {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeHeigt = MediaQuery.of(context).size.height;
    final sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
            child: Row(children: [
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
            ]),
          ),
        ],
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [Placeholder()],
          ),
        ),
      ),
    );
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
                // Añade este widget
                type: MaterialType
                    .transparency, // Hace que el Material sea transparente
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
