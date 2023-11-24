import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_enhancer/domain/controller/theme_preferences.dart';
import 'package:video_enhancer/presentation/screens/home_screen.dart';
import '../provider/riverpod_provider.dart';

class LoadingScreen extends ConsumerWidget {
  final bool _isMounted = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonEnabled = ref.watch(buttonEnabled_rp);

    if (_isMounted) {
      Future.delayed(const Duration(seconds: 10), () {
        activarBoton(ref);
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 17, 25),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              height: 180,
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: Image.asset("assets/logo.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: 250.0,
                    lineHeight: 5,
                    percent: 100 / 100,
                    animation: true,
                    animationDuration: 10000, // 10 sec
                    leading: const Text(
                      "",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: const Text(
                      "",
                      style: TextStyle(
                          fontSize: 20, color: Colors.deepOrangeAccent),
                    ),
                    progressColor: Colors.orange,
                  ),
                ],
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cargando componentes...",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: TextButton(
                  onPressed: buttonEnabled
                      ? () async {
                          isLoaded(context);
                        }
                      : null, // Desactiva el botón si no está habilitado
                  style: ButtonStyle(
                    backgroundColor: buttonEnabled
                        ? MaterialStateProperty.all<Color>(Colors
                            .orange) // Color de fondo cuando está habilitado
                        : MaterialStateProperty.all<Color>(Colors
                            .blueGrey), // Color de fondo cuando está deshabilitado
                  ),

                  child: Text(
                    'Continuar',
                    style: TextStyle(
                        fontSize: 10,
                        color: buttonEnabled ? Colors.black : Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void activarBoton(WidgetRef ref) {
    if (_isMounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isMounted) {
          ref.read(buttonEnabled_rp.notifier).state = true;
        }
      });
    }
  }

  void initTheme(ref) async {
    // init theme
    ThemePreference theme = ThemePreference();

    ref.read(darkTheme_rp.notifier).state = await theme.getTheme();
  }

  isLoaded(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? primerAcceso = prefs.getBool('primerAcceso');

    print('primer acceso bool:$primerAcceso');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomeScreen()));

    //POR SI DESEO PONER PANTALLA DE TUTORIAL

/*     if (primerAcceso == true || primerAcceso == null) {
      /*     Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => TutorialScreen())); */
    } else {
      if (primerAcceso == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } */
  }
}

class CountingAnimation extends StatefulWidget {
  final int endCount;

  CountingAnimation({required this.endCount});

  @override
  _CountingAnimationState createState() => _CountingAnimationState();
}

class _CountingAnimationState extends State<CountingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 9),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: widget.endCount.toDouble())
        .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Text(
          _animation.value.toInt().toString(),
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
