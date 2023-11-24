import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'domain/controller/theme_preferences.dart';
import 'presentation/screens/loading_screen.dart';
import 'presentation/theme.dart';

Future<void> main() async {
/*   // init adv
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
 */
  //init theme
  final themePreference = ThemePreference();
  await themePreference.initialize();

/*   //init db sqlite
  await DatabaseHandler().initializeDB();
  await DatabaseTICHandler().initializeDB();

  await MobileAds.instance.initialize();
  // Inicializar anuncio de apertura y cancelar después de 9 segundos

  await loadOpenAd(); */

/*   Timer(Duration(seconds: 10), () async {
    if (isAdLoaded == false) {
      openAd?.dispose();
      print("Anuncio de apertura cancelado después de 15 segundos.");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('adCancelado', true);
    } else {
      print("Anuncio de apertura mostrado correctamente.");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('adCancelado', false);
    }
  }); */
/* 
  //solicitar permisos local notification
  await LocalNotifications.initializeLocalNotificatios();
  await LocalNotifications.requestPermissionLocalNotification(); */

  runApp(ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: vidcerTheme,
      home: LoadingScreen(),
    ),
  ));
}
