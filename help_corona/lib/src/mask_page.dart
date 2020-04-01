import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'hospital_page.dart';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';

class MaskPage extends StatefulWidget {
  MaskPage({Key key}) : super(key: key);

  @override
  _MaskPageState createState() => _MaskPageState();  
}

class _MaskPageState extends State<MaskPage> {  
  double width;
  String maskUrl = 'https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/';
  String storeUrl, salesUrl, storesByGeoUrl, storesByAddr;
  
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(37.424707, 127.126923);
  final Set<Marker> _markers2 = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  double myLatitude, myLongitude;
  final Map<String, Marker> _markers = {};

  void setUrls() {
    storeUrl = maskUrl + 'stores/json?page=1';
    salesUrl = maskUrl + 'sales/json?page=1';
    storesByGeoUrl = maskUrl + 'storesByGeo/json?';
    storesByAddr = maskUrl + 'storesByAddr/json';
  }

  void getData() async {

    // http.Response response = await http.get(storeUrl,
    //   headers: {'Content-Type': 'application/json'}
    // );
    http.Response response = await http.get(storesByAddr,
      headers: {'Content-Type': 'application/json'}
    );

    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes))['stores'];
    print(data[0]);
  }

  @override
  void initState() {
    super.initState();
    setUrls();
    getData();
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      _markers.clear();
      final marker = Marker(
          markerId: MarkerId("curr_loc"),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
      ? MapType.satellite
      : MapType.normal;
    });
  }

  // _onAddMarkerButtonPressed() {
  //   setState(() {
  //     _markers.add(Marker(
  //       markerId: MarkerId(_lastMapPosition.toString()),
  //       position: _lastMapPosition,
  //       infoWindow: InfoWindow(
  //         title: 'This is a Title',
  //         snippet: 'this is a snippet'
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));
  //   });
  // }

  static final CameraPosition _position1 = CameraPosition(
    bearing: 192.833,
    target: LatLng(45.531563, -122.677433),
    tilt: 59.440,
    zoom: 11.0,
  );

  Future<void> _goToPosition1() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_position1));
  }


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
      body: Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11,
          ),
          markers: _markers.values.toSet(),
        ),
        FloatingActionButton(
          onPressed: _getLocation,
          tooltip: 'Get Location',
          child: Icon(Icons.flag),
        ),
        
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