import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:help_corona/src/home_page.dart';
import 'package:help_corona/src/hospital_page.dart';
import 'package:help_corona/src/loading_screen.dart';

import 'package:help_corona/src/ordinal_bar_line_chart.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(        
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => LoadingScreen(),
        '/home' : (context) => HomePage(),
        '/hospital' : (context) => HospitalPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
