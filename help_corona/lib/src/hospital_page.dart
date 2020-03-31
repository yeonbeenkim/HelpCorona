import 'package:flutter/material.dart';
import 'package:help_corona/src/helper/korea_location.dart';

import 'home_page.dart';
import 'mask_page.dart';
import 'package:help_corona/src/helper/data_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalPage extends StatefulWidget {
  HospitalPage({Key key}) : super(key: key);

  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  double width;
  bool disableSecondDropdown = true;
  bool isStateSelected = false;
  var koreaStates;
  List<dynamic> cityList = new List<dynamic>();
  List<dynamic> cityDBList = new List<dynamic>();
  var selectedState, selectedCity;

  List<DropdownMenuItem<String>> cityMenuItems = new List();

  Widget _viewHospital(BuildContext context) {
    List<Widget> cardList = new List<Widget>();
    List<dynamic> filteredStrings = new List<dynamic>();

    if (isStateSelected == true) {
      setState(() {
        for (int j = 0; j < cityDBList.length; j++) {
          if (cityDBList[j][2] == selectedCity) {
            filteredStrings.add(cityDBList[j]);
          }
        }
      });
      for (var i = 0; i < filteredStrings.length; i++) {
        cardList.add(new Card(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            elevation: 20,
            color: Colors.grey.shade300,
            child: Column(children: <Widget>[
              ListTile(
                title: Text(
                  filteredStrings[i][3].toString(),
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                // trailing: IconButton(
                //   icon: Icon(
                //     Icons.phone,
                //     color: Color(0xfff07b3f),
                //   ),
                //   onPressed: () => {
                //     launch("tel://${filteredStrings[i][4]}"),
                //   },
                // ),
                trailing: RawMaterialButton(
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  shape: CircleBorder(),
                  elevation: 2,
                  fillColor: Colors.green,
                  padding: EdgeInsets.all(10),
                  onPressed: () => {
                    launch("tel://${filteredStrings[i][4]}"),
                  },
                ),
              )
            ])));
      }
    }

    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: cardList,
    );
  }

  void _createSecondDropdownMenu(stateName) {
    // cityMenuItems = [];
    // stateName.forEach((item) => cityMenuItems.add(
    //   DropdownMenuItem<String> (
    //     child: Center(
    //       child: Text(
    //         item,
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),        
    //     value: item,
    //   )
    // ),);
    cityMenuItems.clear();
    // cityMenuItems[0] = new DropdownMenuItem(child: null);    
    for (int i = 0; i < cityList.length; i++) {
      cityMenuItems.add(DropdownMenuItem<String>(
        child: Center(
          child: Text(
            cityList[i],
            style: TextStyle(color: Colors.white),
          ),
        ),
        value: cityList[i],
      ));
    }
    disableSecondDropdown = false;
  }

  void _clickState(_value) {
    setState(() {
      selectedState = _value;
      selectedCity = null;
      disableSecondDropdown = true;
    });

    switch (selectedState) {
      case '서울특별시':
        cityList = KoreaLocation.seoul;
        cityDBList = DataManager.seoulHospitalData;
        break;
      case '부산광역시':
        cityList = KoreaLocation.busan;
        cityDBList = DataManager.busanHospitalData;
        break;
      case '대구광역시':
        cityList = KoreaLocation.daegu;
        cityDBList = DataManager.daeguHospitalData;
        break;
      case '인천광역시':
        cityList = KoreaLocation.incheon;
        cityDBList = DataManager.incheonHospitalData;
        break;
      case '광주광역시':
        cityList = KoreaLocation.gwangju;
        cityDBList = DataManager.gwangjuHospitalData;
        break;
      case '대전광역시':
        cityList = KoreaLocation.daejeon;
        cityDBList = DataManager.daejeonHospitalData;
        break;
      case '울산광역시':
        cityList = KoreaLocation.ulsan;
        cityDBList = DataManager.ulsanHospitalData;
        break;
      case '세종특별자치시':
        cityList = KoreaLocation.sejong;
        cityDBList = DataManager.sejongHospitalData;
        break;
      case '경기도':
        cityList = KoreaLocation.gyeonggido;
        cityDBList = DataManager.gyeonggiHospitalData;
        break;
      case '강원도':
        cityList = KoreaLocation.gangwondo;
        cityDBList = DataManager.gangwonHospitalData;
        break;
      case '충청북도':
        cityList = KoreaLocation.chungbuk;
        cityDBList = DataManager.chungbukHospitalData;
        break;
      case '충청남도':
        cityList = KoreaLocation.chungnam;
        cityDBList = DataManager.chungnamHospitalData;
        break;
      case '전라북도':
        cityList = KoreaLocation.jeonbuk;
        cityDBList = DataManager.jeonbukHospitalData;
        break;
      case '전라남도':
        cityList = KoreaLocation.jeonnam;
        cityDBList = DataManager.jeonnamHospitalData;
        break;
      case '경상북도':
        cityList = KoreaLocation.kyeongbuk;
        cityDBList = DataManager.kyeongbukHospitalData;
        break;
      case '경상남도':
        cityList = KoreaLocation.kyeongnam;
        cityDBList = DataManager.kyeongnamHospitalData;
        break;
      case '제주특별자치시':
        cityList = KoreaLocation.jeju;
        cityDBList = DataManager.jejuHospitalData;
        break;
    }

    _createSecondDropdownMenu(cityList);
  }

  void clickCity(_value) {
    setState(() {
      selectedCity = _value;
      isStateSelected = true;
    });
  }

  Widget _createBothDropdown(BuildContext context) {
    return new Center(
      child: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff2d4059),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: new DropdownButton<String>(
                items: koreaStates
                    .map<DropdownMenuItem<String>>(
                        (_value) => new DropdownMenuItem<String>(
                              value: _value,
                              child: Center(
                                child: Text(
                                  _value,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ))
                    .toList(),
                onChanged: (_value) => _clickState(_value),
                hint: Text(
                  "시/도",
                  style: TextStyle(color: Colors.white),
                ),
                value: selectedState,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: DropdownButton<String>(
                items: cityMenuItems,
                onChanged: disableSecondDropdown ? null : (_value) => clickCity(_value),
                hint: Text(
                  "시/군/구",
                  style: TextStyle(color: Colors.white),
                ),
                disabledHint: Text(
                  "시/도를 선택하세요.",
                  style: TextStyle(color: Colors.white),
                ),
                value: selectedCity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff2d4059),
      elevation: 0,
      centerTitle: true,
      title: Text('선별 진료소 목록'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()))
        },
      ),
    );
  }

  Widget _buttomNavigation(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    _selectedIndex = index;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MaskPage()));
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    koreaStates = KoreaLocation.koreaStates;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff2d4059),
      appBar: _appBar(context),
      bottomNavigationBar: _buttomNavigation(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Divider(
            //   color: Colors.orange,
            // ),
            _createBothDropdown(context),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
              "*표시 검사채취 가능한 곳    ",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            ),
            _viewHospital(context),
          ],
        ),
      ),
    );
  }
}
