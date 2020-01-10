import 'dart:async';
import 'package:easy_fix/logfirst.dart';
import 'package:easy_fix/providers/user_provider.dart';
import 'package:easy_fix/yourprofile.dart';
import 'package:flutter/material.dart';
import 'package:easy_fix/freeworks.dart';
import 'package:easy_fix/help.dart';
import 'package:easy_fix/payment.dart';
import 'package:easy_fix/setting.dart';
import 'package:easy_fix/yourworks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:easy_fix/bottomsheet.dart';

class HomePage extends StatefulWidget {
  String phoneNumber;
  HomePage({this.phoneNumber});
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController _controller;
  Set<Marker> allMarkers = Set();

  Location _locationService = Location();
  bool _permission = false;

  String inputaddr = '';

  addToList() async {
    final query = inputaddr;
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    Firestore.instance.collection('markers').add({
      'coords':
          new GeoPoint(first.coordinates.latitude, first.coordinates.longitude),
      'place': first.featureName
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  initState() {
    super.initState();
    initLocation();
    addMarkers();
  }

  initLocation() async {
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          final location = await _locationService.getLocation();

          final _currentCameraPosition = CameraPosition(
              target: LatLng(location.latitude, location.longitude), zoom: 15);

          _controller.animateCamera(
              CameraUpdate.newCameraPosition(_currentCameraPosition));
          var mapicon = await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(15, 15), devicePixelRatio: 0.7),
              "assets/customer.png");
          setState(() {
            allMarkers.add(
              Marker(
                icon: mapicon,
                markerId: MarkerId("my-location"),
                position: LatLng(location.latitude, location.longitude),
              ),
            );
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initLocation();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void addMarkers() {
    Firestore.instance.collection('markers').getDocuments().then((snapshots) {
      var machanicLocationIcon = snapshots.documents
          .toList()
          .map((DocumentSnapshot documentSnapshot) async => Marker(
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size(15, 15), devicePixelRatio: 0.7),
                  "assets/mechanic.png"),
              markerId: MarkerId(documentSnapshot.documentID),
              position: LatLng(
                  (documentSnapshot.data['coords'] as GeoPoint).latitude,
                  (documentSnapshot.data['coords'] as GeoPoint).longitude),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return BottomsheetPage(
                        documentID: documentSnapshot.documentID);
                  },
                );
              }))
          .toList();
      Future.wait(machanicLocationIcon).then((lsit) {
        print(lsit.length);
        setState(() {
          allMarkers.addAll(lsit);
        });
      });
    });
  }

  GlobalKey<ScaffoldState> _sacaffoldkey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _sacaffoldkey,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: new Text(
          "Easy Fix",
          style: TextStyle(color: Colors.orange),
        ),
        leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              _sacaffoldkey.currentState.openDrawer();
            }),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
         compassEnabled: true,
         mapToolbarEnabled: true,
         myLocationEnabled: true,
         myLocationButtonEnabled: true,
         rotateGesturesEnabled: true,
         trafficEnabled: true,
         
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: allMarkers,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.blue, Colors.lightBlueAccent]),
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ClipOval(
                          child: Image.asset(
                        'assets/Bhanu.JPG',
                        width: 100,
                        height: 100,
                      )),
                      Text(
                        'Bhanuka',
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      )
                    ],
                  ),
                )),
            CoustomListTile(Icons.person, "Profile", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => YourProfilePage()));
            }),
            CoustomListTile(Icons.play_for_work, "Your Works", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => WorksPage()));
            }),
            CoustomListTile(Icons.work, "Free Works", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => FreeWorkPage()));
            }),
            CoustomListTile(Icons.payment, "Payment", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PaymentPage()));
            }),
            CoustomListTile(Icons.settings, "Settings", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SettingPage()));
            }),
            CoustomListTile(Icons.help, "Help", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HelpPage()));
            }),
            CoustomListTile(Icons.lock, "Sign Out", () {
              UserProvider.deleteNumber().then((v) {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              });
            }),
          ],
        ),
      ),
    );
  }
}

class CoustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  CoustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 10.0),
      child: InkWell(
          splashColor: Colors.blueAccent,
          onTap: onTap,
          child: Container(
            height: 40,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(icon),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          text,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      )
                    ],
                  ),
                  Icon(Icons.arrow_right)
                ]),
          )),
    );
  }
}
