import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidcer/domain/controller/theme.dart';
import 'package:vidcer/presentation/screens/sample_state.dart';
import 'package:vidcer/presentation/screens/video_chooser.dart';
import 'package:vidcer/presentation/screens/work_screen.dart';
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VideoChooser()),
                      );
                    },
                    child: Container(
                      height: sizeHeigt * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade900,
                            Colors.orange.shade600,
                          ],
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const VideoChooser()),
                                );
                              },
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Nuevo proyecto',
                              style: TextStyle(
                                color: vidcerTheme.primaryColor,
                                fontWeight: FontWeight.bold,
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
              const Placeholder(),
              const Placeholder(),
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
