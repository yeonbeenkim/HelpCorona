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
      // makeStoresMarker();
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
      // _markers.add(Marker(
      //   markerId: MarkerId("home"),
      //   position: latLng,
      //   rotation: newLocalData.heading,
      //   draggable: false,
      //   zIndex: 2,
      //   flat: true,
      //   anchor: Offset(0.5, 0.5),
      //   icon: BitmapDescriptor.fromBytes(imageData),
      // )
      // );
      // marker = Marker(
      //   markerId: MarkerId("home"),
      //   position: latLng,
      //   rotation: newLocalData.heading,
      //   draggable: false,
      //   zIndex: 2,
      //   flat: true,
      //   anchor: Offset(0.5, 0.5),
      //   icon: BitmapDescriptor.fromBytes(imageData)
      // );
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
            snippet: item.remainStat
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(item.hue)
          // position: LatLng(),
        )
        );
        }
        markerId++;
      });
    });
    // setState(() {
    //   _markers.add(Marker(
    //     markerId: MarkerId("aaaaaaaaaaa"),
    //     position: storePosition,
    //     infoWindow: InfoWindow(
    //       title: "모란시민약국",
    //       snippet: "재고없음"
    //     ),
    //     icon: BitmapDescriptor.defaultMarker,
    //   )
    //   );
    // });
  }
  // // _onAddMarkerButtonPressed() {
  // //   setState(() {
  // //     _markers.add(Marker(
  // //       markerId: MarkerId(_lastMapPosition.toString()),
  // //       position: _lastMapPosition,
  // //       infoWindow: InfoWindow(
  // //         title: 'This is a Title',
  // //         snippet: 'this is a snippet'
  // //       ),
  // //       icon: BitmapDescriptor.defaultMarker,
  // //     ));
  // //   });
  // // }
  
  // Completer<GoogleMapController> _controller = Completer();
  // static const LatLng _center = const LatLng(37.424707, 127.126923);
  // final Set<Marker> _markers2 = {};
  // LatLng _lastMapPosition = _center;
  // MapType _currentMapType = MapType.normal;

  // double myLatitude, myLongitude;
  // final Map<String, Marker> _markers = {};  

  // // void _getLocation() async {
  // //   var currentLocation = await Geolocator()
  // //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  // //   setState(() {
  // //     _markers.clear();
  // //     final marker = Marker(
  // //         markerId: MarkerId("curr_loc"),
  // //         position: LatLng(currentLocation.latitude, currentLocation.longitude),
  // //         infoWindow: InfoWindow(title: 'Your Location'),
  // //     );
  // //     _markers["Current Location"] = marker;
  // //   });
  // // }

  // _onMapCreated(GoogleMapController controller) {
  //   _controller.complete(controller);
  // }

  // _onCameraMove(CameraPosition position) {
  //   _lastMapPosition = position.target;
  // }

  // _onMapTypeButtonPressed() {
  //   setState(() {
  //     _currentMapType = _currentMapType == MapType.normal
  //     ? MapType.satellite
  //     : MapType.normal;
  //   });
  // }

  // // _onAddMarkerButtonPressed() {
  // //   setState(() {
  // //     _markers.add(Marker(
  // //       markerId: MarkerId(_lastMapPosition.toString()),
  // //       position: _lastMapPosition,
  // //       infoWindow: InfoWindow(
  // //         title: 'This is a Title',
  // //         snippet: 'this is a snippet'
  // //       ),
  // //       icon: BitmapDescriptor.defaultMarker,
  // //     ));
  // //   });
  // // }

  // static final CameraPosition _position1 = CameraPosition(
  //   bearing: 192.833,
  //   target: LatLng(45.531563, -122.677433),
  //   tilt: 59.440,
  //   zoom: 11.0,
  // );

  // Future<void> _goToPosition1() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  // }


  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36,
      ),
    );
  }  

  void dispose() {
    if(_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
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
      // appBar: AppBar(
      //   backgroundColor: Color(0xff2d4059),
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text('마스크 구매'),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     onPressed: () => {
      //       Navigator.pushReplacement(context,
      //       MaterialPageRoute(builder: (context) => HomePage()))
      //     },
      //   ),
      // ),
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
        // backgroundColor: Color(0xff2d4059),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue[700],
        // selectedItemColor: Color(0xffffd460),
        unselectedItemColor: Colors.grey[700],
        // unselectedItemColor: Colors.grey.shade400,
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
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 7,
      //   backgroundColor: Colors.white,
      //   // backgroundColor: Color(0xff2d4059),
      //   showSelectedLabels: true,
      //   showUnselectedLabels: true,
      //   selectedItemColor: Colors.blue[700],
      //   // selectedItemColor: Color(0xffffd460),
      //   unselectedItemColor: Colors.grey[700],
      //   // unselectedItemColor: Colors.grey.shade400,
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       title: Text('홈'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.local_hospital),
      //       title: Text('선별 진료소'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_shopping_cart),
      //       title: Text('마스크 구매'),
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
      // floatingActionButton: FloatingActionButton (
      //     child: Icon(Icons.location_searching),
      //     onPressed: () {
      //       isMapLocated = true;
      //       getCurrentLocation();
      //     },
      //   ),
      // floatingActionButton: button(makeStoresMarker(), Icons.add_location),
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
        // Padding(
        //   padding: EdgeInsets.all(16),
        //   child: Align(
        //     alignment: Alignment.topRight,
        //     child: Column(
        //       children: <Widget>[
        //         button(makeStoresMarker, Icons.add_location),
        //       ],
        //     ),
        //   ),
        // ),
        GoogleMap(
          // myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          markers: _markers,
          // markers: Set.of((marker != null) ? [marker] : []),
          circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
        // GoogleMap(
        //   mapType: MapType.normal,
        //   initialCameraPosition: CameraPosition(
        //     target: _center,
        //     zoom: 11,
        //   ),
        //   markers: _markers.values.toSet(),
        // ),
        // FloatingActionButton(
        //   onPressed: _getLocation,
        //   tooltip: 'Get Location',
        //   child: Icon(Icons.flag),
        // ),
        
        // GoogleMap(
        //   onMapCreated: _onMapCreated,
        //   initialCameraPosition: CameraPosition(
        //     target: _center,
        //     zoom: 11.0,
        //   ),
        //   mapType: _currentMapType,
        //   markers: _markers2,
        //   onCameraMove: _onCameraMove,
        // ),
        
        // Padding(
        //   padding: EdgeInsets.all(16),
        //   child: Align(
        //     alignment: Alignment.topRight,
        //     child: Column(
        //       children: <Widget>[
        //         // button(_onMapTypeButtonPressed, Icons.map),
        //         // SizedBox(height: 16,),
        //         // button(_onAddMarkerButtonPressed, Icons.add_location),
        //         // SizedBox(height: 16,),
        //         // button(_goToPosition1, Icons.location_searching),
        //       ],
        //     ),
        //   ),
        // ),
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

  //색상
  double hue = 0;
  //green:120 , yellow:60, red:0, 
  String remainStat = '';

  StoresInfo(
    this.addr,
    this.latitude,
    this.longitude,
    this.name,
    this.remain
  ) {
    setHueAndStat();
    print(this);
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

  // StoresInfo(this.addr, this.latitude, this.longitude, this.name, this.remain);

  factory StoresInfo.fromJson(dynamic json) {
    return StoresInfo(
      json['addr'] as String,
      json['lat'] as double,
      json['lng'] as double,
      json['name'] as String,
      json['remain_stat'] as String
    );
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.addr}, ${this.latitude}, ${this.longitude}, ${this.hue}, ${this.remainStat}}';
  }

}
