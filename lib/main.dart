import 'package:flutter/material.dart';
//import 'package:pokeapi/src/pages/finder_page.dart';
import 'package:pokeapi/src/pages/start_load_wallpaper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diccionario Pokémon',
        home: StartLoadPage(),//FinderPage(),
    );
  }
}



