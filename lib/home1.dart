import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_fix/logfirst.dart';
import 'package:easy_fix/providers/user_provider.dart';
import 'package:easy_fix/yourprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  String userDoc;
  HomePage({this.userDoc});
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
    Firestore.instance.collection('mechanic').add({
      'coods':
          new GeoPoint(first.coordinates.latitude, first.coordinates.longitude),
      'address': first.featureName
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  initState() {
    super.initState();
    if (widget.userDoc == null) {
      UserProvider.getPhoneNumber().then((number) {
        Firestore.instance
            .collection("users")
            .document(widget.userDoc)
            .get()
            .then((doc) => {
                  setState(() {
                    // doc.data["phoneNumber"] = number;
                  })
                });
      });
    }

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
              target: LatLng(location.latitude, location.longitude), zoom: 13);

          addGasStations();

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
    Firestore.instance
        .collection('users')
        .where("userType", isEqualTo: "mechanic")
        .getDocuments()
        .then((snapshots) {
      var machanicLocationIcon = snapshots.documents
          .toList()
          .map((DocumentSnapshot documentSnapshot) async => Marker(
              icon: await BitmapDescriptor.fromAssetImage(
                  ImageConfiguration(size: Size(15, 15), devicePixelRatio: 0.7),
                  "assets/mechanic.png"),
              markerId: MarkerId(documentSnapshot.documentID),
              position: LatLng(
                  (documentSnapshot.data['coods'] as GeoPoint).latitude,
                  (documentSnapshot.data['coods'] as GeoPoint).longitude),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return BottomsheetPage(
                      documentID: documentSnapshot.documentID,
                      userId: widget.userDoc,
                    );
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
    print(widget.userDoc);
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
                    child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("users")
                      .document(widget.userDoc)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      DocumentSnapshot doc = snapshot.data;
                      Logger().i(doc.data);
                      return Column(
                        children: <Widget>[
                          ClipOval(
                              child: doc.data["Photo"] == null
                                  ? ClipOval(
                                      child: Image.asset(
                                      'assets/aaa.png',
                                      width: 100,
                                      height: 100,
                                    ))
                                  : Image.network(
                                      doc.data["Photo"],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )),
                          Text(
                            doc.data["First Name"],
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          )
                        ],
                      );
                    } else {
                      // TODO: Loading animation

                      // return Column(
                      //   children: <Widget>[
                      //     ClipOval(
                      //         child: Image.asset(
                      //       'assets/aaa.png',
                      //       width: 100,
                      //       height: 100,
                      //     )),
                      //     Text(
                      //       'fqjukqud',
                      //       style:
                      //           TextStyle(color: Colors.white, fontSize: 25.0),
                      //     )
                      //   ],
                      // );
                    }
                  },
                ))),
            CoustomListTile(Icons.person, "Profile", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          YourProfilePage(userDoc: widget.userDoc)));
            }),
            CoustomListTile(Icons.play_for_work, "Your Works", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          WorksPage(widget.userDoc)));
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
              FirebaseAuth.instance.signOut().then((_) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              });

              // UserProvider.deleteNumber().then((v) {
              //   Navigator.pop(context);
              //   Navigator.pop(context);
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (BuildContext context) => LoginPage()));
              // });
            }),
          ],
        ),
      ),
    );
  }

  void addGasStations() async {
    final location = await _locationService.getLocation();
    final res = await Dio().get(
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${location.latitude},${location.longitude}",
        queryParameters: {
          "key": "AIzaSyAFCDtNXwUO2RlzacQ7_yQNRblt0NraR5c",
          "radius": 1500,
          "type": "gas_station"
        });

    var mapicon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(15, 15), devicePixelRatio: 0.7),
        "assets/dick.png");

    setState(() {
      allMarkers.addAll(
        (res.data["results"] as List).map(
          (station) => Marker(
            icon: mapicon,
            markerId: MarkerId(station["id"]),
            position: LatLng(station["geometry"]["location"]["lat"],
                station["geometry"]["location"]["lng"]),
            infoWindow: InfoWindow(title: station["name"], snippet: "gg"),
            // "${station["opening_hours"]["open_now"] ? "open now" : "closed"}"),
          ),
        ),
      );
      print(allMarkers.length);
    });
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
