// theme.dart

import 'package:flutter/material.dart';


final ThemeData vidcerTheme = ThemeData(

  brightness: Brightness.dark,

  primaryColor: const Color.fromARGB(255, 13, 17, 25),

  colorScheme: ColorScheme.dark().copyWith(

    secondary:
        const Color.fromARGB(255, 255, 140, 0), // Color naranja semioscuro

  ),

  hintColor: Colors.grey,

  textTheme: const TextTheme(

    bodyText1: TextStyle(color: Colors.white),

    bodyText2: TextStyle(color: Colors.white),

  ),

  elevatedButtonTheme: ElevatedButtonThemeData(

    style: ButtonStyle(

      backgroundColor: MaterialStateProperty.resolveWith<Color>(

        (Set<MaterialState> states) {

          if (states.contains(MaterialState.pressed)) {

            return Colors.orange
                .shade700; // Color naranja oscuro cuando se presiona el botón

          }

          return const Color.fromARGB(
              255, 255, 140, 0); // Color naranja semioscuro por defecto

        },

      ),

    ),

  ),

);

