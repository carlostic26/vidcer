import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_enhancer/presentation/widgets/drawer.dart';

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
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: SizedBox(
                    height: sizeHeigt * 0.2, child: const Placeholder()),
              ),
              const SizedBox(height: 20),
              SizedBox(height: sizeHeigt * 0.55, child: const Placeholder()),
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
