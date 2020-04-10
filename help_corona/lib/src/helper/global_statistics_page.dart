import 'package:flutter/material.dart';
import 'package:help_corona/src/helper/data_manager.dart';
// import 'package:help_corona/src/helper/global_statistics.dart';

class GlobalStatisticsPage extends StatefulWidget {
  // static List<GlobalStatistics> statistics = [];
  @override
  _GlobalStatisticsPageState createState() => _GlobalStatisticsPageState();
}

class _GlobalStatisticsPageState extends State<GlobalStatisticsPage> {
  List<GlobalStatistics> statistics = [];
  bool sort;
  int columnIndex = 1;
  // List<charts.Series<ConfirmedCaseNumber, dynamic>> _seriesLineData = [];
  // List<charts.Series> seriesList = [];

  final pageRefresh = ChangeNotifier();

  Future getData() async {
    DataManager.globalDatas.forEach((item) {
      // int i = 0;
      // print(item);
      // if (i > 0) {
        // setState(() {
          
        statistics.add(GlobalStatistics(
            country: item[0].toString(),            
            confirmedCase: item[1].toString(),
            confirmedPercent: item[2].toString(),
            cured: item[3].toString(),
            death: item[4].toString(),
            // confirmedCase: int.parse(item[1].toString()),
            // confirmedPercent: double.parse(item[2].toString()),
            // cured: int.parse(item[3].toString()),
            // death: int.parse(item[4].toString()),
            ));
            
        });
      // }
      // i++;
    // });
    return statistics;
  }

  onSortColumn(int columnIndex, bool ascending) {
    setState(() {
      if (columnIndex == 1) {
        if (ascending) {
          statistics.sort((a, b) => int.parse(a.confirmedCase).compareTo(int.parse(b.confirmedCase)));
        } else {
          statistics.sort((a, b) => int.parse(b.confirmedCase).compareTo(int.parse(a.confirmedCase)));
        }
      }
    });
  }


  Widget dataBody(BuildContext context) {    
    // print('aaa');
    return new DataTable(
      horizontalMargin: 20,
      columnSpacing: 15,
      sortAscending: sort,
      sortColumnIndex: columnIndex,
      // sortColumnIndex: 1,
      columns: [
        DataColumn(
          numeric: true,
          label: Text(
            "지역                    ",
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
            "비율  ",
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
                  Card(
                    // color: Colors.red,
                    margin: EdgeInsets.all(1),
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(1),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(1),
                            // child: Icon(Icons.language),
                          ),
                          Container(
                            // alignment: Alignment.centerRight,
                            // margin: EdgeInsets.all(5),
                            padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                            child: Text(
                              statistics.country,
                              // textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                    // Container(
                    //   // alignment: Alignment.center,
                    //   child: Text(
                    //     statistics.country,
                    //     style: TextStyle(
                    //         // color: Colors.white,
                    //         fontSize: 15),
                    //   ),
                    // ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      statistics.confirmedCase.toString().replaceAllMapped(
                        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},'),
                      // statistics.confirmedCase.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      statistics.confirmedPercent.toString().replaceAllMapped(
                        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},'),
                      // statistics.confirmedPercent.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      statistics.death.toString().replaceAllMapped(
                        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},'),
                      // statistics.death.toString(),
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
  void initState() {
    super.initState();
    sort = false;
    getData();
    // _generateData();
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
                padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                alignment: Alignment.centerRight,
                child: Text(
                  "비율은 백만 명당 확진자 수\n" +
                      DataManager.dailyData[0][0] +
                      " 기준",
                  textAlign: TextAlign.right,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  ),
                  // borderRadius: BorderRadius.all(Radius.circular(10)),
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
                  // child: FutureBuilder(
                  //   future: getData(),
                  //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //     return dataBody(context);
                  //   },
                  // ),
                  child: dataBody(context),
                ),
              ),
              // SizedBox(
              //   height: 5,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlobalStatistics {
  // String country;
  // int confirmedCase;
  // double confirmedPercent;
  // int cured;
  // int death;
  String country;
  String confirmedCase;
  String confirmedPercent;
  String cured;
  String death;

  GlobalStatistics(
      {this.country,
      this.confirmedCase,
      this.confirmedPercent,
      this.cured,
      this.death});
}
