import 'package:csv/csv_settings_autodetection.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:help_corona/src/helper/data_manager.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<List<dynamic>> data = [];

  void getData(int cases, String url) async {
    // make the request
    final myData = await http.get(url);

    var d = new FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    List<List<dynamic>> csvTable =
        CsvToListConverter(csvSettingsDetector: d).convert(myData.body);
    data = csvTable;

    switch (cases) {
      case 0:
        DataManager.allDates = new List(data.length);
        for (int i = 0; i < data.length; i++) {
          DataManager.allDates[i] = data[i];
        }
        break;
      case 1:
        DataManager.dailyData = new List(data.length);
        for (int i = 0; i < data.length; i++) {
          DataManager.dailyData[i] = data[i];
        }
        break;
      case 2:
        DataManager.hospitalData = new List(data.length);
        DataManager.seoulHospitalData = new List<dynamic>();
        DataManager.seoulHospitalData = new List<dynamic>();
        DataManager.busanHospitalData = new List<dynamic>();
        DataManager.daeguHospitalData = new List<dynamic>();
        DataManager.incheonHospitalData = new List<dynamic>();
        DataManager.gwangjuHospitalData = new List<dynamic>();
        DataManager.daejeonHospitalData = new List<dynamic>();
        DataManager.ulsanHospitalData = new List<dynamic>();
        DataManager.sejongHospitalData = new List<dynamic>();
        DataManager.gyeonggiHospitalData = new List<dynamic>();
        DataManager.gangwonHospitalData = new List<dynamic>();
        DataManager.chungbukHospitalData = new List<dynamic>();
        DataManager.chungnamHospitalData = new List<dynamic>();
        DataManager.jeonbukHospitalData = new List<dynamic>();
        DataManager.jeonnamHospitalData = new List<dynamic>();
        DataManager.kyeongbukHospitalData = new List<dynamic>();
        DataManager.kyeongnamHospitalData = new List<dynamic>();
        DataManager.jejuHospitalData = new List<dynamic>();
        for (int i = 0; i < data.length; i++) {
          DataManager.hospitalData[i] = data[i];
          switch (data[i][1]) {
            case '서울':
              DataManager.seoulHospitalData.add(data[i]);
              break;
            case '부산':
              DataManager.busanHospitalData.add(data[i]);
              break;
            case '대구':
              DataManager.daeguHospitalData.add(data[i]);
              break;
            case '인천':
              DataManager.incheonHospitalData.add(data[i]);
              break;
            case '광주':
              DataManager.gwangjuHospitalData.add(data[i]);
              break;
            case '대전':
              DataManager.daejeonHospitalData.add(data[i]);
              break;
            case '울산':
              DataManager.ulsanHospitalData.add(data[i]);
              break;
            case '세종':
              DataManager.sejongHospitalData.add(data[i]);
              break;
            case '경기':
              DataManager.gyeonggiHospitalData.add(data[i]);
              break;
            case '강원':
              DataManager.gangwonHospitalData.add(data[i]);
              break;
            case '충북':
              DataManager.chungbukHospitalData.add(data[i]);
              break;
            case '충남':
              DataManager.chungnamHospitalData.add(data[i]);
              break;
            case '전북':
              DataManager.jeonbukHospitalData.add(data[i]);
              break;
            case '전남':
              DataManager.jeonnamHospitalData.add(data[i]);
              break;
            case '경북':
              DataManager.kyeongbukHospitalData.add(data[i]);
              break;
            case '경남':
              DataManager.kyeongnamHospitalData.add(data[i]);
              break;
            case '제주':
              DataManager.jejuHospitalData.add(data[i]);
              break;
          }
        }        
        break;
      case 3:
        DataManager.globalDatas = new List(data.length);
        for (int i = 0; i < data.length; i++) {
          DataManager.globalDatas[i] = data[i];
        }
        Navigator.pushReplacementNamed(context, '/home');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    getData(0,
        "https://raw.githubusercontent.com/yeonbeenkim/HelpCorona/master/data/corona_alldates_csv.csv");
    getData(1,
        "https://raw.githubusercontent.com/yeonbeenkim/HelpCorona/master/data/corona_statistics_csv.csv");
    getData(2,
        "https://raw.githubusercontent.com/yeonbeenkim/HelpCorona/master/data/corona_hospital_csv.csv");
    getData(3, 
        "https://raw.githubusercontent.com/yeonbeenkim/HelpCorona/master/data/corona_global_statistics_csv.csv");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffea5455),
      child: SpinKitPumpingHeart(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}
