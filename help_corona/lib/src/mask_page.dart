import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_page.dart';
import 'hospital_page.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MaskPage extends StatefulWidget {
  MaskPage({Key key}) : super(key: key);

  @override
  _MaskPageState createState() => _MaskPageState();  
}

class _MaskPageState extends State<MaskPage> {  
  double width;
  String storesByGeoUrl = 'https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json?';
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  bool isMapLocated = true;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  } 

  String makeUrlFromLatlng(LatLng latlng) {
    String urlMaked;
    double _latitude = latlng.latitude, _longitude = latlng.longitude;
    urlMaked = storesByGeoUrl + "lat=" + _latitude.toString() + "&lng="+ _longitude.toString() + "&m=1000";
    return urlMaked;
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      if(isMapLocated == true){
      updateMarkerAndCircle(location, imageData);
      }

      if(_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if(_controller != null && isMapLocated == true) {
          isMapLocated = false;
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            // bearing: 30,
            // bearing: 192.8334901395799,
            target: LatLng(newLocalData.latitude, newLocalData.longitude),
            tilt: 0,
            zoom: 16,
          )));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    }
    on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latLng = LatLng(newLocalData.latitude, newLocalData.longitude);

    String urlMaked = makeUrlFromLatlng(latLng);
    getData(urlMaked);

    this.setState(() {
      circle = Circle(
        circleId: CircleId("car"),
        radius: newLocalData.accuracy + 30,
        strokeWidth: 1,
        zIndex: 1,
        strokeColor: Colors.blue,
        center: latLng,
        fillColor: Colors.blue[200].withAlpha(50),
      );

      makeStoresMarker();
    });
  }

  // List<dynamic> loadedStoresData = [];
  List<StoresInfo> loadedStoresData = [];
  void getData(String url) async {
    http.Response response = await http.get(url,
      headers: {'Content-Type': 'application/json'}
    );

    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['stores'];

    loadedStoresData = data.map((item) => StoresInfo.fromJson(item)).toList();

    makeStoresMarker();
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.424707, 127.126923),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  } 

  final Set<Marker> _markers = Set<Marker>();
  LatLng storePosition = LatLng(37.4297249, 127.1284766);
  
  makeStoresMarker() {
    int markerId = 0;
    setState(() {
      loadedStoresData.forEach((item) {
        if(item.remain != 'break' && item.remain != 'empty') {
        _markers.add(Marker(
          markerId: MarkerId(markerId.toString()),
          position: LatLng(item.latitude, item.longitude),
          infoWindow: InfoWindow(
            title: item.name,
            // snippet: item.makeStoreStateString()
            snippet: item.remainStat
          ),
          // infoWindow: ,
          icon: BitmapDescriptor.defaultMarkerWithHue(item.hue)
        )
        );
        }
        markerId++;
      });
    });
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
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xff2d4059),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            color: Colors.black54,
            blurRadius: 10
          )]
        ),
      child: BottomNavigationBar(
        // elevation: 7,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[700],
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
      ),),
      floatingActionButton: FloatingActionButton(
        elevation: 7,
        backgroundColor: Colors.white,
        child: Icon(Icons.my_location),
        foregroundColor: Colors.blue[700],
        onPressed: () {
          setState(() {
            isMapLocated = true;
            getCurrentLocation();
            makeStoresMarker();
          });
        },
      ),
      body: Stack(
      children: <Widget>[
        GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          markers: _markers,
          circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
      ],
    )
    );
  }
}

class StoresInfo {
  String addr;
  double latitude, longitude;
  String name;
  String remain;
  String stock_at;
  String created_at;

  //색상
  double hue = 0;
  //green:120 , yellow:60, red:0, 
  String remainStat = '';

  StoresInfo(
    this.name,
    this.addr,
    this.latitude,
    this.longitude,
    this.stock_at,    
    this.remain,
    this.created_at
  ) {
    setHueAndStat();
  }
  
  setHueAndStat(){
    if(this.remain == 'break') {
      this.hue = 67.0;
      this.remainStat = '판매중지';
    } else if (this.remain == 'empty') {
      this.hue = 30.0;
      this.remainStat = '1개 이하';
    } else if (this.remain == 'few') {
      this.hue = 0.0;
      this.remainStat = '2개 이상 30개 미만';
    } else if (this.remain == 'some') {
      this.hue = 58.0;
      this.remainStat = '30개 이상 100개 미만';
    } else if (this.remain == 'plenty') {
      this.hue = 138.0;
      this.remainStat = '100개 이상';
    }
  }

  factory StoresInfo.fromJson(dynamic json) {
    return StoresInfo(
      json['name'] as String,
      json['addr'] as String,
      json['lat'] as double,
      json['lng'] as double,
      json['stock_at'] as String,     
      json['remain_stat'] as String,
      json['created_at'] as String
    );
  }

  String makeStoreStateString() {
    String state = this.remainStat + '\n입고시간: ' + this.stock_at;
    // String state = this.remainStat + '\n입고시간: ' + this.stock_at + '\n데이터 생성' + this.created_at;
    return state;
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.addr}, ${this.latitude}, ${this.longitude}, ${this.hue}, ${this.stock_at}, ${this.remainStat}}';
  }

}