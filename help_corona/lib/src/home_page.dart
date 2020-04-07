import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'mask_page.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'hospital_page.dart';

import 'package:help_corona/src/helper/local_statistics_page.dart' as localPage;
import 'package:help_corona/src/helper/global_statistics_page.dart' as globalPage;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  double width;
  int _selectedIndex = 0;

  List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<Sales, int>> _seriesLineData;
  List<charts.Series<LinearSales, int>> _seriesLineDateData;

  _generateData() {
    var data1 = [
      new Pollution(1980, 'USA', 30),
      new Pollution(1980, 'Asia', 40),
      new Pollution(1980, 'Europe', 10),
    ];
    var data2 = [
      new Pollution(1985, 'USA', 100),
      new Pollution(1980, 'Asia', 150),
      new Pollution(1985, 'Europe', 80),
    ];
    var data3 = [
      new Pollution(1985, 'USA', 200),
      new Pollution(1980, 'Asia', 300),
      new Pollution(1985, 'Europe', 180),
    ];

    var piedata = [
      new Task('Work', 35.8, Color(0xff3366cc)),
      new Task('Eat', 8.3, Color(0xff990099)),
      new Task('Commute', 10.8, Color(0xff109618)),
      new Task('TV', 15.6, Color(0xfffdbe19)),
      new Task('Sleep', 19.2, Color(0xffff9900)),
      new Task('Other', 10.3, Color(0xffdc3912)),
    ];

    var linesalesdata = [
      new Sales(0, 45),
      new Sales(1, 56),
      new Sales(2, 55),
      new Sales(3, 60),
      new Sales(4, 61),
      new Sales(5, 70),
    ];
    var linesalesdata1 = [
      new Sales(0, 35),
      new Sales(1, 46),
      new Sales(2, 45),
      new Sales(3, 50),
      new Sales(4, 51),
      new Sales(5, 60),
    ];

    var linesalesdata2 = [
      new Sales(0, 20),
      new Sales(1, 24),
      new Sales(2, 25),
      new Sales(3, 40),
      new Sales(4, 45),
      new Sales(5, 60),
    ];

    var simpleLineData1 = [      
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ), 
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2018',
        data: data2,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
           charts.ColorUtil.fromDartColor(Color(0xff109618)),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2019',
        data: data3,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
       fillColorFn: (Pollution pollution, _) =>
          charts.ColorUtil.fromDartColor(Color(0xffff9900)),
      ),
    );

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
         labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Air Pollution',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );

    _seriesLineDateData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'sales',
        data: simpleLineData1,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _seriesData = List<charts.Series<Pollution, String>>();
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _seriesLineDateData = List<charts.Series<LinearSales, int>>();
    _generateData();

    controller = new TabController(
      vsync: this,
      length: 2
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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

  Widget _koreaDailyStatistics (BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xfff2f8ff),
        borderRadius: BorderRadius.all(const Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          Text('국내 현황',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),          
          ),
          SizedBox(
            height: 10,
          ),
          
        ],
      ),
    );
  }

  Widget _dailyEntireStatistics(BuildContext context) {
      return Container(
      height: 400,
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
              animationDuration: Duration(seconds: 2),
              behaviors: [
                new charts.DatumLegend(
                  outsideJustification: charts.OutsideJustification.endDrawArea,
                  horizontalFirst: false,
                  desiredMaxRows: 2,
                  cellPadding: new EdgeInsets.only(right: 3, bottom: 3),
                  entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.white,
                    // color: charts.MaterialPalette.purple.shadeDefault,
                    // fontFamily: 'Georgia',
                    fontSize: 14,
                  ),
                )
              ],
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 100,
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.inside,
                    )
                  ]),
            ),
          )
        ]
      )
    );
  }

  Widget _lineChartsView(BuildContext context) {
    var axis = charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: 10,
          color: charts.MaterialPalette.white
        )
      )
    );

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
          Text('라인차트',
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
            child: charts.LineChart(
              _seriesLineData,
              defaultRenderer: new charts.LineRendererConfig(
                includeArea: true,
                stacked: true
              ),
              animate: true,
              animationDuration: Duration(seconds: 3),
              behaviors: [
                new charts.ChartTitle(
                  'years',
                  behaviorPosition: charts.BehaviorPosition.bottom,
                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                ),
                new charts.ChartTitle(
                  'sales',
                  behaviorPosition: charts.BehaviorPosition.start,
                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                ),
                new charts.ChartTitle(
                  'departments',
                  titleStyleSpec: charts.TextStyleSpec(color: charts.MaterialPalette.white),
                  behaviorPosition: charts.BehaviorPosition.end,
                  titleOutsideJustification: charts.OutsideJustification.middleDrawArea
                ),
              ],
              // primaryMeasureAxis: axis,
              // domainAxis: axis,
            ),
          )
        ]
      )
    );
  }

  Widget _barChartsView(BuildContext context) {
    return Container(
      height: 500,
      width: width,
      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      decoration: BoxDecoration(
        // color: Color(0xfff2f8ff),
        borderRadius: BorderRadius.all(const Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          Text('바차트',
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
            child: charts.BarChart(
              _seriesData,
              animate: true,
              barGroupingType: charts.BarGroupingType.grouped,
              animationDuration: Duration(seconds: 3),
            ),
          )
        ]
      )
    );
  }

  Widget _simpleLineChartsView(BuildContext context) {
    return Container(
      height: 500,
      width: width,
      padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
      margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
      decoration: BoxDecoration(
        // color: Color(0xfff2f8ff),
        borderRadius: BorderRadius.all(const Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          Text('날짜차트',
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
            child: charts.LineChart(
              _seriesLineDateData,
              animate: true,
              // barGroupingType: charts.BarGroupingType.grouped,
              animationDuration: Duration(seconds: 3),
              // dateTimeFactory: const charts.LocalDateTimeFactory(),
            ),
          )
        ]
      )
    );
  }

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  Widget _showWebView(BuildContext context) {
    return WebView(
      initialUrl: "https://google.com/covid19-map/?hl=ko",
      onWebViewCreated: (WebViewController webviewController) {
        _controller.complete(webviewController);
      },
    );
  }

  TabController controller;


  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color(0xff2d4059),
      // backgroundColor: Color(0xff2d4059),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Colors.black54,
            blurRadius: 10
          )]
        ),      
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[700],
        type: BottomNavigationBarType.fixed,
        // elevation: 0,
        // backgroundColor: Color(0xff2d4059),
        // showSelectedLabels: true,
        // showUnselectedLabels: true,
        // selectedItemColor: Color(0xffffd460),
        // unselectedItemColor: Colors.grey.shade400,
        // type: BottomNavigationBarType.fixed,
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
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        // backgroundColor: Color(0xff2d4059),
        elevation: 0,
        centerTitle: true,
        title: Text('코로나 통계'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => {},
        ),
        bottom: new TabBar(
          indicatorColor: Colors.blue[300],
          indicatorWeight: 5,
          controller: controller,
          tabs: <Widget>[
            new Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.location_on),
                  Text(
                    "   국내 현황",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
            new Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.language),
                  Text(
                    "   전세계",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ],
              ),
              // text: "글로벌",
              // icon: new Icon(Icons.language),
            )
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new localPage.LocalStatisticsPage(),
          new globalPage.GlobalStatisticsPage(),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       Container(
      //         margin: EdgeInsets.all(20),
      //         child: Text(
      //           "국내 현황",
      //           style: TextStyle(
      //             fontSize: 20,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.white
      //           ),
      //         ),
      //       ),
      //       // _showWebView(context),
      //       // _koreaDailyStatistics(context),
      //       // _dailyEntireStatistics(context),
      //       _lineChartsView(context),
      //       // _barChartsView(context),
      //       // _simpleLineChartsView(context),     
      //     ],
      //   ),
      // ),
    );
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}