import 'package:flutter/material.dart';
import 'package:help_corona/src/helper/data_manager.dart';

class GlobalStatisticsPage extends StatefulWidget {
  @override
  _GlobalStatisticsPageState createState() => _GlobalStatisticsPageState();
}

class _GlobalStatisticsPageState extends State<GlobalStatisticsPage> {
  List<GlobalStatistics> statistics = [];
  bool sort;
  int columnIndex = 1;
  // List<charts.Series<ConfirmedCaseNumber, dynamic>> _seriesLineData = [];
  // List<charts.Series> seriesList = [];

  getData() async {
    DataManager.globalDatas.forEach((item) {
      // print(item);
      // if (i > 0) {
        statistics.add(GlobalStatistics(
            country: item[0].toString(),
            confirmedCase: int.parse(item[1].toString()),
            confirmedPercent: int.parse(item[2].toString()),
            cured: int.parse(item[3].toString()),
            death: int.parse(item[4].toString()),
            ));
      // }
      // i++;
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
            "비율",
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
                        statistics.country,
                        style: TextStyle(
                            // color: Colors.white,
                            fontSize: 15),
                      ),
                    ),
                ),
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
                      statistics.confirmedPercent.toString(),
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
                padding: EdgeInsets.fromLTRB(10, 10, 25, 8),
                alignment: Alignment.centerRight,
                child: Text(
                  // "검역은 국내 입국 과정 중 검역소에서 확진된 사례\n" +
                      DataManager.globalDatas[1][0] +
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

class GlobalStatistics {
  String country;
  int confirmedCase;
  int confirmedPercent;
  int cured;
  int death;

  GlobalStatistics(
      {this.country,
      this.confirmedCase,
      this.confirmedPercent,
      this.cured,
      this.death});
}
