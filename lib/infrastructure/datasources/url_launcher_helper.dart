import 'package:url_launcher/url_launcher.dart';

// Abre el enlace en el navegador por defecto
Future<void> abrirEnlace(Uri url) async {
  await launchUrl(url, mode: LaunchMode.platformDefault);
}
