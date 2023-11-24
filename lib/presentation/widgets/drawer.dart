import 'package:flutter/material.dart';
import 'package:video_enhancer/infrastructure/datasources/url_launcher_helper.dart';

class DrawerVidcer extends StatelessWidget {
  final BuildContext context;
  const DrawerVidcer({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return _getDrawer(context);
  }

  Widget _getDrawer(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: Colors.grey[850],
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: const Text(
                "Vidcer - Video Enhancer",
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: const Text(
                "www.ticnoticos.com",
                style: TextStyle(color: Colors.white),
              ),
              currentAccountPicture: Image.asset('assets/logo.png'),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  image: const DecorationImage(
                      image: AssetImage('assets/blue_background.jpg'),
                      fit: BoxFit.cover)),
            ),
            //Inicio de opciones de drawer -----------------------------------
            const Divider(
              color: Colors.grey,
            ),

            ListTile(
                title: const Row(
                  children: [
                    Text("Eliminar anuncios",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                leading: const Icon(
                  Icons.auto_delete,
                  color: Colors.white,
                ),
                //at press, run the method
                onTap: () {}),

            ListTile(
                title: const Text("Reportar un problema",
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(
                  Icons.mark_email_read,
                  color: Colors.white,
                ),
                //at press, run the method
                onTap: () {} //_mailto(),
                ),
            const SizedBox(height: 20),

            const Divider(
              color: Colors.grey,
            ),
            const Text("  Información", style: TextStyle(color: Colors.white)),

            ListTile(
              //Nombre de la app, objetivo, parrafo de uso basico, creador, linkedin de creador, etc
              title: const Text("Info de la app",
                  style: TextStyle(color: Colors.white)),
              leading: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              //at press, run the method
              onTap: () {},
            ),
            ListTile(
              title: const Text("Politica de privacidad",
                  style: TextStyle(color: Colors.white)),
              leading: const Icon(
                Icons.policy,
                color: Colors.white,
              ),
              //at press, run the method
              onTap: () => abrirEnlace(Uri.parse('https://www.bing.com')),
            ),
            ListTile(
                title: const Text("Ayúdanos a mejorar",
                    style: TextStyle(color: Colors.white)),
                leading: const Icon(
                  Icons.feedback,
                  color: Colors.white,
                ),
                //at press, run the method
                onTap: () {}),
          ],
        ),
      ),
    );
  }
}
