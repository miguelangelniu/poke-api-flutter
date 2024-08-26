import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'finder_page.dart';

import '../../globals.dart' as globals;


class DetailsPage extends StatefulWidget {
  DetailsPage({Key key}) : super(key: key);

  @override
  _DetailsPage createState() => _DetailsPage();
}

class _DetailsPage extends State<DetailsPage> {

  //ATTR POKES
  String pokename = globals.pokeName;
  String pokeabilities = globals.abilities[0];
  String image = globals.image;
  Map<String, int> listaDeStats = globals.stats;

  //PREFERENCIAS USUARIO
  //Map<String, bool> favoritos = globals.favs;

  //VARIABLES PARA DESAROLLOR
  Iterable<String> keys = globals.stats.keys;

  @override
  Widget build(BuildContext context) {

    final rows = <TableRow>[];

    for (var rowData in keys) {
      rows.add(TableRow(
          children: [
            TableCell(child: Center(child: Text('$rowData'))),
            TableCell(child: Center(child: Text('${listaDeStats[rowData]}'))),
          ]
      ));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diccionario Pokémon',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Diccionario Pokémon'),
          backgroundColor: Colors.red,
        ),
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('$pokename', style: TextStyle(fontSize: 45)),
              Image(image: NetworkImage(image)),
              Table(
                border: TableBorder.all(color: Colors.black),
                children: rows,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(),
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  
  @override
  _BottomNavigation createState() => _BottomNavigation();
  
}

class _BottomNavigation extends State<BottomNavigation> {
  int index = 0;
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(
      backgroundColor: Colors.red,
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      onTap: (value) {
        setState(() {
          index = value;
          if (index == 0) {
            Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => FinderPage()));
          } 
          
        });
      },
      items: [
        BottomNavigationBarItem(
          label: "Inicio", 
          icon: FaIcon(FontAwesomeIcons.search, color: Colors.white),
        ),

        BottomNavigationBarItem(
          label: "Detalles", 
          icon: FaIcon(FontAwesomeIcons.dna, color: Colors.white),
        ),

        BottomNavigationBarItem(
          label: "Favoritos",
          icon: FaIcon(FontAwesomeIcons.star, color: Colors.white),
        ),

        BottomNavigationBarItem(
            label: "Noticias", 
            icon: FaIcon(FontAwesomeIcons.newspaper, color: Colors.white),
          )
      ],
    );
  }
}