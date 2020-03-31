import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import 'mask_page.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
// import 'package:help_corona/src/temp2.dart';
import 'hospital_page.dart';
// import 'package:help_corona/src/temptemp.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double width;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    _selectedIndex = index;

    switch (index) {
      case 0:
        break;
      case 1:
      Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HospitalPage()));
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MaskPage()));
        break;
    }
  }

 

  Widget _dailyEntireStatistics(BuildContext context) {
      return Container(
      height: 300,
      width: width,
      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      decoration: BoxDecoration(
        // color: Color(0xfff2f8ff),
        borderRadius: BorderRadius.all(const Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          Text('국내 현황',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),          
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: charts.PieChart(
              _seriesPieData,
              animate: true,
              animationDuration: Duration(seconds: 3),
              behaviors: [
                new charts.DatumLegend(
                  outsideJustification: charts.OutsideJustification.endDrawArea,
                  horizontalFirst: false,
                  desiredMaxRows: 2,
                  cellPadding: new EdgeInsets.only(right: 4, bottom: 4),
                  entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.purple.shadeDefault,
                    fontFamily: 'Georgia',
                    fontSize: 11,
                  ),
                )
              ],
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 100,
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.outside,
                    )
                  ]),
            ),
          )
        ]
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff2d4059),
      appBar: AppBar(
        backgroundColor: Color(0xff2d4059),
        elevation: 0,
        centerTitle: true,
        title: Text('코로나 현황'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => {},
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Color(0xff2d4059),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Color(0xffffd460),
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('홈'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            title: Text('선별 진료소'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            title: Text('마스크 구매'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _dailyEntireStatistics(context),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _seriesPieData = List<charts.Series<Task, String>>();

    _generateData();
  }
  
  List<charts.Series<Task, String>> _seriesPieData;

  _generateData() {
    var pieData = [
      new Task('work', 30, Colors.yellow),
      new Task('work2', 40, Colors.red),
    ];

    _seriesPieData.add(
      charts.Series(
        data: pieData,
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Daily Task',
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}