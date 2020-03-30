import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart';

// import 'dart:async' show Future;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<List<dynamic>> data = [];

  // void getData() async {
    
  //   Response response = await get('https://raw.githubusercontent.com/yeonbeenkim/HelpCorona/master/data/corona_statistics_csv.csv');

  //   print(response.body);
  //   // // simulate network request for a username
  //   // await Future.delayed(Duration(seconds: 3), () {
  //   //   print('hey');
  //   // });

  //   // // simulate network request to get bio of the usrename
  //   // Future.delayed(Duration(seconds: 2), () {
  //   //   print('bega, musician');
  //   // });
  // }


/*
  loadAsset() async {
    // final dt = await rootBundle.loadString("https://raw.githubusercontent.com/yeonbeenkim/HelpCorona/master/data/corona_statistics_csv.csv");
    final myData = await get('https://raw.githubusercontent.com/yeonbeenkim/HelpCorona/master/data/corona_statistics_csv.csv');

    // Future.delayed(Duration(seconds: 2), (){
    print(myData.body);
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData.body);

    return csvTable;
    // });
    // print(myData.body);
    // List<List<dynamic>> csvTable = CsvToListConverter().convert(myData.body);

    // return csvTable;
  }


var newdata;

  void getData() async{
    newdata = await loadAsset();
  }

  @override
  void initState() {
    super.initState();
    print('aaaaa');
    getData();
    Future.delayed(Duration(seconds: 4),(){
      setState(() {
      data = newdata;
    });
    }
    
    ); 
    
    // setState(() {
    //   data = newdata;
    // });
    //print(data);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }
  */

  loadAsset() async {
    final myData = await get("https://raw.githubusercontent.com/yeonbeenkim/HelpCorona/master/data/corona_statistics_csv.csv");

    var d = new FirstOccurrenceSettingsDetector(eols: ['\r\n', '\n'],textDelimiters: ['"',"'"]);
    List<List<dynamic>> csvTable = CsvToListConverter(csvSettingsDetector: d).convert(myData.body);
    data = csvTable;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () async {
          await loadAsset();
          print(data);
        },
      ),
      body: SafeArea(
        child: Center(
        child: SingleChildScrollView(
          child: Table(
            columnWidths: {
              0:FixedColumnWidth(60),
              1:FixedColumnWidth(80),
              2:FixedColumnWidth(60),
              3:FixedColumnWidth(75),
              4:FixedColumnWidth(50),
            },
            border: TableBorder.all(width:1,),
          children: data.map((item) {
            return TableRow(
              children: item.map((row){
                return Container(
                  color: Colors.blueGrey,
                  alignment: Alignment.center,
                  // color: row.toString().contains("0") ? Colors.red : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      row.toString(),
                      style: TextStyle(fontSize: 15,color: Colors.white),
                    ),
                  ),
                );
              }).toList());
          }).toList(),
          ),
        ),
      ),
      // backgroundColor: Colors.blueGrey,
      // body: Center(
      //   child: SpinKitFadingCube(
      //     color: Colors.white,
      //     size: 50.0,
      //     ),
      // ),
      )
    );
  }
}
