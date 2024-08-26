import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'finder_page.dart';

class StartLoadPage extends StatefulWidget {
  StartLoadPage({Key key}) : super(key: key);

  @override
  _StartLoadPage createState() => _StartLoadPage();
}

class _StartLoadPage extends State<StartLoadPage> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FinderPage()));
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Pulse(
                infinite: true,
                child: Text('Pokémon', style: TextStyle(fontSize: 65, color: Colors.white)),
              ),
              Spin(
                infinite: true,
                child: FaIcon( FontAwesomeIcons.spinner, color: Colors.white, size: 80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}