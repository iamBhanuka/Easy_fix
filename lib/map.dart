import 'dart:async';
import 'package:easy_fix/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:logger/logger.dart';

import 'infowindow.dart';

class PointObject {
  final Widget child;
  final LatLng location;

  PointObject({this.child, this.location});
}

class MapPage extends StatefulWidget {
  String documentID;
  MapPage({this.documentID});
  @override
  State createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController _controller;
  Set<Marker> allMarkers = Set();

  StreamSubscription _mapIdleSubscription;
  InfoWidgetRoute _infoWidgetRoute;

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
    if (widget.documentID == null) {
      UserProvider.getPhoneNumber().then((number) {
        setState(() {
          widget.documentID = number;
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
              target: LatLng(location.latitude, location.longitude), zoom: 12);

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

  _onTap(PointObject point) async {
    final RenderBox renderBox = context.findRenderObject();
    Rect _itemRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    _infoWidgetRoute = InfoWidgetRoute(
      child: point.child,
      buildContext: context,
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      mapsWidgetSize: _itemRect,
    );

    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            point.location.latitude - 0.0001,
            point.location.longitude,
          ),
          zoom: 15,
        ),
      ),
    );
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            point.location.latitude,
            point.location.longitude,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  void addMarkers() {
    Logger().i("Doc ID", widget.documentID);

    Firestore.instance
        .collection('mechanic')
        .document(widget.documentID)
        .get()
        .then((documentSnapshot) async {
      PointObject point = PointObject(
        child: Text(documentSnapshot.data['mechanic_name']),
        location: LatLng(
              (documentSnapshot.data['coods'] as GeoPoint).latitude,
              (documentSnapshot.data['coods'] as GeoPoint).longitude),
      );

      Logger().i("Snapshot", documentSnapshot);
      var marker = Marker(
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(15, 15), devicePixelRatio: 0.7),
              "assets/mechanic.png"),
          markerId: MarkerId(documentSnapshot.documentID),
          position: LatLng(
              (documentSnapshot.data['coods'] as GeoPoint).latitude,
              (documentSnapshot.data['coods'] as GeoPoint).longitude),
          onTap: () {
            _onTap(point);
          });
      setState(() {
        allMarkers.add(marker);
      });
    });
  }

  GlobalKey<ScaffoldState> _sacaffoldkey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    print(widget.documentID);
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
        onCameraMove: (newPosition) {
          _mapIdleSubscription?.cancel();
          _mapIdleSubscription = Future.delayed(Duration(milliseconds: 150))
              .asStream()
              .listen((_) {
            if (_infoWidgetRoute != null) {
              Navigator.of(context, rootNavigator: true)
                  .push(_infoWidgetRoute)
                  .then<void>(
                (newValue) {
                  _infoWidgetRoute = null;
                },
              );
            }
          });
        },
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
          splashColor: Colors.black,
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
