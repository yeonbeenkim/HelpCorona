import 'package:flutter/material.dart';
import 'package:help_corona/src/helper/korea_location.dart';

import 'home_page.dart';
import 'mask_page.dart';
import 'package:help_corona/src/helper/data_manager.dart';

class HospitalPage extends StatefulWidget {
  HospitalPage({Key key}) : super(key: key);

  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  double width;
  bool disabledropdown = true;
  bool _isLocationSelect = false;
  var _locations;
  List<dynamic> _detailLocations = new List<dynamic>();
  List<dynamic> _detailLocationList = new List<dynamic>();
  var _selectedStateLocation, _selectedDetailLocation;

  String value = "";
  final List<DropdownMenuItem<String>> menuitems = new List<DropdownMenuItem<String>>();
  // List<DropdownMenuItem<String>> menuitems = new List<dynamic>();

  Widget _viewHospital(BuildContext context) {
    List<Widget> list = new List<Widget>();
    List<dynamic> strings = new List<dynamic>();
    // print("locationselect : " + _isLocationSelect.toString());
    // print("disabledropdown : " + disabledropdown.toString());
      
    
    if (_isLocationSelect == true) {
      // strings = DataManager.seoulHospitalData;
      // switch (_selectedStateLocation) {
      // case '서울특별시':
      //   _detailLocations = KoreaLocation.seoul;
      //   break;
      // case '부산광역시':
      //   _detailLocations = KoreaLocation.busan;
      //   break;
      // case '대구광역시':
      //   _detailLocations = KoreaLocation.daegu;
      //   break;
      // case '인천광역시':
      //   _detailLocations = KoreaLocation.incheon;
      //   break;
      // case '광주광역시':
      //   _detailLocations = KoreaLocation.gwangju;
      //   break;
      // case '대전광역시':
      //   _detailLocations = KoreaLocation.daejeon;
      //   break;
      // case '울산광역시':
      //   _detailLocations = KoreaLocation.ulsan;
      //   break;
      // case '세종특별자치시':
      //   _detailLocations = KoreaLocation.sejong;
      //   break;
      // case '경기도':
      //   _detailLocations = KoreaLocation.gyeonggido;
      //   break;
      // case '강원도':
      //   _detailLocations = KoreaLocation.gangwondo;
      //   break;
      // case '충청북도':
      //   _detailLocations = KoreaLocation.chungbuk;
      //   break;
      // case '충청남도':
      //   _detailLocations = KoreaLocation.chungnam;
      //   break;
      // case '전라북도':
      //   _detailLocations = KoreaLocation.jeonbuk;
      //   break;
      // case '전라남도':
      //   _detailLocations = KoreaLocation.jeonnam;
      //   break;
      // case '경상북도':
      //   _detailLocations = KoreaLocation.kyeongbuk;
      //   break;
      // case '경상남도':
      //   _detailLocations = KoreaLocation.kyeongnam;
      //   break;
      // case '제주특별자치도':
      //   _detailLocations = KoreaLocation.jeju;
      //   break;
      // }

      
    setState(() {
      // strings.clear();
      for(int j = 0; j < _detailLocationList.length; j++) {
        if(_detailLocationList[j][2] == _selectedDetailLocation) {
          strings.add(_detailLocationList[j]);
        }
        print("addaddadd" + strings.toString());
      }

      for (var i = 0; i < strings.length; i++) {
        list.add(
          new Card(
            margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
            elevation: 20,
            color: Colors.grey.shade300,
            child: Column(children: <Widget>[
              ListTile(
                title: Text(
                  strings[i][3].toString(),
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.phone),
              )
            ]
          )
        )
      );
      }
      // disabledropdown = true;
      // strings.clear();
    });

    }

    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: list,
    );
  }

  
  void createSecondDropdownMenu() async {
    // menuitems.clear();
    // menuitems = null;
    setState(() {
      menuitems.clear();
      menuitems[0] = null;
      print(_detailLocations);
    for (int i = 0; i < _detailLocations.length; i++) {      
      DropdownMenuItem<String> menuitem = new DropdownMenuItem<String>(
        child: Center(
          child: Text(
            _detailLocations[i],
            style: TextStyle(color: Colors.white),
          ),
        ),
        value: _detailLocations[i],
      );
      print(i);
      // print(menuitem.child);

      menuitems.add(menuitem);

      // menuitems[i] = menuitem;

      
      // menuitems.add(DropdownMenuItem<String>(
      //   child: Center(
      //     child: Text(
      //       _detailLocations[i],
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      //   value: _detailLocations[i],
      // ));
    }
    disabledropdown = false;
    print("menuuuuuuuuu" + menuitems.toString());
    // _isLocationSelect = false;
    
    });
  }

  void valuechanged(_value) {
    setState(() {
      // menuitems.clear();
      // menuitems = null;
      _selectedStateLocation = _value;
      // disabledropdown = true;
      _isLocationSelect = false;
    });

    print(_selectedStateLocation);

    switch (_selectedStateLocation) {
      case '서울특별시':
        _detailLocations = KoreaLocation.seoul;
        _detailLocationList = DataManager.seoulHospitalData;
        break;
      case '부산광역시':
        _detailLocations = KoreaLocation.busan;
        _detailLocationList = DataManager.busanHospitalData;
        break;
      case '대구광역시':
        _detailLocations = KoreaLocation.daegu;
        _detailLocationList = DataManager.daeguHospitalData;
        break;
      case '인천광역시':
        _detailLocations = KoreaLocation.incheon;
        _detailLocationList = DataManager.incheonHospitalData;
        break;
      case '광주광역시':
        _detailLocations = KoreaLocation.gwangju;
        _detailLocationList = DataManager.gwangjuHospitalData;
        break;
      case '대전광역시':
        _detailLocations = KoreaLocation.daejeon;
        _detailLocationList = DataManager.daejeonHospitalData;
        break;
      case '울산광역시':
        _detailLocations = KoreaLocation.ulsan;
        _detailLocationList = DataManager.ulsanHospitalData;
        break;
      case '세종특별자치시':
        _detailLocations = KoreaLocation.sejong;
        _detailLocationList = DataManager.sejongHospitalData;
        break;
      case '경기도':
        _detailLocations = KoreaLocation.gyeonggido;
        _detailLocationList = DataManager.gyeonggiHospitalData;
        break;
      case '강원도':
        _detailLocations = KoreaLocation.gangwondo;
        _detailLocationList = DataManager.gangwonHospitalData;
        break;
      case '충청북도':
        _detailLocations = KoreaLocation.chungbuk;
        _detailLocationList = DataManager.chungbukHospitalData;
        break;
      case '충청남도':
        _detailLocations = KoreaLocation.chungnam;
        _detailLocationList = DataManager.chungnamHospitalData;
        break;
      case '전라북도':
        _detailLocations = KoreaLocation.jeonbuk;
        _detailLocationList = DataManager.jeonbukHospitalData;
        break;
      case '전라남도':
        _detailLocations = KoreaLocation.jeonnam;
        _detailLocationList = DataManager.jeonnamHospitalData;
        break;
      case '경상북도':
        _detailLocations = KoreaLocation.kyeongbuk;
        _detailLocationList = DataManager.kyeongbukHospitalData;
        break;
      case '경상남도':
        _detailLocations = KoreaLocation.kyeongnam;
        _detailLocationList = DataManager.kyeongnamHospitalData;
        break;
      case '제주특별자치도':
        _detailLocations = KoreaLocation.jeju;
        _detailLocationList = DataManager.jejuHospitalData;
        break;
      }
    // disabledropdown = false;
    
    // createSecondDropdownMenu();

    // setState(() {
    //   _selectedStateLocation = _value;
    //   // value = _value;
    //   disabledropdown = false;
    // });
  }

  void secondvaluechanged(_value) {
    setState(() {
      _selectedDetailLocation = _value;
      _isLocationSelect = true;
      // strings = DataManager.seoulHospitalData;
      // value = _value;
    });
  }

  Widget _selectState(BuildContext context) {
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
                items: _locations.map<DropdownMenuItem<String>>(
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
                onChanged: (_value) => valuechanged(_value),
                hint: Text(
                  "시/도",
                  style: TextStyle(color: Colors.white),
                ),
                value: _selectedStateLocation,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: DropdownButton<String>(
                items: menuitems,
                onChanged: disabledropdown ? null : (_value) => secondvaluechanged(_value),
                hint: Text(
                  "시/군/구",
                  style: TextStyle(color: Colors.white),
                ),
                disabledHint: Text(
                  "시/도를 선택하세요.",
                  style: TextStyle(color: Colors.white),
                ),
                value: _selectedDetailLocation,
              ),
            ),
            // Text("$value"),
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
    // strings = ['aaa', 'bbb'];
    // strings = DataManager.seoulHospitalData;
    // menuitems.clear();
    _locations = KoreaLocation.koreaStates;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff2d4059),
      appBar: _appBar(context),
      bottomNavigationBar: _buttomNavigation(context),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Divider(
              color: Colors.orange,
            ),
            _selectState(context),
            // _selectLocation(context),
            // _selectDetailLocation(context),
            _viewHospital(context),
          ],
        ),
      ),
    );
  }
}
