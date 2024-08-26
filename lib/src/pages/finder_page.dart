import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:animate_do/animate_do.dart';

import 'details_page.dart';

import '../../globals.dart' as globals;

class FinderPage extends StatefulWidget {
  FinderPage({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<FinderPage> {
  Future<Album> futureAlbum;
  final _formKey = GlobalKey<FormState>();
  Map<String, bool> favs = globals.favs;
  String name = globals.pokeName;
  
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diccionario Pokémon',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Diccionario Pokémon'),
            backgroundColor: Colors.red,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Nombre del pokémon..',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Ingresa algún nombre de pokémon';
                          }
                          globals.pokeName = value;
                          setState(() {
                            name = value;
                          });
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              
                              setState(() {
                                futureAlbum = fetchAlbum();
                              });
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    
                    return Text(snapshot.data.name);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
              FutureBuilder<Album>(
                future: futureAlbum,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image(
                      image: NetworkImage(snapshot.data.image),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
              SlideInLeft(
                delay: Duration(milliseconds: 300),
                child: IconButton(
                  splashColor: Colors.yellow,
                  icon: FaIcon( 
                    FontAwesomeIcons.solidStar, 
                    color: ((){
                      if (globals.favs.containsKey(name)) {
                        return (favs[name]) ? Colors.yellow[700] : Colors.black;
                      } else {
                        return Colors.black;
                      }
                    }()),
                    size: 45 
                  ),
                  onPressed: (){
                    setState(() {
                      if (globals.favs.containsKey(name)) {
                        globals.favs[name] = !favs[name];
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigation(),
        ),
    );
  }
}

Future<Album> fetchAlbum() async {
  String name = globals.pokeName;
  final response = await http.get('https://pokeapi.co/api/v2/pokemon/$name');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int id;
  final String name;
  final String image;

  Album({this.id, this.name, this.image});

  factory Album.fromJson(Map<String, dynamic> json) {

    String name = json['name'];

    globals.idPokemon = json['id'];
    globals.image = json['sprites']['front_default'];

    for (var i = 0; i < json['abilities'].length; i++) {
      globals.abilities.add(json['abilities'][i]['ability']['name']);
    }

    for (var i = 0; i < json['stats'].length; i++) {
      String name = json['stats'][i]['stat']['name'];
      int stat = json['stats'][i]['base_stat'];

      globals.stats['$name'] = stat;
    }

    if (!globals.favs.containsKey(name)) {
      globals.favs.addAll({name:false});
    } 

    return Album(
      id: json['id'],
      name: name,
      image: json['sprites']['front_default'],
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
          if (index == 1) {
            Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => DetailsPage()));
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