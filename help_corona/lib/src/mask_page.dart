import 'dart:convert';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'hospital_page.dart';

import 'package:http/http.dart' as http;

class MaskPage extends StatefulWidget {
  MaskPage({Key key}) : super(key: key);

  @override
  _MaskPageState createState() => _MaskPageState();  
}

class _MaskPageState extends State<MaskPage> {  
  double width;
  String maskUrl = 'https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/';
  String storeUrl, salesUrl, storesByGeoUrl, storesByAddr;

  void setUrls() {
    storeUrl = maskUrl + 'stores/json?page=1';
    salesUrl = maskUrl + 'sales/json?page=1';
    storesByGeoUrl = maskUrl + 'storesByGeo/json';
    storesByAddr = maskUrl + 'storesByAddr/json';
  }

  void getData() async {

    http.Response response = await http.get(storeUrl,
      headers: {'Content-Type': 'application/json'}
    );

    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['storeInfos'];
    print(data[0]);
  }

  @override
  void initState() {
    super.initState();
    setUrls();
    getData();
  }



  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30),),
      child: Container(
        height: 90,
        width: width,
        decoration: BoxDecoration(color: Colors.teal[800]),
        child: Container(
          width: width,
          // padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "마스크 구매처",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    _selectedIndex = index;
    
    switch(index) {
      case 0:
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => HomePage()));
      break;
      case 1:
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => HospitalPage()));
      break;
      case 2:
      // Navigator.pushReplacement(context, 
      // MaterialPageRoute(builder: (context) => MaskPage()));
      break;
    }
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
        title: Text('마스크 구매'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => {
            Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage()))
          },
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
            // _dailyEntireStatistics(context),
          ],
        ),
      ),
    );
  }
}