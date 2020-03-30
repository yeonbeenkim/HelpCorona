// import 'package:flutter/material.dart';
// import 'package:help_corona/src/helper/korea_location.dart';

// import 'home_page.dart';
// import 'mask_page.dart';
// // import 'package:help_corona/src/helper/korea_location.dart';
// import 'package:help_corona/src/helper/data_manager.dart';

// class Page extends StatefulWidget {
//   Page({Key key}) : super(key: key);

//   @override
//   _PageState createState() => _PageState();
// }

// class _PageState extends State<Page> {
//   double width;
//   bool _isSelect = false;
//   var _locations;
//   List<dynamic> _detailLocations;
//   var _selectedStateLocation, _selectedDetailLocation;

//   String value = "";
//   List<DropdownMenuItem<String>> menuitems = List();
//   bool disabledropdown = true;

//   Widget _viewAAA(BuildContext context) {
//     List<dynamic> strings;
//     List<Widget> list = new List<Widget>();
//     if (_isSelect == true) {
//         strings = DataManager.seoulHospitalData;
//       for (var i = 1; i < strings.length; i++) {
//         list.add(new Card(
//             margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
//             elevation: 20,
//             color: Colors.grey.shade300,
//             child: Column(children: <Widget>[
//               ListTile(
//                 title: Text(
//                   strings[i][3].toString(),
//                   style: TextStyle(color: Colors.black),
//                   textAlign: TextAlign.center,
//                 ),
//                 trailing: Icon(Icons.phone),
//               )
//             ])));
//       }
      
//     }
//     return new Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: list,
//     );
//   }

  

//   void createSecondDropdownMenu() {
//     for (int i = 0; i < _detailLocations.length; i++) {
//       menuitems.add(DropdownMenuItem<String>(
//         child: Center(
//           child: Text(
//             _detailLocations[i],
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         value: _detailLocations[i],
//       ));
//     }

//     setState(() {
//       print("aa");
//     });
//   }

//   void valuechanged(_value) {
//     _selectedStateLocation = _value;
//     // menuitems = [];
//     switch (_value) {
//       case '서울특별시':
//         _detailLocations = KoreaLocation.seoul;
//         break;
//       case '부산광역시':
//         _detailLocations = KoreaLocation.busan;
//         break;
//       case '대구광역시':
//         _detailLocations = KoreaLocation.daegu;
//         break;
//       case '인천광역시':
//         _detailLocations = KoreaLocation.incheon;
//         break;
//       case '광주광역시':
//         _detailLocations = KoreaLocation.gwangju;
//         break;
//       case '대전광역시':
//         _detailLocations = KoreaLocation.daejeon;
//         break;
//       case '울산광역시':
//         _detailLocations = KoreaLocation.ulsan;
//         break;
//       case '세종특별자치시':
//         _detailLocations = KoreaLocation.sejong;
//         break;
//       case '경기도':
//         _detailLocations = KoreaLocation.gyeonggido;
//         break;
//       case '강원도':
//         _detailLocations = KoreaLocation.gangwondo;
//         break;
//       case '충청북도':
//         _detailLocations = KoreaLocation.chungbuk;
//         break;
//       case '충청남도':
//         _detailLocations = KoreaLocation.chungnam;
//         break;
//       case '전라북도':
//         _detailLocations = KoreaLocation.jeonbuk;
//         break;
//       case '전라남도':
//         _detailLocations = KoreaLocation.jeonnam;
//         break;
//       case '경상북도':
//         _detailLocations = KoreaLocation.kyeongbuk;
//         break;
//       case '경상남도':
//         _detailLocations = KoreaLocation.kyeongnam;
//         break;
//       case '제주특별자치도':
//         _detailLocations = KoreaLocation.jeju;
//         break;
//     }
//     createSecondDropdownMenu();

//     setState(() {
//       _selectedStateLocation = _value;
//       value = _value;
//       disabledropdown = false;
//     });
//   }

//   void secondvaluechanged(_value) {
//     setState(() {
//       _selectedDetailLocation = _value;
//       _isLocationSelect = true;
//       // value = _value;
//     });
//   }

//   Widget _selectState(BuildContext context) {
//     return new Center(
//       child: new Theme(
//         data: Theme.of(context).copyWith(
//           canvasColor: Color(0xff2d4059),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.all(5),
//               child: new DropdownButton<String>(
//                 items: _locations.map<DropdownMenuItem<String>>(
//                         (_value) => new DropdownMenuItem<String>(
//                               value: _value,
//                               child: Center(
//                                 child: Text(
//                                   _value,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ))
//                     .toList(),
//                 onChanged: (_value) => valuechanged(_value),
//                 hint: Text(
//                   "시/도",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 value: _selectedStateLocation,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(5),
//               child: DropdownButton<String>(
//                 items: menuitems,
//                 onChanged: disabledropdown ? null : (_value) => secondvaluechanged(_value),
//                 hint: Text(
//                   "시/군/구",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 disabledHint: Text(
//                   "시/도를 선택하세요.",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 value: _selectedDetailLocation,
//               ),
//             ),
//             // Text("$value"),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _appBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: Color(0xff2d4059),
//       elevation: 0,
//       centerTitle: true,
//       title: Text('선별 진료소 목록'),
//       leading: IconButton(
//         icon: Icon(Icons.arrow_back_ios),
//         onPressed: () => {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (context) => HomePage()))
//         },
//       ),
//     );
//   }

//   Widget _buttomNavigation(BuildContext context) {
//     return BottomNavigationBar(
//       elevation: 0,
//       backgroundColor: Color(0xff2d4059),
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//       selectedItemColor: Color(0xffffd460),
//       unselectedItemColor: Colors.grey.shade400,
//       type: BottomNavigationBarType.fixed,
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           title: Text('홈'),
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.local_hospital),
//           title: Text('선별 진료소'),
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.add_shopping_cart),
//           title: Text('마스크 구매'),
//         ),
//       ],
//       currentIndex: _selectedIndex,
//       onTap: _onItemTapped,
//     );
//   }

//   int _selectedIndex = 1;
//   void _onItemTapped(int index) {
//     _selectedIndex = index;

//     switch (index) {
//       case 0:
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => HomePage()));
//         break;
//       case 1:
//         break;
//       case 2:
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => MaskPage()));
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff2d4059),
//       appBar: _appBar(context),
//       bottomNavigationBar: _buttomNavigation(context),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Divider(
//               color: Colors.orange,
//             ),
//             _selectState(context),
//             _viewAAA(context),
//           ],
//         ),
//       ),
//     );
//   }
// }
