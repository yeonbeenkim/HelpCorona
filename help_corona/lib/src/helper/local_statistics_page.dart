// import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:help_corona/src/helper/data_manager.dart';

// import 'package:charts_flutter/flutter.dart' as charts;

class LocalStatisticsPage extends StatefulWidget {
  @override
  _LocalStatisticsPageState createState() => _LocalStatisticsPageState();
}

class _LocalStatisticsPageState extends State<LocalStatisticsPage> {
  List<DailyStatistics> statistics = [];
  bool sort;
  int columnIndex = 1;
  // List<charts.Series<ConfirmedCaseNumber, dynamic>> _seriesLineData = [];
  // List<charts.Series> seriesList = [];

  getData() async {
    int i = 0;
    DataManager.dailyData.forEach((item) {
      // print(item);
      if (i > 0) {
        statistics.add(DailyStatistics(
            city: item[0].toString(),
            confirmedCase: int.parse(item[1].toString()),
            newConfirmedCase: int.parse(item[2].toString()),
            fromOthers: int.parse(item[3].toString()),
            fromLocal: int.parse(item[4].toString()),
            apart: int.parse(item[5].toString()),
            apartEnd: int.parse(item[6].toString()),
            death: int.parse(item[7].toString())));
      }
      i++;
    });
  }

  onSortColumn(int columnIndex, bool ascending) {
    setState(() {
      if (columnIndex == 1) {
        if (ascending) {
          statistics.sort((a, b) => a.confirmedCase.compareTo(b.confirmedCase));
        } else {
          statistics.sort((a, b) => b.confirmedCase.compareTo(a.confirmedCase));
        }
      }
    });
  }

  // _generateData() async {
  //   // List<ConfirmedCaseNumber> lineData = [];

  //   // DataManager.allDates.forEach((item) {
  //   //   lineData.add(
  //   //     ConfirmedCaseNumber(item[0].toString(), int.parse(item[1].toString()))
  //   //   );
  //   // });

  //   // var linesalesdata = [
  //   //   new Sales(0, 45),
  //   //   new Sales(1, 56),
  //   //   new Sales(2, 55),
  //   //   new Sales(3, 60),
  //   //   new Sales(4, 61),
  //   //   new Sales(5, 70),
  //   // ];
  //   // var linesalesdata1 = [
  //   //   new Sales(0, 35),
  //   //   new Sales(1, 46),
  //   //   new Sales(2, 45),
  //   //   new Sales(3, 50),
  //   //   new Sales(4, 51),
  //   //   new Sales(5, 60),
  //   // ];

  //   // var linesalesdata2 = [
  //   //   new Sales(0, 20),
  //   //   new Sales(1, 24),
  //   //   new Sales(2, 25),
  //   //   new Sales(3, 40),
  //   //   new Sales(4, 45),
  //   //   new Sales(5, 60),
  //   // ];

  //   // _seriesLineData.add(
  //   //   charts.Series(
  //   //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
  //   //     id: '총 확진자 수',
  //   //     data: lineData,
  //   //     domainFn: (ConfirmedCaseNumber confirmCase, _) => confirmCase.date,
  //   //     measureFn: (ConfirmedCaseNumber confirmCase, _) => confirmCase.totalConfirmedCase,
  //   //   ),
  //   // );

  //   // return [
  //   //   new charts.Series<ConfirmedCaseNumber, String>(
  //   //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
  //   //     id: '총 확진자 수',
  //   //     data: lineData,
  //   //     domainFn: (ConfirmedCaseNumber confirmCase, _) => confirmCase.date,
  //   //     measureFn: (ConfirmedCaseNumber confirmCase, _) => confirmCase.totalConfirmedCase,
  //   //   ),
  //   // ];

  //   // _seriesLineData.add(
  //   //   charts.Series(
  //   //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
  //   //     id: 'Air Pollution',
  //   //     data: linesalesdata,
  //   //     domainFn: (Sales sales, _) => sales.yearval,
  //   //     measureFn: (Sales sales, _) => sales.salesval,
  //   //   ),
  //   // );
  //   // _seriesLineData.add(
  //   //   charts.Series(
  //   //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.blue),
  //   //     id: 'Air Pollution',
  //   //     data: linesalesdata1,
  //   //     domainFn: (Sales sales, _) => sales.yearval,
  //   //     measureFn: (Sales sales, _) => sales.salesval,
  //   //   ),
  //   // );
  //   // _seriesLineData.add(
  //   //   charts.Series(
  //   //     colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.green),
  //   //     id: 'Air Pollution',
  //   //     data: linesalesdata2,
  //   //     domainFn: (Sales sales, _) => sales.yearval,
  //   //     measureFn: (Sales sales, _) => sales.salesval,
  //   //   ),
  //   // );
  // }

  @override
  void initState() {
    super.initState();
    sort = false;
    getData();
    // _generateData();
  }

  Widget dataBody(BuildContext context) {
    return new DataTable(
      horizontalMargin: 20,
      columnSpacing: 25,
      sortAscending: sort,
      sortColumnIndex: columnIndex,
      // sortColumnIndex: 1,
      columns: [
        DataColumn(
          // numeric: true,
          label: Text(
            "지역",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: Colors.white,
                fontSize: 15),
          ),
        ),
        DataColumn(
          numeric: true,
          label: Text(
            "총 확진자",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                // color: Colors.white,
                fontSize: 15),
          ),
          onSort: (columnIndex, ascending) {
            setState(() {
              sort = !sort;
            });
            onSortColumn(columnIndex, ascending);
          },
        ),
        DataColumn(
          numeric: true,
          label: Text(
            "신규확진자",
            style: TextStyle(
                // color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          // onSort: (columnIndex, ascending) {
          //   // columnIndex = 2;
          //   setState(() {
          //     sort = !sort;
          //   });
          //   onSortColumn(columnIndex, ascending);
          // },
        ),
        DataColumn(
          numeric: true,
          label: Container(
            alignment: Alignment.center,
            child: Text(
              "사망",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: Colors.white,
                  fontSize: 15),
            ),
          ),
        ),
      ],
      // rows: users
      //     .map((user) => DataRow(cells: [
      //           DataCell(Text(user.firstName), onTap: () {
      //             print('Selected ${user.firstName}');
      //           }),
      //           DataCell(
      //             Text(user.firstName),
      //           ),
      //         ]))
      //     .toList(),
      rows: statistics
          .map((statistics) => DataRow(cells: [
                DataCell(
                    Container(
                      // alignment: Alignment.center,
                      child: Text(
                        statistics.city,
                        style: TextStyle(
                            // color: Colors.white,
                            fontSize: 15),
                      ),
                    ), onTap: () {
                  // if (statistics.city == "전체") {
                  //   // var axis = charts.NumericAxisSpec(
                  //   //     renderSpec: charts.GridlineRendererSpec(
                  //   //         labelStyle: charts.TextStyleSpec(
                  //   //             fontSize: 10,
                  //   //             color: charts.MaterialPalette.white)));

                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           content: Container(
                  //             width: 500,
                  //             height: 300,
                  //             child: Column(
                  //               children: <Widget>[
                  //                 Text('최근 10일 확진자 수'),
                  //                 Expanded(
                  //                   child: charts.LineChart(
                  //                     seriesList,
                  //                     // _seriesLineData,
                  //                     defaultRenderer:
                  //                         new charts.LineRendererConfig(
                  //                             includeArea: true, stacked: true),
                  //                     animate: true,
                  //                     animationDuration: Duration(seconds: 3),
                  //                     // behaviors: [
                  //                     //   new charts.ChartTitle('years',
                  //                     //       behaviorPosition:
                  //                     //           charts.BehaviorPosition.bottom,
                  //                     //       titleOutsideJustification: charts
                  //                     //           .OutsideJustification
                  //                     //           .middleDrawArea),
                  //                     //   new charts.ChartTitle('당일 확진자 수',
                  //                     //       behaviorPosition:
                  //                     //           charts.BehaviorPosition.start,
                  //                     //       titleOutsideJustification: charts
                  //                     //           .OutsideJustification
                  //                     //           .middleDrawArea),
                  //                     //   new charts.ChartTitle('departments',
                  //                     //       titleStyleSpec:
                  //                     //           charts.TextStyleSpec(
                  //                     //               color: charts
                  //                     //                   .MaterialPalette.white),
                  //                     //       behaviorPosition:
                  //                     //           charts.BehaviorPosition.end,
                  //                     //       titleOutsideJustification: charts
                  //                     //           .OutsideJustification
                  //                     //           .middleDrawArea),
                  //                     // ],
                  //                     // primaryMeasureAxis: axis,
                  //                     // domainAxis: axis,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       });
                  // }
                }),
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      statistics.confirmedCase.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      statistics.newConfirmedCase.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      statistics.death.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  placeholder: false,
                ),
              ]))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
              // dividerColor: Colors.green
              ),
          child: Column(
            children: <Widget>[
              Container(
                // margin: EdgeInsets.all(4),
                padding: EdgeInsets.fromLTRB(10, 10, 25, 8),
                alignment: Alignment.centerRight,
                child: Text(
                  "검역은 국내 입국 과정 중 검역소에서 확진된 사례\n" +
                      DataManager.dailyData[0][0] +
                      " 기준",
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0),
                  ],
                ),
                child: FittedBox(
                  alignment: Alignment.center,
                  child: dataBody(context),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyStatistics {
  String city;
  int confirmedCase;
  int newConfirmedCase;
  int fromOthers;
  int fromLocal;
  int apart;
  int apartEnd;
  int death;

  DailyStatistics(
      {this.city,
      this.confirmedCase,
      this.newConfirmedCase,
      this.fromOthers,
      this.fromLocal,
      this.apart,
      this.apartEnd,
      this.death});
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}

class ConfirmedCaseNumber {
  DateTime date;
  // String date;
  int totalConfirmedCase;

  ConfirmedCaseNumber(this.date, this.totalConfirmedCase);
}